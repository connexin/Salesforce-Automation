trigger PaymentValidation on Payment__c (before insert, before update) {
    for (Payment__c payment : trigger.new) {
        
        if (payment.Reference__c == null && !(trigger.isInsert && payment.Source__c == 'manual')) {
            payment.Reference__c.addError('Reference is a required field');
        }
        
    }
    
}