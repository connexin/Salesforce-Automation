trigger LedgerItemReconciliation on Ledger_Item__c (after insert) {
    Map<Id, Ledger_Item__c> oldLedgerMap = new Map<Id, Ledger_Item__c>();
    List<Id> fiscalDocuments = new List<Id>();
    List<Id> payments = new List<Id>();
    List<Id> refunds = new List<Id>();
    Set<Id> accountIds = new Set<Id>();
    List<Ledger_Item__c> ledgers = new List<Ledger_Item__c>();
    Set<Id> reconciliationIds = new Set<Id>();
    
    Boolean autoReconcile = true;
    
    for (Ledger_Item__c item: trigger.new) {
        if (item.Draft__c == true) {
            continue;
        }
        
        if (item.Fiscal_Document__c != null) {
            fiscalDocuments.add(item.Fiscal_Document__c);
        }
        
        if (item.Payment__c != null) {
            payments.add(item.Payment__c);
        }
        
        if (item.Refund__c != null) {
            refunds.add(item.Refund__c);
        }
    }
    
    //Manual Reconciliation. Should run only on update
    /*if(trigger.isUpdate) {
        
        for (Ledger_Item__c item : trigger.new) {  
            if (item.Reconciliation__c != null) {
                reconciliationIds.add(item.Reconciliation__c);
        }
        
        if (!reconciliationIds.isEmpty()) {
            Set<Id> autoReconciliations = new Set<Id>();
            for (Reconciliation__c reconciliation: [SELECT Id FROM Reconciliation__c WHERE Id IN :reconciliationIds AND Account__r.Auto_Reconcile__c = true]) {
                autoReconciliations.add(reconciliation.Id);
            }
            if (autoReconciliations.size() > 0) {
                reconciliationIds.removeAll(autoReconciliations);
            } else {
                autoReconcile = false;
            }
            
            if(!reconciliationIds.isEmpty()) {
                Reconciliation.reconcileReconciliation(reconciliationIds);
            }
        }
    }*/

    if (!autoReconcile || trigger.isUpdate) {
        return;
    }
    
    //Automatic Reconciliation. Should run only on insert
    
    
    if (fiscalDocuments.size() > 0) {
        for (Fiscal_Document__c fd: [SELECT Account__c, Account__r.Auto_Reconcile__c FROM Fiscal_Document__c WHERE Id IN :fiscalDocuments]) {
            if (fd.Account__r.Auto_Reconcile__c) {
                accountIds.add(fd.Account__c);
            }
        }
    }
    
    if (payments.size() > 0) {
        for (payment__c payment: [SELECT Account__c, Account__r.Auto_Reconcile__c FROM Payment__c WHERE Id IN :payments]) {
            if (payment.Account__r.Auto_Reconcile__c) {
                accountIds.add(payment.Account__c);
            }
        }
    }
    
    if (refunds.size() > 0) {
        for (Refund__c refund: [SELECT Payment__r.Account__c, Payment__r.Account__r.Auto_Reconcile__c FROM Refund__c WHERE Id IN :refunds]) {
            if (refund.Payment__r.Account__r.Auto_Reconcile__c) {
                accountIds.add(refund.Payment__r.Account__c);
            }
        }
    }
    
    if (accountIds.size() > 0) {
        LedgerItem.matchLedgerItems(accountIds, new Set<Id>(), new Set<Id>());
    }
}