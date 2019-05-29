trigger RefundUnreconcile on Refund__c (after update) {
    Map<Id, Refund__c> refunds = new Map<Id, Refund__c>();
    List<Id> refundAccountIds = new List<Id>();
    for(Refund__c refund: trigger.new) {
        if((refund.Payment_Failed__c == true && trigger.oldMap.get(refund.Id).Payment_Failed__c == false) || (refund.Failed__c == true && trigger.oldMap.get(refund.Id).Failed__c == false))  {
            refunds.put(refund.Id, refund);
            refundAccountIds.add(refund.Payment__r.Account__c);
        }
    }
    
    if(refunds.isEmpty()) {
        return;
    }
    
    //STEP 1: Unreconcile reconciliations
    Map<Id, Reconciliation__c> reconciliations = new Map<Id, Reconciliation__c>();
    reconciliations.putAll([SELECT Id, Reconciled__c, Balance__c FROM Reconciliation__c WHERE Id IN(SELECT Reconciliation__c FROM Ledger_Item__c WHERE Refund__c IN :refunds.keySet())]);
    if(!reconciliations.isEmpty()) {
        for(Id reconciliationId: reconciliations.keySet()) {
            reconciliations.get(reconciliationId).Reconciled__c = false;
        }
        update reconciliations.values();
    }
    
    //STEP 2: remove reconciliation ID from ledger Items and delete reconciliation
    List<Ledger_Item__c> unreconcileItems = new List<Ledger_Item__c>([SELECT Id, Reconciliation__c FROM Ledger_Item__c WHERE Reconciliation__c IN :reconciliations.keySet() ]);
    if(unreconcileItems.size() > 0) {
        for(Ledger_Item__c item: unreconcileItems) {
            item.Reconciliation__c = null;
        }
        update unreconcileItems;
    }
    delete reconciliations.values();
    
    List<Account> accounts = new List<Account>([SELECT Id FROM Account WHERE Id IN :refundAccountIds AND Auto_Reconcile__c = true]);
    Set<Id> autoReconcileAccountIds = new Set<Id>();
    for(Account acc: accounts) {
        autoReconcileAccountIds.add(acc.Id);
    }
    if(!autoReconcileAccountIds.isEmpty()) {
        LedgerItem.matchLedgerItems(autoReconcileAccountIds, new Set<Id>(), new Set<Id>());
    }
    
}