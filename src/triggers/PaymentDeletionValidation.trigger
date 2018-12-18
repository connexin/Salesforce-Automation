trigger PaymentDeletionValidation on Payment__c (before delete) {
  
    for (Payment__c payment : trigger.old) {
        if (payment.Draft__c == false) {
            payment.addError('Cannot Delete a Payment that is not in Draft');
        }
    }
        
}