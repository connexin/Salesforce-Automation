trigger FiscalDocumentLineUpdate on Fiscal_Document_Line__c (before insert, before update) {
    
    for (Fiscal_Document_Line__c fiscalDocumentLine : trigger.new) {
        fiscalDocumentLine.Subtotal_Value__c = fiscalDocumentLine.Subtotal__c;
        fiscalDocumentLine.Net_Subtotal_Value__c = fiscalDocumentLine.Net_Subtotal__c;
        fiscalDocumentLine.Tax_Subtotal_Value__c = fiscalDocumentLine.Tax_Subtotal__c;
    }
    
}