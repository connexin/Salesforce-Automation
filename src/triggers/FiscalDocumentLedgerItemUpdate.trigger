trigger FiscalDocumentLedgerItemUpdate on Fiscal_Document__c (after update) {
    //NB We don't need an insert trigger as the Fiscal Document has to be inserted before Fiscal Document Lines can be inserted
    //and the Fiscal Document Lines have to be inserted before the Fiscal Document can have a subtotal
    //and if the Fiscal Document doesn't have a subtotal then it can't not have a Draft Status
    
    Map<String, Id> recordTypeMap = new Map<String, Id>();
    
    for (RecordType recordType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType IN :new List<String>{'Ledger_Item__c', 'Fiscal_Document__c'}]) {
        recordTypeMap.put(recordType.DeveloperName, recordType.Id);
    }
    
    String itemRecordType;
    List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>();
    
    //Once a Fiscal Document is not Draft, the Amount is Fixed and cannot change so we can create a Ledger Item and use this in reconciliations
    for (Fiscal_Document__c fiscalDocument : trigger.new) {
        //Check if we are updating a Fiscal Document that was Draft and is now not Draft
        if (trigger.oldMap.get(fiscalDocument.Id).Draft__c == true && fiscalDocument.Draft__c == false ) {
            //Create a Ledger Item
            //Get the record type for the Ledger Item
            if (fiscalDocument.RecordTypeId == recordTypeMap.get('sales_invoice')) {
                itemRecordType = 'debit';
            } else if (fiscalDocument.RecordTypeId == recordTypeMap.get('credit_note')) {
                itemRecordType = 'credit';
            }
            
            ledgerItems.add(new Ledger_Item__c(Fiscal_Document__c = fiscalDocument.Id, Draft__c = false, Amount__c = fiscalDocument.Subtotal__c, RecordTypeId = recordTypeMap.get(itemRecordType)));
        }
        
    }
    
    if (!ledgerItems.isEmpty()) {
        insert ledgerItems;
    }
    
    //Email invoice to customer
    /*AccountClass.emailInvoice(trigger.newMap.keySet());
    
    for(Fiscal_Document__c fiscalDocument : trigger.new) {
        
    }*/
    
}