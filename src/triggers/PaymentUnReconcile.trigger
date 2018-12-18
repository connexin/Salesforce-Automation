trigger PaymentUnReconcile on Payment__c (after update) {
    List<Id> failedPayments = new List<Id>();
    List<Reconciliation__c> reconciliations = new List<Reconciliation__c>();
    List<Id> reconcileAccountIds = new List<Id>();
    
    for(Payment__c payment: trigger.new) {
        if(payment.Draft__c == false && payment.Confirmed__c == true && payment.Failed__c == true) {// && trigger.oldMap.get(payment.Id).Failed__c == false && trigger.oldMap.get(payment.Id).Amount_Allocated__c != payment.Amount_Allocated__c) {
            if(trigger.oldMap.get(payment.Id).Failed__c == false) {
                failedPayments.add(payment.Id);
                reconcileAccountIds.add(payment.Account__c);
            }
        }
    }
    if(failedPayments.size() == 0) {
        return;
    }
    
    //STEP 1: Unreconcile all reconciliations first related to all failed payments.
    List<Id> unreconcileIds = new List<Id>();
    reconciliations.addAll([SELECT Id, Reconciled__c, Balance__c FROM Reconciliation__c WHERE Id IN(SELECT Reconciliation__c FROM Ledger_Item__c WHERE Payment__c IN :failedPayments)]);
    if(reconciliations.size() > 0) {
        for(Reconciliation__c reconciliation: reconciliations) {
            unreconcileIds.add(reconciliation.Id);
            reconciliation.Reconciled__c = false;
        }
        update reconciliations;
    }
    
    //STEP 2: remove reconciliation ID from ledger Items and delete reconciliation
    List<Ledger_Item__c> unreconcileItems = new List<Ledger_Item__c>([SELECT Id, Reconciliation__c FROM Ledger_Item__c WHERE Reconciliation__c IN :unreconcileIds ]);
    if(unreconcileItems.size() > 0) {
        for(Ledger_Item__c item: unreconcileItems) {
            item.Reconciliation__c = null;
        }
        update unreconcileItems;
    }
    delete reconciliations;
    
    //Deleting Failed Payments Ledger Items
    List<Ledger_Item__c> paymentLedgerItems = new List<Ledger_Item__c>();
    paymentLedgerItems.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c IN :failedPayments]);
    delete paymentLedgerItems;
    
    //STEP 3: Set Payment flag to true in refunds
    Map<Id, Refund__c> refunds = new Map<Id, Refund__c>();
    refunds.putAll([SELECT Id, Amount__c, Draft__c, Confirmed__c, Failed__c, Payment__c, Payment_Failed__c FROM Refund__c WHERE Payment__c IN :failedPayments]);
    for(Id refundId: refunds.keySet()) {
        refunds.get(refundId).Payment_Failed__c = true;
    }
    update refunds.values();
    
    if(reconcileAccountIds.size() > 0) {
        List<Account> accounts = new List<Account>([SELECT Id FROM Account WHERE Id IN :reconcileAccountIds AND Auto_Reconcile__c = true]);
        Set<Id> autoReconcileAccountIds = new Set<Id>();
        for(Account acc: accounts) {
            autoReconcileAccountIds.add(acc.Id);
        }
        if(!autoReconcileAccountIds.isEmpty()) {
        	LedgerItem.matchLedgerItems(autoReconcileAccountIds, new Set<Id>(), new Set<Id>());
        }
    }
}