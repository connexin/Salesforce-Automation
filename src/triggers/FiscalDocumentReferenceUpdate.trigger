trigger FiscalDocumentReferenceUpdate on Fiscal_Document__c (after insert, after update) {
    
    Map<Id, RecordType> recordTypes = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SObjectType = 'Fiscal_Document__c']);
    
    Fiscal_Document__c[] fiscalDocuments = new Fiscal_Document__c[]{};
    String month;
    
    for (Fiscal_Document__c fiscalDocument : trigger.new) {
    	
        if (fiscalDocument.Reference__c == null) {
            if (fiscalDocument.Date__c.month() == 1) {
                month = 'JAN';
            } else if (fiscalDocument.Date__c.month() == 2) {
                month = 'FEB';
            } else if (fiscalDocument.Date__c.month() == 3) {
                month = 'MAR';
            } else if (fiscalDocument.Date__c.month() == 4) {
                month = 'APR';
            } else if (fiscalDocument.Date__c.month() == 5) {
                month = 'MAY';
            } else if (fiscalDocument.Date__c.month() == 6) {
                month = 'JUN';
            } else if (fiscalDocument.Date__c.month() == 7) {
                month = 'JUL';
            } else if (fiscalDocument.Date__c.month() == 8) {
                month = 'AUG';
            } else if (fiscalDocument.Date__c.month() == 9) {
                month = 'SEP';
            } else if (fiscalDocument.Date__c.month() == 10) {
                month = 'OCT';
            } else if (fiscalDocument.Date__c.month() == 11) {
                month = 'NOC';
            } else if (fiscalDocument.Date__c.month() == 12) {
                month = 'DEC';
            }
        	
            Fiscal_Document__c myFiscalDocument = new Fiscal_Document__c(
            	Id = fiscalDocument.Id,
            	Reference__c = recordTypes.get(fiscalDocument.RecordTypeId).Name.substring(0, 1) + '/' + String.valueOf(fiscalDocument.Date__c.year()) + '/' + month + '/' + String.valueOf(fiscalDocument.Name)
            );
            fiscalDocuments.add(myFiscalDocument);
        }
        
    }
    
    update fiscalDocuments;
    
}