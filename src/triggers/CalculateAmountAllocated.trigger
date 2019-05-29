trigger CalculateAmountAllocated on Reconciliation__c (after update, after delete) {
	List<Ledger_item__c> ledgerItems = new List<Ledger_Item__c>();
    List<Id> reconciliationIds = new List<Id>();
    
    if(trigger.isDelete) {
        for(Reconciliation__c reconciliation: trigger.old){
            reconciliationIds.add(reconciliation.Id);
        }
    }
    
    if(trigger.isUpdate) {
        for(Reconciliation__c reconciliation: trigger.new) {
            if(reconciliation.Reconciled__c != trigger.oldMap.get(reconciliation.Id).Reconciled__c) {
                reconciliationIds.add(reconciliation.Id);
            }
        }   
    }
    
    if(!reconciliationIds.isEmpty()){
        ledgerItems.addAll([SELECT Id, Amount__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciliation__c IN :reconciliationIds]);
    }
    
    if(!ledgerItems.isEmpty()) {
        LedgerItem.calculateParentAmountAllocated(ledgerItems);
    }
    
    
}