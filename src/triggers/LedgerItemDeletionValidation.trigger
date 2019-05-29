trigger LedgerItemDeletionValidation on Ledger_Item__c (before delete) {
    
    List<Id> paymentIds = new List<Id>();
    
    for (Ledger_Item__c item : trigger.old) {
        if (item.Draft__c == false && item.Payment__c == null) {
            item.addError('Ledger Item cannot be Deleted');
        }
        
        if (item.Payment__c != null) {
        	paymentIds.add(item.Payment__c);
        }
    }
    
    Map<Id, Payment__c> payments = new Map<Id, Payment__c>([SELECT Id, Failed__c FROM Payment__c WHERE Id IN :paymentIds]);
    Payment__c payment;
    
    for (Ledger_Item__c item : trigger.old) {
        if (item.Payment__c == null) {
        	continue;
        }
        
        payment = payments.get(item.Payment__c);
        //Check that we're not deleting a Ledger Item
    	if(item.Draft__c == false && payment.Failed__c == false) {
            item.addError('Ledger Item cannot be Deleted');
        }
    }
    
}