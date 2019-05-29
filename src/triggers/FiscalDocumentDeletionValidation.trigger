trigger FiscalDocumentDeletionValidation on Fiscal_Document__c (before delete) {
	
    for (Fiscal_Document__c fd : trigger.old) {
        if (fd.Draft__c == false) {
            fd.addError('Cannot Delete a Fiscal Document that is not in Draft');
        }
    }
	
}