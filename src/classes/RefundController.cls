public class RefundController {
    private Refund__c refund;
    private ApexPages.StandardController stdController;
    
    public Payment__c parentPayment {get;set;}
    
    public List<Reconciliation__c> reconciliationRelations {get;set;}
    public List<Fiscal_Document__c> salesInvoiceRelations {get;set;}
    public List<Fiscal_Document__c> creditNoteRelations {get;set;}
    public List<Payment__c> paymentRelations {get;set;}
    public List<Refund__c> refundRelations {get;set;}
    
    public Decimal totalInvoicesAllocated {get; set;}
    public Decimal totalCreditNotesAllocated {get; set;}
    public Decimal totalPaymentsAllocated {get; set;}
    public Decimal totalRefundsAllocated {get; set;}
    
    public Map<Id, Decimal> ledgerItems {get;set;}
    
    public RefundController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.refund = (Refund__c)this.stdController.getRecord();
        
        if (this.refund.Payment__c != null) {
            this.parentPayment = [SELECT Id, Source__c FROM Payment__c WHERE Id = :this.refund.Payment__c];
        }
        
        this.totalInvoicesAllocated = 0.00;
        this.totalCreditNotesAllocated = 0.00;
        this.totalPaymentsAllocated = 0.00;
        this.totalRefundsAllocated = 0.00;
        
        if (this.refund.Id != null) {
            this.getRelatedParents();
        }
    }
    
    public PageReference validateDraft() {
        this.refund.Draft__c = false;
        
        try {
            update this.refund;
        } catch (Exception e) { 
            ApexPages.addMessages(e);
            return null;
        }
        
        return this.stdController.view();
    }
    
    public PageReference createRefund() {
        Payment__c payment = [SELECT Id, Amount__c, Amount_Refunded__c, Source__c, Reference__c, Confirmed__c FROM Payment__c WHERE Id = :this.refund.Payment__c];
        
        if (this.refund.Amount__c > payment.Amount__c - payment.Amount_Refunded__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Refund amount cannot be greater than Payment amount'));
            return null;
        }
        
        if (payment.Confirmed__c == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Refund cannot be created until Payment is confirmed'));
            return null;
        }
        
        if (payment.Source__c == 'stripe') {
            StripeCharge refunded = StripeAPI.createRefund(Integer.valueOf(this.refund.Amount__c * 100), payment.Reference__c);
            if (refunded.error) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,refunded.error_desc));
                return null;
            }
            
            this.refund.Reference__c = refunded.Id;
            this.refund.Confirmed__c = true;
            this.refund.Failed__c = false;
            this.refund.Payment_Failed__c = false;
        } else if (payment.Source__c == 'go_cardless') {
            GoCardlessRefund refunded = GoCardlessAPI.createCustomerRefund(payment.Reference__c, Integer.valueOf(this.refund.Amount__c * 100), 'Connexin');
            if(refunded.error) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,refunded.error_desc));
                return null;
            }
            refund.Reference__c = refunded.id;
            refund.Confirmed__c = true;
            refund.Failed__c = false;
            refund.Payment_Failed__c = false;
        } else if (payment.Source__c == 'manual') {
            return this.stdController.save();
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid API'));
            return null;
        }
        
        this.refund.Draft__c = false;
        try {
            insert refund;
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        //Redirect the User to the Newly Created Payment
        PageReference pg = new ApexPages.StandardController(refund).view();
        pg.setRedirect(true);
        return pg;
    }
    
    private void getRelatedParents() {
        List<Id> relatedReconciliations = new List<Id>();
        this.ledgerItems = new Map<Id, Decimal>();
        for (Ledger_Item__c item : [SELECT Id, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Refund__c = :this.refund.Id]) {
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
            this.salesInvoiceRelations = [SELECT Id, Reference__c, Subtotal__c, Date__c, Status__c FROM Fiscal_Document__c WHERE Id IN :relatedFiscalDocuments AND RecordType.DeveloperName = 'sales_invoice'];
            if (this.salesInvoiceRelations.isEmpty()) {
                this.salesInvoiceRelations = null;
            }
            this.creditNoteRelations = [SELECT Id, Reference__c, Subtotal__c, Date__c, Status__c FROM Fiscal_Document__c WHERE Id IN :relatedFiscalDocuments AND RecordType.DeveloperName = 'credit_note'];
            if (this.creditNoteRelations.isEmpty()) {
                this.creditNoteRelations = null;
            }
        }
        if (!relatedPayments.isEmpty()) {
            this.paymentRelations = [SELECT Id, Reference__c, Amount__c, Date__c, Source__c, Status__c FROM Payment__c WHERE Id IN :relatedPayments];
        }
        if (!relatedRefunds.isEmpty()) {
            this.refundRelations = [SELECT Id, Reference__c, Amount__c, Date__c, Status__c FROM Refund__c WHERE Id IN :relatedRefunds];
        }
    }
    
}