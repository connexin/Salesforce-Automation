@isTest
private class PaymentTestClass {
	
    static testMethod void testPaymentReferenceTrigger() {
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
    	
    	Payment__c payment1 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 1, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment1;
		
    	Payment__c payment2 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 2, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment2;
		
    	Payment__c payment3 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 3, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment3;
		
    	Payment__c payment4 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 4, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment4;
		
    	Payment__c payment5 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 5, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment5;
		
    	Payment__c payment6 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 6, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment6;
		
    	Payment__c payment7 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 7, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment7;
		
    	Payment__c payment8 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 8, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment8;
		
    	Payment__c payment9 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 9, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment9;
		
    	Payment__c payment10 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 10, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment10;
		
    	Payment__c payment11 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 11, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment11;
		
    	Payment__c payment12 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Date__c = Date.newInstance(2018, 12, 1),
    		Draft__c = true,
    		Confirmed__c = false,
    		Failed__c = false,
    		Description__c = 'Test'
		);
		insert payment12;
		
		Payment__c payment13 = new Payment__c(
    		Account__c = account.Id,
    		Amount__c = 25,
    		Source__c = 'go_cardless'
		);
		try {
			insert payment13;
			system.assert(false);
        } catch (DMLException e) {
        	
        }
    }
    
    static testMethod void testpaymentLedgerItemUpdateAndPaymentDeletionValidationTrigger() {
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
    	
        try {
        	delete payment;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
    	
    }
}