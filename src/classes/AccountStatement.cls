public class AccountStatement {
    
    public Account account {get; set;}
    public Id accountId {get; set;}
    public Date startDate {get; set;}
    public Date endDate {get; set;}
    
    public List<SortedStatement> sortedList {get; set;}
    
    public Decimal startingDebit {get; set;}
    public Decimal startingCredit {get; set;}
    public Decimal startingInvoice {get; set;}
    public Decimal startingCreditNote {get; set;}
    public Decimal startingPayment {get; set;}
    public Decimal startingRefund {get; set;}
    public Decimal startingBalance {get; set;}
    
    public Decimal endingDebit {get; set;}
    public Decimal endingCredit {get; set;}
    public Decimal endingInvoice {get; set;}
    public Decimal endingCreditNote {get; set;}
    public Decimal endingPayment {get; set;}
    public Decimal endingRefund {get; set;}
    public Decimal endingBalance {get; set;}
    
    public Boolean outstandingOnly {get; set;}
    
    public String oddRowColour {get; set;}
    public List<String> addressComponents {get;set;}
    
    public AccountStatement() {
        this.accountId = System.currentPageReference().getParameters().get('accountid');
        if(this.accountid == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account ID not Specified'));
            return;
        }
        
        if(System.currentPageReference().getParameters().get('startdate') != null) {
            this.startDate = Date.valueOf(System.currentPageReference().getParameters().get('startdate'));
        } else {
            this.startDate = Date.today().addDays(-30);
        }
        
        if(System.currentPageReference().getParameters().get('enddate') != null) {
            this.endDate = Date.valueOf(System.currentPageReference().getParameters().get('enddate'));
        } else {
        	this.endDate = Date.today();    
        }
        
        if (system.currentPageReference().getParameters().get('unallocatedonly') != null) {
            this.outstandingOnly = Boolean.valueOf(system.currentPageReference().getParameters().get('unallocatedonly'));
        } else {
            this.outstandingOnly = false;
        }
        
        if (this.startDate > this.endDate) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'From date cannot be greater than To date'));
            return;
        }
        
        this.account = [SELECT Id, Name, Auto_Reconcile__c, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Type FROM Account WHERE Id = :this.accountId ];
        
        this.startingInvoice = 0.00;
        this.startingCreditNote = 0.00;
        this.startingPayment = 0.00;
        this.startingRefund = 0.00;
        this.startingBalance = 0.00;
        
        this.endingInvoice = 0.00;
        this.endingCreditNote = 0.00;
        this.endingPayment = 0.00;
        this.endingRefund = 0.00;
        this.endingBalance = 0.00;
        //this.outstandingOnly = false;
        if (this.outstandingOnly) {
            this.initStatementOutstandingOnly();
        } else {
        	this.initStatement();
        }
        
        Fiscal_Document__c[] invoices = [SELECT Id FROM Fiscal_Document__c WHERE RecordType.DeveloperName = 'sales_invoice' AND Dispute__c = true AND Account__c = :this.accountId];
        if (invoices.size() > 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'There are Disputed Invoices on the Account'));
        }
        
        this.addressComponents = new List<String>();
        if (this.account != null) {
            if (this.account.BillingStreet != null) {
                for (String part : this.account.BillingStreet.split('\\r\\n')) {
                    this.addressComponents.add(part);
                }
            }
            if (this.account.BillingCity != null) {
                this.addressComponents.add(this.account.BillingCity);
            }
            if (this.account.BillingState != null) {
                this.addressComponents.add(this.account.BillingState);
            }
            if (this.account.BillingPostalCode != null) {
                this.addressComponents.add(this.account.BillingPostalCode);
            }
            if (this.account.BillingCountry != null) {
                this.addressComponents.add(this.account.BillingCountry);
            }
        }
    }
    
    public void initStatement () {
        if(this.startDate > this.endDate || this.accountId == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'From date cannot be greater than To date'));
            return;
        } else if(this.startDate > Date.today() || this.endDate > Date.today()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'From/To Dates cannot be in future'));
            return;
        }
        this.outstandingOnly = false;
        
        this.sortedList = AccountClass.getSortedStatement (this.startDate, this.endDate, this.accountId, this.outstandingOnly);
        
        if(this.sortedList.isEmpty()) return;
        this.calculateStatementBalance();
    }
    
    public void initStatementOutstandingOnly () {
        if(this.startDate > this.endDate || this.accountId == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'From date cannot be greater than To date'));
            return;
        } else if(this.startDate > Date.today() || this.endDate > Date.today()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'From/To Dates cannot be in future'));
            return;
        }
        this.outstandingOnly = true;
        
        this.sortedList = AccountClass.getSortedStatement (this.startDate, this.endDate, this.accountId, this.outstandingOnly);
        
        if(this.sortedList.isEmpty()) return;
        this.calculateStatementBalance();
    }
    
    public void calculateStatementBalance () {
        if(this.sortedList.isEmpty()) return;
        Decimal balance = 0.00;
        this.startingBalance = 0.00;
        this.endingBalance = 0.00;
        
        this.startingBalance = (this.getInitialInvoice() + this.getInitialRefund()) - (this.getInitialPayment() + this.getInitialCreditNote());
        if(this.startingBalance == null) {
            this.startingBalance = 0.00;
        }
        balance = this.startingBalance;
        this.endingBalance =  (this.getLastInvoice() + this.getLastRefund()) - (this.getLastPayment() + this.getLastCreditNote()) ;
        
        for(SortedStatement statementLine: this.sortedList) {
            if(statementLine.objectType == 'Sales Invoice' || statementLine.objectType == 'Refund') {
                if(this.outstandingOnly) {
                    balance = balance + statementLine.outstanding_amount;
                } else {
                    balance = balance + statementLine.debit_amount;
                }
            } else {
                if(this.outstandingOnly) {
                    balance = balance - statementLine.outstanding_amount;
                } else {
                    balance = balance - statementLine.credit_amount;
                }
            }
            statementLine.balance_amount = balance.setScale(2);
        }
    }
    
    public Decimal getOpeningDebit() {
        this.startingDebit = this.getInitialInvoice() + this.getInitialRefund();
        return this.startingDebit;
    }
    
    public Decimal getOpeningCredit() {
        this.startingCredit = this.getInitialPayment() + this.getInitialCreditNote();
        return this.startingCredit;
    }
    
    public Decimal getClosingDebit() {
        this.endingDebit = this.getLastInvoice() + this.getLastRefund();
        return this.endingDebit;
    }
    
    public Decimal getClosingCredit() {
        this.endingCredit = this.getLastPayment() + this.getLastCreditNote();
        return this.endingCredit;
    }
    
    public Decimal getInitialInvoice() {
        AggregateResult[] invoice;
        this.startingInvoice = 0.00;
        if(this.outstandingOnly) {
            invoice = [SELECT SUM(Subtotal__c), SUM(Amount_Allocated__c) FROM Fiscal_Document__c WHERE Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'sales_invoice' AND Status__c NOT IN ('Paid')];
            if(invoice[0].get('expr0') != null && invoice[0].get('expr1') != null) {
                this.startingInvoice = (Decimal)invoice[0].get('expr0') - (Decimal)invoice[0].get('expr1');
            }
        } else {
            invoice = [SELECT SUM(Subtotal__c) FROM Fiscal_Document__c WHERE Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'sales_invoice'];
            this.startingInvoice = (Decimal)invoice[0].get('expr0');
        }
        return this.startingInvoice == null ? 0.00 : this.startingInvoice;
    }
    
    public Decimal getInitialCreditNote() {
        AggregateResult[] creditnote;
        this.startingCreditNote = 0.00;
        if(this.outstandingOnly) {
            creditnote = [SELECT SUM(Subtotal__c), SUM(Amount_Allocated__c) FROM Fiscal_Document__c WHERE Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'credit_note' AND Status__c NOT IN ('Allocated')];
            if(creditnote[0].get('expr0') != null && creditnote[0].get('expr1') != null) {
                this.startingCreditNote = (Decimal)creditnote[0].get('expr0') - (Decimal)creditnote[0].get('expr1');
            }
        } else {
            creditnote = [SELECT SUM(Subtotal__c) FROM Fiscal_Document__c WHERE Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'credit_note'];
            this.startingCreditNote = (Decimal)creditnote[0].get('expr0');
        }
        
        return this.startingCreditNote == null ? 0.00 : this.startingCreditNote;
    }
    
    public Decimal getInitialPayment() {
        AggregateResult[] payment;
        this.startingPayment = 0.00;
        if(this.outstandingOnly) {
            payment = [SELECT SUM(Amount__c), SUM(Amount_Allocated__c) FROM Payment__c WHERE Actual_Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Status__c NOT IN ('Paid - Allocated')];
            if(payment[0].get('expr0') != null && payment[0].get('expr1') != null) {
                this.startingPayment = (Decimal)payment[0].get('expr0') - (Decimal)payment[0].get('expr1');
            }
        } else {
            payment = [SELECT SUM(Amount__c) FROM Payment__c WHERE Actual_Date__c < :this.startDate AND Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false];
            this.startingPayment = (Decimal)payment[0].get('expr0');
        }
        
        return this.startingPayment == null ? 0.00 : this.startingPayment;
    }
    
    public Decimal getInitialRefund() {
        AggregateResult[] refund;
        this.startingRefund = 0.00;
        if(this.outstandingOnly) {
            refund = [SELECT SUM(Amount__c), SUM(Amount_Allocated__c) FROM Refund__c WHERE Date__c < :this.startDate AND Payment__r.Account__c = :this.accountId AND Draft__c = false AND Status__c NOT IN ('Confirmed - Allocated')];
            if(refund[0].get('expr0') != null && refund[0].get('expr1') != null) {
                this.startingRefund = (Decimal)refund[0].get('expr0') - (Decimal)refund[0].get('expr1');
            }
        } else {
            refund = [SELECT SUM(Amount__c) FROM Refund__c WHERE Date__c < :this.startDate AND Payment__r.Account__c = :this.accountId AND Draft__c = false];
            this.startingRefund = (Decimal)refund[0].get('expr0');
        }
        
        return this.startingRefund == null ? 0.00 : this.startingRefund;
    }
    
    public Decimal getLastInvoice() {
        AggregateResult[] invoice;
        this.endingInvoice = 0.00;
        if(this.outstandingOnly) {
            invoice = [SELECT SUM(Subtotal__c), SUM(Amount_Allocated__c) FROM Fiscal_Document__c WHERE Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'sales_invoice' AND Status__c NOT IN ('Paid')];
            if(invoice[0].get('expr0') != null && invoice[0].get('expr1') != null) {
                this.endingInvoice = (Decimal)invoice[0].get('expr0') - (Decimal)invoice[0].get('expr1');
                //this.endingInvoice = (Decimal)invoice[0].get('expr0');
            }
        } else {
            invoice = [SELECT SUM(Subtotal__c) FROM Fiscal_Document__c WHERE Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'sales_invoice'];
            this.endingInvoice = (Decimal)invoice[0].get('expr0');
        }
        
        return this.endingInvoice == null ? 0.00 : this.endingInvoice;
    }
    
    public Decimal getLastCreditNote() {
        AggregateResult[] creditnote;
        this.endingCreditNote = 0.00;
        if(this.outstandingOnly) {
            creditnote = [SELECT SUM(Subtotal__c), SUM(Amount_Allocated__c) FROM Fiscal_Document__c WHERE Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'credit_note' AND Status__c NOT IN ('Allocated')];
            if(creditnote[0].get('expr0') != null && creditnote[0].get('expr1') != null) {
                this.endingCreditNote = (Decimal)creditnote[0].get('expr0') - (Decimal)creditnote[0].get('expr1');
            }
        } else {
            creditnote = [SELECT SUM(Subtotal__c) FROM Fiscal_Document__c WHERE Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND RecordType.DeveloperName = 'credit_note'];
            this.endingCreditNote = (Decimal)creditnote[0].get('expr0');
        }
        
        return this.endingCreditNote == null ? 0.00 : this.endingCreditnote;
    }
    
    public Decimal getLastPayment() {
        AggregateResult[] payment;
        this.endingPayment = 0.00;
        if(this.outstandingOnly) {
            payment = [SELECT SUM(Amount__c), SUM(Amount_Allocated__c) FROM Payment__c WHERE Actual_Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Status__c NOT IN ('Paid - Allocated')];
            if(payment[0].get('expr0') != null && payment[0].get('expr1') != null) {
                this.endingPayment = (Decimal)payment[0].get('expr0') - (Decimal)payment[0].get('expr1');
            }
        } else {
            payment = [SELECT SUM(Amount__c) FROM Payment__c WHERE Actual_Date__c <= :this.endDate AND Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false];
            this.endingPayment = (Decimal)payment[0].get('expr0');
        }
        
        return this.endingPayment == null ? 0.00 : this.endingPayment;
    }
    
    public Decimal getLastRefund() {
        AggregateResult[] refund;
        this.endingRefund = 0.00;
        if(this.outstandingOnly) {
            refund = [SELECT SUM(Amount__c), SUM(Amount_Allocated__c) FROM Refund__c WHERE Date__c <= :this.endDate AND Payment__r.Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Payment_Failed__c = false AND Status__c NOT IN ('Confirmed - Allocated')];
            if(refund[0].get('expr0') != null && refund[0].get('expr1') != null) {
                this.endingRefund = (Decimal)refund[0].get('expr0') - (Decimal)refund[0].get('expr1');
                //this.endingRefund = (Decimal)refund[0].get('expr0');
            }
        } else {
            refund = [SELECT SUM(Amount__c) FROM Refund__c WHERE Date__c <= :this.endDate AND Payment__r.Account__c = :this.accountId AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Payment_Failed__c = false];
            this.endingRefund = (Decimal)refund[0].get('expr0');
        }
        
        return this.endingRefund == null ? 0.00 : this.endingRefund;
    }
    
    public Decimal getInitialBalance() {
        return this.startingBalance;
    }
    
    public Decimal getLastBalance() {
        return this.endingBalance;
    }
    
    public PageReference manualReconcile() {
        PageReference pf = new PageReference('/apex/ManualReconcileCreditItem');
        pf.getParameters().put('accountid',this.accountId);
        pf.setRedirect(true);
        return pf;
    }
    
    public PageReference takePayment() {
        PageReference pg = new PageReference('/apex/PaymentTake');
        Map<String, String> params = new Map<String, String>();
        params.put('account', String.valueOf(this.accountId));
        pg.getParameters().putAll(params);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference takeOutstandingPayment() {
        PageReference pg = new PageReference('/apex/PaymentTake');
        Map<String, String> params = new Map<String, String>();
        params.put('account', String.valueOf(this.accountId));
        params.put('amount', String.valueOf(this.getLastBalance() * -1));
        params.put('description', 'Outstanding Balance - ' + String.valueOf(this.accountId));
        pg.getParameters().putAll(params);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference cancel() {
        ApexPages.StandardController controller = new ApexPages.StandardController(this.account);
        return controller.view();
    }
    
    public String getTextColour() {
        if (this.account.Type == 'Residential') {
            return '#ec1c24';
        } else if (this.account.Type == 'Business' || this.account.Type == 'Reseller') {
            return '#00aff0';
        } else if (this.account.Type == 'Public Sector') {
            return '#00bb00';
        } else {
            return '#00bb00';
        }
    }
    
    public String getLogo() {
        if (this.account.Type == 'Residential') {
            return PageReference.forResource('Connexin_Home_Logo').getUrl();
        } else if (this.account.Type == 'Business' || this.account.Type == 'Reseller') {
            return PageReference.forResource('Connexin_Business_Logo').getUrl();
        } else if (this.account.Type == 'Public Sector') {
            return PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl();
        } else {
            return PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl();
        }
    }
    
    public String getFooterImage() {
        if (this.account.Type == 'Residential') {
            return PageReference.forResource('Connexin_Home_Footer').getUrl();
        } else if (this.account.Type == 'Business' || this.account.Type == 'Reseller') {
            return PageReference.forResource('Connexin_Business_Footer').getUrl();
        } else if (this.account.Type == 'Public Sector') {
            return PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl();
        } else {
            return PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl();
        }
    }
    
    public String getOddRowColour() {
        return 'white';
    }
    
    public String getEvenRowColour() {
        return '#f7f7f9';
    }
    
    public String getWebsite() {
        if (this.account.Type == 'Residential') {
            return 'home.connexin.co.uk';
        } else if (this.account.Type == 'Business' || this.account.Type == 'Reseller') {
            return 'business.connexin.co.uk';
        } else if (this.account.Type == 'Public Sector') {
            return 'smartcities.connexin.co.uk';
        } else {
            return 'smartcities.connexin.co.uk';
        }
    }

    public PageReference viewPdf() {
        PageReference pg = new PageReference('/apex/AccountStatementPDF?accountId=' + String.valueOf(this.accountId) + '&startdate=' + String.valueOf(this.startDate) + '&enddate=' + String.valueOf(this.endDate) + '&unallocatedonly=' + String.valueOf(this.outstandingOnly));
        pg.setRedirect(true);
        return pg;
    }
    
    public void sendEmail() {
        Contact[] contacts = [SELECT Id, Email FROM Contact WHERE AccountId = :this.accountId AND Email != null];
        
        if (contacts.size() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account Statement could not be sent - No Contacts with Email Addresses exist on the Account'));
            return;
        }
        
        Messaging.reserveSingleEmailCapacity(contacts.size());
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[]{};
        for (Contact contact: contacts) {
            toAddresses.add(contact.Email);
        }
        
        mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'support@connexin.co.uk'];
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        mail.setSubject('Your Connexin Account Statement');
        mail.setPlainTextBody('Hi,\n\nPlease find your Connexin account statement attached\n\nIf you have any questions please do not hesitate to contact us\n\nKind Regards,\n\nThe Connexin Accounts Team\n01482 36 37 38');
        mail.setHtmlBody('Hi,<br /><br />Please find your Connexin account statement attached<br /><br />If you have any questions please do not hesitate to contact us<br /><br />Kind Regards,<br /><br />The Connexin Accounts Team<br />01482 36 37 38<br />');
        
        PageReference pdf = Page.AccountStatementPDF;
        pdf.getParameters().put('accountId', (String)this.accountId);
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(this.accountId + '.pdf');
        blob pdfBody;
        if(Test.isRunningTest()) { 
          pdfBody = blob.valueOf('Unit.Test');
        } else {
          pdfBody = pdf.getContent();
        }
        efa.setBody(pdfBody);                                                    
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });      
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        /*if (this.fiscal_document.Sent__c == false) {
            this.fiscal_document.Sent__c = true;
            update this.fiscal_document;
        }*/
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Account Statement Sent to ' + String.join(toAddresses, ', ')));
    }
}