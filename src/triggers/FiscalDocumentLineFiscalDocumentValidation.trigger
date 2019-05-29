trigger FiscalDocumentLineFiscalDocumentValidation on Fiscal_Document_Line__c (before delete, before insert, before update) {
    
  if (trigger.isInsert || trigger.isUpdate) {
    for (Fiscal_Document_Line__c fiscalDocumentLine : trigger.new) {
      //Check if the Fiscal Document Line is being added to a Fiscal Document that is not in Draft
      if (trigger.isInsert) {
        if (fiscalDocumentLine.Fiscal_Document_Draft__c == false) {
          fiscalDocumentLine.addError('Cannot add a Fiscal Document Line to a Fiscal Document that is not in Draft');
        }
      } else if (trigger.isUpdate) {
        if (trigger.oldMap.get(fiscalDocumentLine.Id).Fiscal_Document__c != fiscalDocumentLine.Fiscal_Document__c && fiscalDocumentLine.Fiscal_Document_Draft__c == false) {
          fiscalDocumentLine.addError('Cannot add a Fiscal Document Line to a Fiscal Document that is not in Draft');
        }
      }
      
      //Check if the Fiscal Document Line is a member of a Fiscal Document that is not in Draft
      if (trigger.isUpdate) {
        if (fiscalDocumentLine.Fiscal_Document__c != trigger.oldMap.get(fiscalDocumentLine.Id).Fiscal_Document__c) {
          if (trigger.oldMap.get(fiscalDocumentLine.Id).Fiscal_Document_Draft__c == false) {
            fiscalDocumentLine.addError('Cannot change the Fiscal Document for a Fiscal Document Line where the current Fiscal Document is not in draft');
          }
        }
      }
    }
  } else if (trigger.isDelete) {
    for (Fiscal_Document_Line__c fiscalDocumentLine : trigger.old) {
      if (fiscalDocumentLine.Fiscal_Document_Draft__c == false) {
        fiscalDocumentLine.addError('Cannot Delete a Fiscal Document Line for a Fiscal Document that is not in Draft');
      }
    }
  }
  
}