@isTest
private class DirectDebitTestClass {

    static testMethod void testDirectDebitValidation() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0001'
    	);
    	
    	insert directDebit;
    	
    	Direct_Debit__c directDebit2 = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0002'
    	);
    	Direct_Debit__c directDebit3 = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0003'
    	);
    	try {
    		insert new List<Direct_Debit__c>{directDebit2, directDebit3};
    		system.assert(false);
        } catch (DMLException e) {
        	
        }
    	
    	directDebit.Name = 'CU004';
    	update directDebit;
    }
    
    static testMethod void testDirectDebitControllerInsert() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Test.startTest();
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0002'
    	);
    	
    	ApexPages.StandardController stdController = new ApexPages.StandardController(directDebit);
    	DirectDebitController controller = new DirectDebitController(stdController);
    	
		controller.save();
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (!msg.getDetail().contains('Go Cardless ID is not Valid')) {
        		system.assert(false);
        	}
        }
        
        directDebit.Name = 'CU0001';
        controller.save();
        
        Test.stopTest();
    }
    
    static testMethod void testDirectDebitControllerCreate() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Test.startTest();
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(
    		Account__c = account.Id
    	);
    	
    	ApexPages.StandardController stdController = new ApexPages.StandardController(directDebit);
    	DirectDebitController controller = new DirectDebitController(stdController);
    	
		controller.save();
        
        system.assertEquals(directDebit.Name, 'CU0001');
        
        Test.stopTest();
    }
    
    static testMethod void testDirectDebitControllerUpdate() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Account account2 = new Account(Name = 'Test Account 2');
    	insert account2;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0001'
    	);
    	
    	insert directDebit;
    	
    	Test.startTest();
    	
    	ApexPages.StandardController stdController = new ApexPages.StandardController(directDebit);
    	DirectDebitController controller = new DirectDebitController(stdController);
    	
    	directDebit.Account__c = account2.Id;
		controller.save();
        
        Test.stopTest();
    }
    
    static testMethod void testDirectDebitControllerView() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(
    		Account__c = account.Id,
    		Name = 'CU0001'
    	);
    	
    	insert directDebit;
    	
    	Test.startTest();
    	
    	ApexPages.StandardController stdController = new ApexPages.StandardController(directDebit);
    	DirectDebitController controller = new DirectDebitController(stdController);
    	
    	ApexPages.currentPage().getParameters().put('id', 'BA0001');
    	GoCardlessCustomerBankAccount bankAccount = controller.getBankAccount();
    	system.assertEquals(bankAccount.account_holder_name, 'BOB TEST');
    	system.assertEquals(bankAccount.account_number_ending, '11');
    	system.assertEquals(bankAccount.bank_name, 'BARCLAYS BANK PLC');
    	system.assertEquals(bankAccount.country_code, 'GB');
    	system.assertEquals(bankAccount.created_at, DateTime.ValueofGmt('2018-01-28 11:59:27.000Z'));
    	system.assertEquals(bankAccount.currency_code, 'GBP');
    	system.assertEquals(bankAccount.enabled, true);
    	system.assertEquals(bankAccount.id, 'BA0001');
    	
    	GoCardlessCustomerBankAccount[] bankAccounts = controller.getBankAccounts();
    	system.assertEquals(bankAccounts.size(), 1);
    	system.assertEquals(bankAccounts[0].account_holder_name, 'BOB TEST');
    	system.assertEquals(bankAccounts[0].account_number_ending, '11');
    	system.assertEquals(bankAccounts[0].bank_name, 'BARCLAYS BANK PLC');
    	system.assertEquals(bankAccounts[0].country_code, 'GB');
    	system.assertEquals(bankAccounts[0].created_at, DateTime.ValueofGmt('2018-01-28 11:59:27.000Z'));
    	system.assertEquals(bankAccounts[0].currency_code, 'GBP');
    	system.assertEquals(bankAccounts[0].enabled, true);
    	system.assertEquals(bankAccounts[0].id, 'BA0001');
        
        GoCardlessPayment[] payments = controller.getPayments();
    	system.assertEquals(payments.size(), 1);
    	system.assertEquals(payments[0].id, 'PM0001');
    	system.assertEquals(payments[0].created_at, DateTime.ValueofGmt('2018-04-22 19:40:46.376Z'));
    	system.assertEquals(payments[0].charge_date, DateTime.ValueofGmt('2018-04-26 00:00:00.000Z').date());
    	system.assertEquals(payments[0].amount, 2500);
    	system.assertEquals(payments[0].description, 'S/2018/APR/455');
    	system.assertEquals(payments[0].currency_code, 'GBP');
    	system.assertEquals(payments[0].status, 'confirmed');
    	system.assertEquals(payments[0].reference, null);
    	system.assertEquals(payments[0].amount_refunded, 0);
    	system.assertEquals(payments[0].links.mandate, 'MD0001');
        
        ApexPages.currentPage().getParameters().put('id', 'BA0001');
        GoCardlessMandate[] mandates = controller.getMandates();
        system.assertEquals(mandates.size(), 1);
        system.assertEquals(mandates[0].id, 'MD0001');
        system.assertEquals(mandates[0].created_at, DateTime.ValueofGmt('2018-04-22 19:40:46.376Z'));
        system.assertEquals(mandates[0].next_possible_charge_date, DateTime.ValueofGmt('2018-04-26 00:00:00.000Z').date());
        system.assertEquals(mandates[0].payments_require_approval, 'false');
        system.assertEquals(mandates[0].reference, '877A97Q');
        system.assertEquals(mandates[0].scheme, 'bacs');
        system.assertEquals(mandates[0].status, 'active');
        
        PageReference pg;
        controller.curBankAccountId = 'test';
        
        pg = controller.viewBankAccount();
        system.assertEquals(pg.getUrl(), '/apex/DirectDebitBankAccountView?id=test');
        
        pg = controller.createBankAccount();
        system.assertEquals(pg.getUrl(), '/apex/DirectDebitBankAccountCreate?id=test');
        
        Test.stopTest();
    }
    
}