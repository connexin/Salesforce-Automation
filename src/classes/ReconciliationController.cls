public class ReconciliationController {
    private Reconciliation__c currReconciliation;
    private ApexPages.StandardController stdController;
    
    public Map<Id, Decimal> ledgerItems {get;set;}
    public List<Fiscal_Document__c> salesInvoiceRelations {get;set;}
    public List<Fiscal_Document__c> creditNoteRelations {get;set;}
    public List<Payment__c> paymentRelations {get;set;}
    public List<Refund__c> refundRelations {get;set;}
    
    /*public Map<Id, Boolean> removedDocuments {get; set;}
    public Map<Id, Boolean> removedPayments {get; set;}
    public Map<Id, Boolean> removedRefunds {get; set;}*/
    
    public Decimal totalInvoicesAllocated {get; set;}
    public Decimal totalCreditNotesAllocated {get; set;}
    public Decimal totalPaymentsAllocated {get; set;}
    public Decimal totalRefundsAllocated {get; set;}
    
    public ReconciliationController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.currReconciliation = (Reconciliation__c)this.stdController.getRecord();

        this.totalInvoicesAllocated = 0.00;
        this.totalCreditNotesAllocated = 0.00;
        this.totalPaymentsAllocated = 0.00;
        this.totalRefundsAllocated = 0.00;
        
        this.getRelatedParents();
        
        List<Ledger_Item__c> invoices = [SELECT Id, Fiscal_Document__c, Reconciliation__c FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'Sales_Invoice' AND Reconciliation__c = :this.currReconciliation.Id];
        List<Ledger_Item__c> creditNotes = [SELECT Id, Fiscal_Document__c FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'Credit_Note' AND Reconciliation__c = :this.currReconciliation.Id];
        List<Ledger_Item__c> payments = [SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c != null AND Reconciliation__c = :this.currReconciliation.Id];
        List<Ledger_Item__c> refunds = [SELECT Id, Refund__c FROM Ledger_Item__c WHERE Refund__c != null AND Reconciliation__c = :this.currReconciliation.Id];
        
        /*this.removedDocuments = new Map<Id, Boolean>();
        for(Ledger_Item__c invoice: invoices) {
            this.removedDocuments.put(invoice.Fiscal_Document__c, false);
        }
        for(Ledger_Item__c creditNote: creditNotes) {
            this.removedDocuments.put(creditNote.Fiscal_Document__c, false);
        }
        
        this.removedPayments = new Map<Id, Boolean>();
        for(Ledger_Item__c payment: payments) {
            this.removedPayments.put(payment.Payment__c, false);
        }
        
        this.removedRefunds = new Map<Id, Boolean>();
        for(Ledger_Item__c refund: refunds) {
            this.removedRefunds.put(refund.Refund__c, false);
        }*/
    }
    
    /*public List<Fiscal_Document__c> getNonReconciliedFdList() {
        List<Fiscal_Document__c> fds = [SELECT Id, Name, Net_Subtotal__c, Tax_Subtotal__c, Subtotal__c FROM Fiscal_Document__c WHERE Draft__c = false];
        return fds;
    }
    
    public List<Ledger_Item__c> getInvoices() {
        List<Ledger_Item__c> invoices= [SELECT Id, Fiscal_Document__r.Name, Fiscal_Document__r.Net_Subtotal__c, Fiscal_Document__r.Tax_Subtotal__c, Fiscal_Document__r.Subtotal__c, Fiscal_Document__r.Amount_Allocated__c  FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'Sales_Invoice' AND Reconciliation__r.Id = :this.currReconciliation.Id];
        return invoices;
    }
    
    public List<Ledger_Item__c> getCreditNotes() {
        List<Ledger_Item__c> creditnotes= [SELECT Id, Fiscal_Document__r.Name, Fiscal_Document__r.Net_Subtotal__c, Fiscal_Document__r.Tax_Subtotal__c, Fiscal_Document__r.Subtotal__c, Fiscal_Document__r.Amount_Allocated__c  FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'Credit_Note' AND Reconciliation__r.Id = :this.currReconciliation.Id];
        return creditnotes;
    }
    
    public List<Ledger_Item__c> getPayments() {
        List<Ledger_Item__c> payments= [SELECT Id, Payment__r.Name, Payment__r.Amount__c, Payment__r.Date__c,  Payment__r.Amount_Allocated__c FROM Ledger_Item__c WHERE Payment__c != null AND Reconciliation__r.Id = :this.currReconciliation.Id];
        return payments;
    }
    public List<Ledger_Item__c> getRefunds() {
        List<Ledger_Item__c> refunds= [SELECT Id, Refund__r.Name, Refund__r.Amount__c, Refund__r.Date__c, Refund__r.Amount_Allocated__c FROM Ledger_Item__c WHERE Refund__c != null AND Reconciliation__r.Id = :this.currReconciliation.Id];
        return refunds;
    }*/
    
    private void getRelatedParents() {
        List<Id> relatedFiscalDocuments = new List<Id>();
        List<Id> relatedPayments = new List<Id>();
        List<Id> relatedRefunds = new List<Id>();
        this.ledgerItems = new Map<Id, Decimal>();
        for (Ledger_Item__c item : [SELECT Amount__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.Recordtype.DeveloperName FROM Ledger_Item__c WHERE Reconciliation__c = :this.currReconciliation.Id]) {
        	system.debug(item);
            if (item.Fiscal_Document__c != null) {
                if(item.Fiscal_Document__r.RecordType.DeveloperName == 'sales_invoice') {
                    this.totalInvoicesAllocated += item.Amount__c;
                } else {
                    this.totalCreditNotesAllocated += item.Amount__c;
                }
                this.ledgerItems.put(item.Fiscal_Document__c, item.Amount__c);
                relatedFiscalDocuments.add(item.Fiscal_Document__c);
            }
            if (item.Payment__c != null) {
                this.totalPaymentsAllocated += item.Amount__c;
                this.ledgerItems.put(item.Payment__c, item.Amount__c);
                relatedPayments.add(item.Payment__c);
            }
            if (item.Refund__c != null) {
                this.totalRefundsAllocated += item.Amount__c;
                this.ledgerItems.put(item.Refund__c, item.Amount__c);
                relatedRefunds.add(item.Refund__c);
            }
        }
        
        system.debug(relatedFiscalDocuments);
        
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
            this.refundRelations = [SELECT Id, Name, Amount__c, Date__c, Status__c FROM Refund__c WHERE Id IN :relatedRefunds];
        }
    }
    
    /*public void removeSelected() {
        List<Id> fiscalDocuments = new List<Id>();
        List<Id> payments = new List<Id>();
        List<Id> refunds = new List<Id>();
        for(Id key: this.removedDocuments.keySet()) {
            if(this.removedDocuments.get(key) == true) {
                fiscalDocuments.add(key);
            }
        }
        if(fiscalDocuments.size() > 0) {
            LedgerItem.removeReconciliation(fiscalDocuments);
        }
        
        for(Id key: this.removedPayments.keySet()) {
            if(this.removedPayments.get(key) == true) {
                payments.add(key);
            }
        }
        if(payments.size() > 0) {
            LedgerItem.removeReconciliation(payments);
        }
        
        for(Id key: this.removedRefunds.keySet()) {
            if(this.removedRefunds.get(key) == true) {
                refunds.add(key);
            }
        }
        if(refunds.size() > 0) {
            LedgerItem.removeReconciliation(refunds);
        }
    }*/
    
    public PageReference deleteReconciliation() {
        Set<Id> reconciliationIds = new Set<Id>();
        Reconciliation__c tmpRecon = new Reconciliation__c();
        tmpRecon = [SELECT Account__r.Auto_Reconcile__c FROM Reconciliation__c WHERE Id = :this.currReconciliation.Id];
        
        if(tmpRecon.Account__r.Auto_Reconcile__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Cannot delete reconciliation for acounts set to reconcile automatically. Please set \'Auto Reconcile\' to disable before deleting reconciliations'));
    		return null;
        }
        reconciliationIds.add(this.currReconciliation.Id);
        Reconciliation.unreconcileReconciliations(reconciliationIds);
        Schema.DescribeSObjectResult result = Reconciliation__c.SObjectType.getDescribe();
		PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
		pageRef.setRedirect(true);
		return pageRef;
    }
    
    /*public PageReference addItem() {
        PageReference pf = new PageReference('/apex/ReconciliationItem');
        pf.getParameters().put('accountId',this.currReconciliation.Account__c);
        pf.getParameters().put('reconciliationId',this.currReconciliation.Id);
        pf.setRedirect(true);
        return pf;
    }*/
}