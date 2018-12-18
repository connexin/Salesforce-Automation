trigger RefundDeletionValidation on Refund__c (before delete) {
    
    for (Refund__c refund : trigger.old) {
        if (refund.Draft__c == false) {
            refund.addError('Cannot Delete a Refund that is not in Draft');
        }
    }
    
}