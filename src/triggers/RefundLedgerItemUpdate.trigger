trigger RefundLedgerItemUpdate on Refund__c (after insert, after update) {
    Map<String, Id> recordTypeMap = new Map<String, Id>();
    
    for (RecordType recordType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Ledger_Item__c']) {
        recordTypeMap.put(recordType.DeveloperName, recordType.Id);
    }
    
    Boolean createLedgerItem;
    List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>();
    
    //Once a Refund is not Draft the Amount is Fixed and cannot change so we can create a Ledger Item and use this in reconciliations
    for (Refund__c refund : trigger.new) {
        createLedgerItem = false;
        
        //Check if we are inserting a Refund that is not Draft
        if (trigger.isInsert && refund.Draft__c == false) {
            createLedgerItem = true;
        //Check if we are updating a Refund that was Draft and is now not Draft
        } else if (trigger.isUpdate && trigger.oldMap.get(refund.Id).Draft__c == true && refund.Draft__c == false) {
            createLedgerItem = true;
        }
        
        //Create a Ledger Item
        if (createLedgerItem == true) {
            ledgerItems.add(new Ledger_Item__c(Refund__c = refund.Id, Draft__c = false, Amount__c = refund.Amount__c, RecordTypeId = recordTypeMap.get('debit')));
        }
        
    }
    
    if (!ledgerItems.isEmpty()) {
        insert ledgerItems;
    }
}