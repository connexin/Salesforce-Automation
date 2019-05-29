public class PaymentController {
    public Payment__c payment {get;set;}
    private ApexPages.StandardController stdController;
    
    public List<Reconciliation__c> reconciliationRelations {get;set;}
    public List<Fiscal_Document__c> salesInvoiceRelations {get;set;}
    public List<Fiscal_Document__c> creditNoteRelations {get;set;}
    public List<Payment__c> paymentRelations {get;set;}
    public List<Refund__c> refundRelations {get;set;}
    
    public Decimal totalInvoicesAllocated {get; set;}
    public Decimal totalCreditNotesAllocated {get; set;}
    public Decimal totalPaymentsAllocated {get; set;}
    public Decimal totalRefundsAllocated {get; set;}
    
    public Id documentId {get; set;}
    
    public Map<Id, Decimal> ledgerItems {get;set;}
    
    public String stripeToken {get;set;}
    public Boolean locked {get;set;}
    
    private Direct_Debit__c directDebit;
        
    public PaymentController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.payment = (Payment__c)this.stdController.getRecord();
        this.totalInvoicesAllocated = 0.00;
        this.totalCreditNotesAllocated = 0.00;
        this.totalPaymentsAllocated = 0.00;
        this.totalRefundsAllocated = 0.00;
        
        if (this.payment.Id != null) {
            this.getRelatedParents();
        }
    }
    
    public PaymentController(ApexPages.StandardSetController controller) {
        this.payment = new Payment__c();
        this.locked = false;
        this.payment.Source__c = '';
        if (System.currentPageReference().getParameters().get('amount') != null) {
            this.payment.Amount__c = Decimal.valueOf(System.currentPageReference().getParameters().get('amount'));
        }
        if (System.currentPageReference().getParameters().get('account') != null) {
            this.payment.Account__c = System.currentPageReference().getParameters().get('account');
            this.accountUpdated();
            
            Payment__c[] payments = [SELECT Id FROM Payment__c WHERE Draft__c = false AND Failed__c = false AND Confirmed__c = false AND Account__c = :this.payment.Account__c];
            if (payments.size() > 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'There are Pending Payments on the Account - are you sure you want to proceed?'));
            }
        }
        if (System.currentPageReference().getParameters().get('description') != null) {
            this.payment.Description__c = System.currentPageReference().getParameters().get('description');
        }
        if (System.currentPageReference().getParameters().get('amount') != null && System.currentPageReference().getParameters().get('account') != null && System.currentPageReference().getParameters().get('description') != null) {
            this.locked = true;
        }
        if (System.currentPageReference().getParameters().get('documentid') != null) {
            this.documentId = System.currentPageReference().getParameters().get('documentid');
            
            Fiscal_Document__c fiscalDocument = [SELECT Id, Auto_Proc__c, Dispute__c FROM Fiscal_Document__c WHERE Id = :this.documentId AND Draft__C = false];
            if (fiscalDocument.Auto_Proc__c == true) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Invoice has been Auto Processed - are you sure you want to proceed?'));
            }
            if (fiscalDocument.Dispute__c == true) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Invoice is in Dispute - are you sure you want to proceed?'));
            }
        }
        
        
        
    }
    
    public PageReference validateDraft() {
        this.payment.Draft__c = false;
        this.payment.Confirmed__c = true;
        
        try {
            update this.payment;
        } catch (Exception e) { 
            ApexPages.addMessages(e);
            return null;
        }
        
        return this.stdController.view();
    }
    
    public PageReference takePayment() {
        if (this.payment.Source__c == 'stripe') {
            StripeCharge charge = StripeAPI.createCharge(Integer.valueOf(this.payment.Amount__c * 100), this.stripeToken, this.payment.Description__c);
            if (charge.error) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,charge.error_desc));
                return null;
            }
            
            //Add Error Handling Code
            if (this.payment.Amount__c * 100 != charge.amount) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid Payment Amount'));
                return null;
            }
            
            payment.Reference__c = charge.Id;
            payment.Confirmed__c = true;
            
        } else if (this.payment.Source__c == 'go_cardless') {
            if (this.payment.Amount__c < 1) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Cannot take a Direct Debit for less than £1'));
                return null;
            }
            
            GoCardlessPayment goCardlessPayment = GoCardlessAPI.createCustomerPayment(this.directDebit.Name, Integer.valueOf(this.payment.Amount__c * 100), this.payment.Description__c, null);
            
            //Add Error Handling Code
            if (goCardlessPayment == null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Go Cardless Request Failed'));
                return null;
            }
            
            if (goCardlessPayment.amount != this.payment.Amount__c * 100) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Go Cardless Request Failed'));
                return null;
            }
            
            payment.Reference__c = goCardlessPayment.id;
            payment.Confirmed__c = false;
            payment.Charge_Date__c = goCardlessPayment.charge_date;
            
        } else { //Not a Stripe or Go Cardless Payment so Don't Insert Anything
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Invalid API'));
            return null;
        }
        
        //Prepare to Insert the Newly Created Payment
        payment.Draft__c = false;
        
        try {
            insert payment;
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        if (this.documentId != null) {
            Fiscal_Document__c invoice = new Fiscal_Document__c(
                Id = this.documentId,
                Auto_Proc__c = true
            );
            
            try {
                update invoice;
            } catch (Exception e) {
                ApexPages.addMessages(e);
                return null;
            }
        }
        
        //Redirect the User to the Newly Created Payment
        PageReference pg = new ApexPages.StandardController(payment).view();
        pg.setRedirect(true);
        return pg;
    }
    
    public void accountUpdated () {
        this.payment.Source__c = 'stripe';
        List<Direct_Debit__c> directDebitList = [SELECT Id, Name FROM Direct_Debit__c WHERE Account__c = :this.payment.Account__c];
        if (directDebitList.isEmpty()) {
            this.directDebit = null;
        } else {
            this.directDebit = directDebitList.get(0);
            this.payment.Source__c = 'go_cardless';
        }
    }
    
    //Limit the User's Source Selection to just Available Payment Gateways
    public List<SelectOption> getPaymentGatewayList() {
        List<SelectOption> options = new List<SelectOption>();
        if (this.payment.Account__c == null) {
            options.add(new SelectOption('', ''));
        } else {
            if (this.directDebit != null) {
                options.add(new SelectOption('go_cardless', 'Direct Debit'));
            }
            options.add(new SelectOption('stripe', 'Credit/Debit Card'));
        }
        return options;
    }
    
    private void getRelatedParents() {
        List<Id> relatedReconciliations = new List<Id>();
        this.ledgerItems = new Map<Id, Decimal>();
        for (Ledger_Item__c item : [SELECT Id, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Payment__c = :this.payment.Id]) {
            if (item.Reconciled__c == true) {
                relatedReconciliations.add(item.Reconciliation__c);
            }
        }
        
        if (relatedReconciliations.isEmpty()) {
            return;
        }
        
        List<Id> relatedFiscalDocuments = new List<Id>();
        List<Id> relatedPayments = new List<Id>();
        List<Id> relatedRefunds = new List<Id>();
        for (Ledger_Item__c item : [SELECT Amount__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Reconciliation__c IN :relatedReconciliations]) {
            if (item.Fiscal_Document__c != null) {
                if (item.Fiscal_Document__r.RecordType.DeveloperName == 'sales_invoice') {
                    this.totalInvoicesAllocated += item.Amount__c;
                } else if (item.Fiscal_Document__r.RecordType.DeveloperName == 'credit_note') {
                    this.totalCreditNotesAllocated += item.Amount__c;
                }
                if (this.ledgerItems.containsKey(item.Fiscal_Document__c)) {
                    this.ledgerItems.put(item.Fiscal_Document__c, this.ledgerItems.get(item.Fiscal_Document__c) + item.Amount__c);
                } else {
                    this.ledgerItems.put(item.Fiscal_Document__c, item.Amount__c);
                }
                relatedFiscalDocuments.add(item.Fiscal_Document__c);
            }
            if (item.Payment__c != null) {
                this.totalPaymentsAllocated += item.Amount__c;
                if (this.ledgerItems.containsKey(item.Payment__c)) {
                    this.ledgerItems.put(item.Payment__c, this.ledgerItems.get(item.Payment__c) + item.Amount__c);
                } else {
                    this.ledgerItems.put(item.Payment__c, item.Amount__c);
                }
                relatedPayments.add(item.Payment__c);
            }
            if (item.Refund__c != null) {
                this.totalRefundsAllocated += item.Amount__c;
                if (this.ledgerItems.containsKey(item.Refund__c)) {
                    this.ledgerItems.put(item.Refund__c, this.ledgerItems.get(item.Refund__c) + item.Amount__c);
                } else {
                    this.ledgerItems.put(item.Refund__c, item.Amount__c);
                }
                relatedRefunds.add(item.Refund__c);
            }
        }
        
        if (!relatedReconciliations.isEmpty()) {
            this.reconciliationRelations = [SELECT Id, Name, Credits__c, Debits__c, Reconciled__c FROM Reconciliation__c WHERE Id IN :relatedReconciliations];
        }
        if (!relatedFiscalDocuments.isEmpty()) {
            this.salesInvoiceRelations = [SELECT Id, Reference__c, Description__c, Subtotal__c, Date__c, Status__c FROM Fiscal_Document__c WHERE Id IN :relatedFiscalDocuments AND RecordType.DeveloperName = 'sales_invoice'];
            if (this.salesInvoiceRelations.isEmpty()) {
                this.salesInvoiceRelations = null;
            }
            this.creditNoteRelations = [SELECT Id, Reference__c, Description__c, Subtotal__c, Date__c, Status__c FROM Fiscal_Document__c WHERE Id IN :relatedFiscalDocuments AND RecordType.DeveloperName = 'credit_note'];
            if (this.creditNoteRelations.isEmpty()) {
                this.creditNoteRelations = null;
            }
        }
        if (!relatedPayments.isEmpty()) {
            this.paymentRelations = [SELECT Id, Reference__c, Amount__c, Date__c, Source__c, Status__c FROM Payment__c WHERE Id IN :relatedPayments];
        }
        if (!relatedRefunds.isEmpty()) {
            this.refundRelations = [SELECT Id, Name, Amount__c, Date__c, Status__c FROM Refund__c WHERE Id IN :relatedRefunds];
        }
    }
    
    public PageReference cancelPayment() {
        PageReference pg;
        if (this.documentId == null) {
            pg = new PageReference('/apex/AccountStatement?accountId=' + this.payment.Account__c);
        } else {
            pg = new PageReference('/apex/FiscalDocumentView?id=' + this.documentId);
        }
        pg.setRedirect(true);
        return pg;
    }
    
    public String getStripePublicAPIKey() {
        return StripeAPI.getPublicAPIKey();
    }
    
}