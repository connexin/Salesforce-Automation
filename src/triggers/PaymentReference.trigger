trigger PaymentReference on Payment__c (after insert) {
    String month;
    List<Payment__c> paymentsToUpdate = new List<Payment__c>();
    Payment__c curPayment;
    
    for (Payment__c payment : trigger.new) {
        if (payment.Source__c == 'manual' && payment.Reference__c == null) {
            if (payment.Date__c.month() == 1) {
                month = 'JAN';
            } else if (payment.Date__c.month() == 2) {
                month = 'FEB';
            } else if (payment.Date__c.month() == 3) {
                month = 'MAR';
            } else if (payment.Date__c.month() == 4) {
                month = 'APR';
            } else if (payment.Date__c.month() == 5) {
                month = 'MAY';
            } else if (payment.Date__c.month() == 6) {
                month = 'JUN';
            } else if (payment.Date__c.month() == 7) {
                month = 'JUL';
            } else if (payment.Date__c.month() == 8) {
                month = 'AUG';
            } else if (payment.Date__c.month() == 9) {
                month = 'SEP';
            } else if (payment.Date__c.month() == 10) {
                month = 'OCT';
            } else if (payment.Date__c.month() == 11) {
                month = 'NOC';
            } else if (payment.Date__c.month() == 12) {
                month = 'DEC';
            }
            curPayment = new Payment__c(Id = payment.Id, Reference__c = 'P/' + String.valueOf(payment.Date__c.year()) + '/' + month + '/' + String.valueOf(payment.Name));
            paymentsToUpdate.add(curPayment);
        }
    }
    
    if (!paymentsToUpdate.isEmpty()) {
        update paymentsToUpdate;
    }
    
}