trigger ReconciliationValidation on Reconciliation__c (before insert, before update) {
    /*Map<Id, Map<String, Decimal>> balance;
    if (trigger.isUpdate) {
        balance = Reconciliation.calculateBalance(trigger.newMap.keySet());
    }*/
    
    //Create a Map of Account Ids and the Reconciliations for those Accounts
    /*Map<Id, List<Reconciliation__c>> accounts = new Map<Id, List<Reconciliation__c>>();
    List<Reconciliation__c> openReconciliations;
    Set<Reconciliation__c> openReconciliationsSet;
    
    for (Reconciliation__c reconciliation : trigger.new) {
        if (accounts.containsKey(reconciliation.Account__c)) {
            //Get the Current List
            openReconciliations = accounts.get(reconciliation.Account__c);
            //Add the Open Reconciliation to the List
            openReconciliations.add(reconciliation);
            //Add the Updated List back into the Map
            accounts.put(reconciliation.Account__c, openReconciliations);
        } else {
          accounts.put(reconciliation.Account__c, new List<Reconciliation__c>{reconciliation});
        }
    }
    
    //Get all the Open Reconciliations for the parent Accounts of the updated/inserted Reconciliations
    for (Reconciliation__c openReconciliation : [SELECT Id, Account__c FROM Reconciliation__c WHERE Account__c IN :accounts.keySet() AND Reconciled__c = false]) {
        //if (accounts.containsKey(openReconciliation.Account__c)) {
            //Get the Current List
            openReconciliations = accounts.get(openReconciliation.Account__c);
            //Check for Duplicates in the List
            openReconciliationsSet = new Set<Reconciliation__c>(openReconciliations);
            if (openReconciliationsSet.contains(openReconciliation)) {
                continue;
            }
            //Add the Open Reconciliation to the List
            openReconciliations.add(openReconciliation);
            //Add the Updated List back into the Map
            accounts.put(openReconciliation.Account__c, openReconciliations);
        //} else {
            //Add the Open Reconciliaton to the Map
        //    accounts.put(openReconciliation.Account__c, new List<Reconciliation__c>{openReconciliation});
        //}
    }*/
    
    for (Reconciliation__c reconciliation : trigger.new) {
        if (reconciliation.Reconciled__c == true && reconciliation.Balance__c != 0) {
            reconciliation.addError('Reconciliation cannot be Reconciled when Balance is not 0');
        }
        
        if (trigger.isInsert && reconciliation.Credits__c != 0) {
            reconciliation.addError('Reconciliation cannot be inserted when Credit is not 0');
        }
        if (trigger.isInsert && reconciliation.Debits__c != 0) {
            reconciliation.addError('Reconciliation cannot be inserted when Debit is not 0');
        }
        
        /*if (trigger.isUpdate && trigger.oldMap.get(reconciliation.Id).Credits__c != reconciliation.Credits__c && reconciliation.Credits__c != balance.get(reconciliation.Id).get('credits')) {
            reconciliation.addError('Cannot change Credits');
        }
        
        
        if (trigger.isUpdate && trigger.oldMap.get(reconciliation.Id).Debits__c != reconciliation.Debits__c && reconciliation.Debits__c != balance.get(reconciliation.Id).get('debits')) {
            reconciliation.addError('Cannot change Debits');
        }*/
        
        //Skip Reconciliations that are Reconcilied or where there are no other Open Reconciliations
        //if (reconciliation.Reconciled__c == true || accounts.get(reconciliation.Account__c).size() <= 1) {
        //    continue;
        //}
        
        //Throw an Error on an Insert Trigger
        //if (trigger.isInsert) {
            //reconciliation.addError('Cannot have more than 1 Open Reconcilations per Account');
        //    continue;
        //}
    }
    
}