public class FiscalDocumentsController {
    private ApexPages.StandardController stdController;
    private Fiscal_Document__c fiscal_document;
    public Account account {get;set;}
    public Payment__c relatedPayment;
    public List<String> addressComponents {get;set;}
    
    public List<Ledger_Item__c> credit_notes {get; set;}
    public List<Ledger_Item__c> payments {get; set;}
    public List<Ledger_Item__c> invoices {get; set;}
    public List<Ledger_Item__c> refunds {get; set;}
    public Boolean renderPayments {get; set;}
    public Boolean renderCreditNotes {get; set;}
    public Boolean renderInvoices {get; set;}
    public Boolean renderRefunds {get; set;}
    
    public Decimal totalInvoicesAllocated {get; set;}
    public Decimal totalCreditNotesAllocated {get; set;}
    public Decimal totalPaymentsAllocated {get; set;}
    public Decimal totalRefundsAllocated {get; set;}
    
    public Decimal outstandingInvoiceTotal {get; set;}
    public Decimal currentInvoiceTotal {get; set;}
    public Decimal amountPaid {get; set;}
    
    public Id selReconciliation {get;set;}
    
    public List<Fiscal_Document__c> openInvoices {get; set;}
    
    public FiscalDocumentsController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.fiscal_document = (Fiscal_Document__c)this.stdController.getRecord();
        this.addressComponents = new List<String>();
        this.payments = new List<Ledger_Item__c>();
        this.credit_notes = new List<Ledger_Item__c>();
        this.openInvoices = new List<Fiscal_Document__c>();
        if (this.fiscal_document.Id != null) {
                Fiscal_Document__c fd = (Fiscal_Document__c)[SELECT Id, Account__c, Amount_Allocated__c, Subtotal__c FROM Fiscal_Document__c WHERE Id = :this.fiscal_document.Id];
                this.fiscal_document.Amount_Allocated__c = fd.Amount_Allocated__c;
                //this.fiscal_document.Subtotal__c = fd.Subtotal__c;
                this.account = (Account)[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, Type, Auto_Reconcile__c FROM Account WHERE Id = :fd.Account__c];
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
        this.totalInvoicesAllocated = 0.00;
        this.totalCreditNotesAllocated = 0.00;
        this.totalPaymentsAllocated = 0.00;
        this.totalRefundsAllocated = 0.00;
        this.outstandingInvoiceTotal = 0.00;
        this.currentInvoiceTotal = 0.00;
        this.amountPaid = 0.00;
        
        List<PriceBook2> priceBook = [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
        if (priceBook.size() > 0) {
                this.fiscal_document.Price_Book__c = priceBook.get(0).Id;
        }
        
        if (this.fiscal_document.Id != null) {
            this.getLinkedLedgerItems();
            /*this.openInvoices.addAll([SELECT Id, Reference__c, Subtotal__c, Amount_Allocated__c,  Due_Date__c, Date__c, Status__c, Amount_Unallocated__c, Net_Subtotal__c, Subtotal_Value__c, Tax_Subtotal__c, Tax_Value__c FROM Fiscal_Document__c WHERE RecordType.DeveloperName = 'sales_invoice' AND Account__c = :this.account.Id AND Id != :this.fiscal_document.Id AND Status__c NOT IN('Draft','Paid')]);
            if(this.openInvoices.size() > 0) {
                for(Fiscal_Document__c fd: openInvoices) {
                    this.outstandingInvoiceTotal += fd.Amount_Unallocated__c;
                }
            }
            
            system.debug(this.fiscal_document);
            system.debug(this.currentInvoiceTotal);
            system.debug(this.outstandingInvoiceTotal);
            system.debug(this.fiscal_document.Subtotal__c);
            system.debug(this.fiscal_document.Amount_Allocated__c);
            this.currentInvoiceTotal = this.outstandingInvoiceTotal + (this.fiscal_document.Subtotal__c - this.fiscal_document.Amount_Allocated__c);
            if(this.payments.size() > 0) {
                for(Ledger_Item__c item: this.payments) {
                    this.amountPaid += item.Amount__c;
                }
            }*/
        }
    }
    
    /*public void autoProcessConfirmTrue () {
        this.fiscal_document.Auto_Actions__c = true;
        this.validateDraft();
    }
    
    public void autoProcessConfirmFalse () {
        this.fiscal_document.Auto_Actions__c = false;
        this.validateDraft();
    }*/
    
    public PageReference takePayment() {
        PageReference pg = new PageReference('/apex/PaymentTake?amount=' + String.valueOf(this.fiscal_document.Subtotal__c - this.fiscal_document.Amount_Allocated__c) + '&account=' + this.fiscal_document.Account__c + '&description=' + this.fiscal_document.Reference__c + '&documentid=' + this.fiscal_document.Id);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference validateDraft() {
        this.fiscal_document.Draft__c = false;
        
        try {
            update this.fiscal_document;
        } catch (Exception e) {
            this.fiscal_document.Draft__c = true;
            ApexPages.addMessages(e);
            return null;
        }
        
        PageReference pg = new PageReference('/apex/FiscalDocumentActionsConfirmation?id=' + String.valueOf(this.fiscal_document.Id));
        pg.setRedirect(true);
        return pg;
        
    }
    
    public PageReference cloneFiscalDocumentToCreditNote () {
        List<Fiscal_Document_Line__c> fdlines = new List<Fiscal_Document_Line__c>();
        fdlines.addAll([SELECT Id, Amount__c, Description__c, Nominal_Code__c, Product__c, Quantity__c, Tax__c, Fiscal_Document__c FROM Fiscal_Document_Line__c WHERE Fiscal_Document__c =: this.fiscal_document.Id]);
        
        Fiscal_Document__c cloneFd = this.fiscal_document.clone(false, true, false, false);
        cloneFd.RecordTypeId = [Select Id From RecordType  Where SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'credit_note'].Id;
        cloneFd.Amount_Allocated__c = 0.00;
        cloneFd.Date__c = Date.today();
        cloneFd.Payment_Term__c = 0;
        cloneFd.Draft__c = true;
        cloneFd.Reference__c = '';
        cloneFd.Auto_Proc__c = false;
        cloneFd.Auto_Actions__c = false;
        cloneFd.Sent__c = false;
        insert cloneFd;
        
        for (Fiscal_Document_Line__c fdl: fdlines) {
            Fiscal_Document_Line__c tmpfdl = fdl.clone(false, true, false, false);
            tmpfdl.Fiscal_Document__c = cloneFd.Id;
            insert tmpfdl;
        }
        PageReference pg = new PageReference('/apex/FiscalDocumentView?id=' + String.valueOf(cloneFd.Id));
        pg.setRedirect(true);
        return pg;
    }
        
    public void getLinkedLedgerItems() {
        List<Id> reconciliationIds = new List<Id>();
        for(Ledger_Item__c item: [SELECT Id, Reconciliation__c, Reconciled__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Reconciled__c = true AND Fiscal_Document__c = :fiscal_document.Id]) {
            reconciliationIds.add(item.Reconciliation__c);
        }
        if(reconciliationIds.isEmpty()) {
            return;
        }
        
        this.credit_notes = new List<Ledger_Item__c>();
        this.payments = new List<Ledger_Item__c>();
        this.invoices = new List<Ledger_Item__c>();
        this.refunds = new List<Ledger_Item__c>();
        this.renderPayments = false;
        this.renderCreditNotes = false;
        this.renderInvoices = false;
        this.renderRefunds = false;
        
        for(Ledger_Item__c item: [SELECT Id, Amount__c, Fiscal_Document__c, Fiscal_Document__r.Description__c, Fiscal_Document__r.Date__c, Fiscal_Document__r.RecordType.DeveloperName, Payment__c, Payment__r.Description__c, Payment__r.Date__c, Refund__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciliation__c IN :reconciliationIds AND Fiscal_Document__r.RecordTypeId != :this.fiscal_document.RecordTypeId]) {
            if(item.Fiscal_Document__c != null && item.Fiscal_Document__r.RecordType.DeveloperName == 'credit_note') {
                this.credit_notes.add(item);
            }
            
            if(item.Fiscal_Document__c != null && item.Fiscal_Document__r.RecordType.DeveloperName == 'sales_invoice') {
                this.invoices.add(item);
            }
            
            if(item.Payment__c != null) {
                this.payments.add(item);
            }
            
            if(item.Refund__c != null) {
                this.refunds.add(item);
            }
        }
        
        if(this.payments.size() > 0) {
            system.debug('Related Payment Ledger Items: ' + this.payments);
            this.renderPayments = true;
        }
        
        if(this.refunds.size() > 0) {
            this.renderRefunds = true;
        }
        
        if(this.credit_notes.size() > 0) {
            this.renderCreditNotes = true;
        }
        
        if(this.invoices.size() > 0) {
            this.renderInvoices = true;
        }
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
        PageReference pg = new PageReference('/apex/FiscalDocumentPDF?id=' + String.valueOf(this.fiscal_document.Id));
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference viewCsv() {
        PageReference pg = new PageReference('/apex/FiscalDocumentCSV?id=' + String.valueOf(this.fiscal_document.Id));
        pg.setRedirect(false);
        return pg;
    }
    
    public void sendEmail() {
        Contact[] contacts = [SELECT Id, Email FROM Contact WHERE AccountId = :this.fiscal_document.Account__c AND Email != null];
        
        if (contacts.size() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.fiscal_document.RecordType.Name + ' could not be sent - No Contacts with Email Addresses exist on the Account'));
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
        
        mail.setSubject('Your Connexin ' + this.fiscal_document.RecordType.Name + ' - ' + this.fiscal_document.Reference__c);
        mail.setPlainTextBody('Hi,\n\nPlease find your Connexin ' + this.fiscal_document.RecordType.Name + ' attached\n\nIf you have any questions please do not hesitate to contact us\n\nKind Regards,\n\nThe Connexin Accounts Team\n01482 36 37 38');
        mail.setHtmlBody('Hi,<br /><br />Please find your Connexin ' + this.fiscal_document.RecordType.Name + ' attached<br /><br />If you have any questions please do not hesitate to contact us<br /><br />Kind Regards,<br /><br />The Connexin Accounts Team<br />01482 36 37 38<br />');
        
        PageReference pdf = Page.FiscalDocumentPDF;
        pdf.getParameters().put('id', (String)this.fiscal_document.Id);
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(this.fiscal_document.Reference__c + '.pdf');
        blob pdfBody;
        if(Test.isRunningTest()) { 
          pdfBody = blob.valueOf('Unit.Test');
        } else {
          pdfBody = pdf.getContent();
        }
        efa.setBody(pdfBody);
        
        PageReference csv = Page.FiscalDocumentCSV;
        csv.getParameters().put('id', (String)this.fiscal_document.Id);
        
        Messaging.EmailFileAttachment efa2 = new Messaging.EmailFileAttachment();
        efa2.setFileName(this.fiscal_document.Reference__c + '.csv');
        blob csvBody;
        if(Test.isRunningTest()) { 
          csvBody = blob.valueOf('Unit.Test');
        } else {
          csvBody = csv.getContent();
        }
        efa2.setBody(csvBody);
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa, efa2 });      
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        if (this.fiscal_document.Sent__c == false) {
            this.fiscal_document.Sent__c = true;
            update this.fiscal_document;
        }
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, this.fiscal_document.RecordType.Name + ' Sent to ' + String.join(toAddresses, ', ')));
    }
    
    public PageReference unreconcile() {
        Reconciliation__c tmpRecon = [SELECT Account__r.Auto_Reconcile__c FROM Reconciliation__c WHERE Id = :this.selReconciliation];
        
        if(tmpRecon.Account__r.Auto_Reconcile__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Cannot delete reconciliation for acounts set to reconcile automatically. Please set \'Auto Reconcile\' to disable before deleting reconciliations'));
            return null;
        }
        Reconciliation.unreconcileReconciliations(new Set<Id>{this.selReconciliation});
        
        return this.stdController.view();
    }
    
    public String getNewLine() {
        return '\n';
    }
}