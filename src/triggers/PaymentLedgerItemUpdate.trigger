trigger PaymentLedgerItemUpdate on Payment__c (after insert, after update) {
    Map<String, Id> recordTypeMap = new Map<String, Id>();
    
    for (RecordType recordType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Ledger_Item__c']) {
        recordTypeMap.put(recordType.DeveloperName, recordType.Id);
    }
    
    Boolean createLedgerItem;
    List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>();
    
    //Once a Payment is not Draft and not Pending the Amount is Fixed and cannot change so we can create a Ledger Item and use this in reconciliations
    for (Payment__c payment : trigger.new) {
        createLedgerItem = false;
        
        //Check if we are inserting a Payment that is not Draft and is Confirmed and not failed
        if (trigger.isInsert && payment.Draft__c == false && payment.Confirmed__c == true && payment.Failed__c == false) {
            createLedgerItem = true;
        //Check if we are updating a Payment that was Draft and/or Pending and/or Failed and its now not Draft and is Confirmed and not Failed
        } else if (trigger.isUpdate && (trigger.oldMap.get(payment.Id).Draft__c == true || trigger.oldMap.get(payment.Id).Confirmed__c == false || trigger.oldMap.get(payment.Id).Failed__c == true) && payment.Draft__c == false && payment.Confirmed__c == true && payment.Failed__c == false) {
            createLedgerItem = true;
        }
        
        //Create a Ledger Item
        if (createLedgerItem == true) {
            ledgerItems.add(new Ledger_Item__c(Payment__c = payment.Id, Draft__c = false, Amount__c = payment.Amount__c, RecordTypeId = recordTypeMap.get('credit')));
        }
        
    }
    
    if (!ledgerItems.isEmpty()) {
        insert ledgerItems;
    }
    
}