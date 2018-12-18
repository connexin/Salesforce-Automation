trigger FiscalDocumentLineAfterUpdate on Fiscal_Document_Line__c (after insert, after update) {
    
    List<Fiscal_Document_Line__c> fiscalDocumentLines = new List<Fiscal_Document_Line__c>();
    Map<Id, Decimal> taxIds = new Map<Id, Decimal>();
    
    for (Fiscal_Document_Line__c fiscalDocumentLine : trigger.new) {
        if ((trigger.isUpdate && (fiscalDocumentLine.Tax_Rate__c != trigger.oldMap.get(fiscalDocumentLine.Id).Tax_Rate__c || fiscalDocumentLine.Tax__c != trigger.oldMap.get(fiscalDocumentLine.Id).Tax__c)) || trigger.isInsert) {
            taxIds.put(fiscalDocumentLine.Tax__c, null);
        }
    }
    
    for (Tax__c tax : [SELECT Id, Rate__c FROM Tax__c WHERE Id IN :taxIds.keySet()]) {
        taxIds.put(tax.Id, tax.Rate__c);
    }
	    
    for (Fiscal_Document_Line__c fiscalDocumentLine : trigger.new) {
        if ((trigger.isUpdate && (fiscalDocumentLine.Tax_Rate__c != trigger.oldMap.get(fiscalDocumentLine.Id).Tax_Rate__c || fiscalDocumentLine.Tax__c != trigger.oldMap.get(fiscalDocumentLine.Id).Tax__c)) || trigger.isInsert) {
            Fiscal_Document_Line__c myFiscalDocumentLine = new Fiscal_Document_Line__c(
            	Id = fiscalDocumentLine.Id,
                Tax_Rate__c = taxIds.get(fiscalDocumentLine.Tax__c)
            );
            fiscalDocumentLines.add(myFiscalDocumentLine);
        }
    }
    
    update fiscalDocumentLines;
    
}