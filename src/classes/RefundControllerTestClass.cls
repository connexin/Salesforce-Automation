@isTest
private class RefundControllerTestClass {

    static testMethod void testRefundsControllerValidateDraft() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false);
        insert refund;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(refund));
        
    	controller.validateDraft();
        system.assertEquals(ApexPages.getMessages().size(), 0); 
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerCreateManualRefund() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 0);
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerCreateTooLargeManualRefund() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 200, Draft__c = false)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 1);
        system.assertEquals(ApexPages.getMessages()[0].getDetail(), 'Refund amount cannot be greater than Payment amount');
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerCreateUncomfirmedPaymentManualRefund() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 1);
        system.assertEquals(ApexPages.getMessages()[0].getDetail(), 'Refund cannot be created until Payment is confirmed');
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerStripeRefund() {
    	Test.setMock(HttpCalloutMock.class, new StripeMockHttpResponseGenerator());
    	
    	Stripe__c setting = new Stripe__c(Name='default', Api_Url__c = 'url', Api_Key__c = 'key', Api_Version__c = 'version', Currency__c = 'gbp', Public_Api_Key__c = 'key');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = false, Description__c = 'Test', Reference__c = 'Test', Source__c = 'stripe');
        insert payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 0);
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerStripeRefundFail() {
    	Test.setMock(HttpCalloutMock.class, new StripeMockHttpResponseGenerator());
    	
    	Stripe__c setting = new Stripe__c(Name='default', Api_Url__c = 'url', Api_Key__c = 'key', Api_Version__c = 'version', Currency__c = 'gbp', Public_Api_Key__c = 'key');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = false, Description__c = 'Test', Reference__c = 'test2', Source__c = 'stripe');
        insert payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 1);
        system.assertEquals(ApexPages.getMessages()[0].getDetail(), 'Stripe Error: 400 - Refund Request Failed');
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerGoCardlessRefund() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = false, Description__c = 'Test', Reference__c = 'PM0001', Source__c = 'go_cardless');
        insert payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 0);
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerGoCardlessRefundFail() {
    	Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
    	
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = false, Description__c = 'Test', Reference__c = 'PM0002', Source__c = 'go_cardless');
        insert payment;
        
        Test.startTest();
        
        RefundController controller = new RefundController(new ApexPages.StandardController(new Refund__c(Payment__c = payment.Id, Amount__c = 20)));
        
    	controller.createRefund();
        system.assertEquals(ApexPages.getMessages().size(), 1);
        system.assertEquals(ApexPages.getMessages()[0].getDetail(), 'GoCardless Error: 400 - Refund Failed');
        
        Test.stopTest();
    }
    
    static testMethod void testRefundsControllerRelatedItems() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType creditNoteRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'credit_note'];
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Account account = new Account(Name = 'test');
    	insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = creditNoteRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 5);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 30, Draft__c = false);
        insert refund;
        
        RefundController controller = new RefundController(new ApexPages.StandardController(refund));
        
        system.assertEquals(controller.salesInvoiceRelations, null);
        system.assertEquals(controller.creditNoteRelations.size(), 1);
        system.assertEquals(controller.paymentRelations.size(), 1);
        system.assertEquals(controller.refundRelations.size(), 1);
    }
}