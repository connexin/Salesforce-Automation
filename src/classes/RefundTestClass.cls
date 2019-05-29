@isTest
private class RefundTestClass {

    static testMethod void testRefundLedgerItemUpdateTrigger() {
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
    	Payment__c payment = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 10,
    		Draft__c = false,
    		Confirmed__c = true,
    		Failed__c = false,
    		Reference__c = 'Test',
    		Source__c = 'go_cardless',
    		Description__c = 'Test'
    	);
    	insert payment;
    	
    	Refund__c refund = new Refund__c(
    		Payment__c = payment.Id,
    		Amount__c = 5,
    		Draft__c = true
    	);
    	insert refund;
    	
    	refund.Draft__c = false;
    	update refund;
		
		try {
        	delete refund;	
        	system.assert(false);
        } catch (DMLException e) {
            
        }
    }
}