trigger AccountAutoReconcile on Account (after update) {
    Set<Id> accountIds = new Set<Id>();
    Set<Id> reconcileAccountIds = new Set<Id>();
    Set<Id> reconciliationIds = new Set<Id>();
    Map<Id, Account> newAccountMap = new Map<Id, Account>(trigger.newMap);
    Map<Id, Account> oldAccountMap = new Map<Id, Account>(trigger.oldMap);
    
    //Step 1: get all account Ids
    for(Id accountId: newAccountMap.keySet()) {
        if(newAccountMap.get(accountId).Auto_Reconcile__c && !oldAccountMap.get(accountId).Auto_Reconcile__c) {
            accountIds.add(accountId);
        }
    }
    
    if(accountIds.size() == 0) {
        return;
    }
    
    //Step 2: get all accountids that have unreconciled ledgers
    List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>([SELECT Id, Reconciliation__c, Payment__c, Fiscal_Document__c, Refund__c, Payment__r.Account__c, Refund__r.Payment__r.Account__c, Fiscal_Document__r.Account__c FROM Ledger_Item__c WHERE Draft__c = false AND (Payment__r.Account__c IN :accountIds OR Refund__r.Payment__r.Account__c IN:accountIds OR Fiscal_Document__r.Account__c IN:accountIds) AND Reconciled__c = false]);
    for(Ledger_Item__c item: ledgerItems) {
        //Step 3: make a list of associated reconciliations that were not reconciled
        if(item.Reconciliation__c != null) {
            reconciliationIds.add(item.Reconciliation__c);
            item.Reconciliation__c = null;
        }
        
        if(item.Fiscal_Document__c != null) {
            reconcileAccountIds.add(item.Fiscal_Document__r.Account__c);
        }
        
        if(item.Payment__c != null) {
            reconcileAccountIds.add(item.Payment__r.Account__c);
        }
        
        if(item.Refund__c != null) {
            reconcileAccountIds.add(item.Refund__r.Payment__r.Account__c);
        }
        
    }
    
    //Step 4: deleted existing associated unreconciled reconciliations and remove reconciliation foreign key from ledgers
    if(reconciliationIds.size() > 0) {
        update ledgerItems;
        List<Reconciliation__c> reconciliations = new List<Reconciliation__c>([SELECT Id, Reconciled__c FROM Reconciliation__c WHERE Id IN :reconciliationIds]);
        for(Reconciliation__c reconciliation: reconciliations) {
            reconciliation.Reconciled__c = false;
        }
        update reconciliations;
        delete reconciliations;
    }
    
    //Step 5: delete any reconciliations that were not reconciled and not linked with any ledger items
    List<Reconciliation__c> reconciliations = new List<Reconciliation__c>([SELECT Id FROM Reconciliation__c WHERE Reconciled__c = false AND Account__c IN :accountIds]);
    delete reconciliations;
    
    //Step 6: initiate auto reconciliations
    if(reconcileAccountIds.size() > 0) {
        LedgerItem.matchLedgerItems(reconcileAccountIds, new Set<Id>(), new Set<Id>());
    }
}