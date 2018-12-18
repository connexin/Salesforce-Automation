@isTest
private class PaymentsControllerTestClass {

    static testMethod void testPaymentsControllerValidateDraftFail() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 0);
        insert payment;
        
        Test.startTest();
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(payment);
        PaymentController controller = new PaymentController(stdController);
        
    	controller.validateDraft();
    	system.assertEquals(ApexPages.getMessages().size(), 1);
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (!msg.getDetail().contains('Payment must be Draft if amount is 0')) {
        		system.assert(false);
        	}
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPaymentsControllerValidateDraft() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25);
        insert payment;
        
        Test.startTest();
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(payment);
        PaymentController controller = new PaymentController(stdController);
        
    	controller.validateDraft();
        system.assertEquals(ApexPages.getMessages().size(), 0); 
        
        Test.stopTest();
    }
    
    static testMethod void testPaymentsController() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25);
        insert payment;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'test');
        insert fd;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(payment);
        PaymentController controller = new PaymentController(stdController);
        
        PageReference pg;
        controller.documentId = null;
        pg = controller.cancelPayment();
        system.assertEquals(pg.getUrl(), '/apex/AccountStatement?accountId=' + account.Id);
        
        controller.documentId = fd.Id;
        pg = controller.cancelPayment();
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentView?id=' + fd.id);
    }
    
    static testMethod void testPaymentsControllerTakePaymentStripe() {
        Test.setMock(HttpCalloutMock.class, new StripeMockHttpResponseGenerator());
        
    	Stripe__c setting = new Stripe__c(Name='default', Api_Url__c = 'url', Api_Key__c = 'key', Api_Version__c = 'version', Currency__c = 'gbp', Public_Api_key__c = 'key');
    	insert setting;
    	
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'test', Auto_Proc__c = true, Dispute__c = true, RecordTypeId = salesInvoiceRecordType.Id, Price_book__c = testPricebook.Id);
        insert fd;
    	
    	Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'test', Amount__c = 25, Nominal_Code__c = testNominalCode.Id); 
    	insert fdl;
    	
    	fd.Draft__c = false;
    	update fd;
    	
    	Payment__c payment = new Payment__c(Account__c = account.Id, Reference__c = 'Test Reference', Description__c = 'Test', Amount__c = 25, Draft__c = false, Confirmed__C = false, Failed__c = false, Source__c = 'go_cardless');
    	insert payment;
    	
    	Payment__c payment2 = new Payment__c();
    	
    	List<Payment__c> payments = new List<Payment__c>{payment2};
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(payments);
    	
    	ApexPages.currentPage().getParameters().put('amount', '25');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	ApexPages.currentPage().getParameters().put('documentid', fd.Id);
    	
    	PaymentController controller = new PaymentController(stdSetController);
    	
    	system.assertEquals('key', controller.getStripePublicAPIKey());
    	
    	controller.payment.Account__c = null;
    	for (SelectOption option : controller.getPaymentGatewayList()) {
    		if (option.getValue() != '') {
    			system.assert(false);
    		}
    	}
    	controller.payment.Account__c = account.Id;
    	
        for (SelectOption option : controller.getPaymentGatewayList()) {
        	if (option.getValue() != 'stripe') {
        		system.assert(false);
        	}
        }
        
    	controller.payment.Source__c = 'stripe';
    	controller.stripeToken = 'test';
    	controller.takePayment();
    	
    	Test.stopTest();
    }
    
    static testMethod void testPaymentsControllerTakePaymentStripeFailure() {
        Test.setMock(HttpCalloutMock.class, new StripeMockHttpResponseGenerator());
        
    	Stripe__c setting = new Stripe__c(Name='default', Api_Url__c = 'url', Api_Key__c = 'key', Api_Version__c = 'version', Currency__c = 'gbp', Public_Api_Key__c = 'key');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Payment__c>{new Payment__c()});
    	
    	ApexPages.currentPage().getParameters().put('amount', '25');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	
    	PaymentController controller = new PaymentController(stdSetController);
        
    	controller.payment.Source__c = 'stripe';
    	controller.stripeToken = 'test2';
    	controller.takePayment();
    	
    	system.assertEquals(ApexPages.getMessages().size(), 1);
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (msg.getDetail() != 'Stripe Error: 400 - Payment Request Failed') {
        		system.assert(false);
        	}
        }
    	
    	Test.stopTest();
    }
    
    static testMethod void testPaymentsControllerTakePaymentGoCardlessNoMandate() {
        Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
        
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(Name = 'CU0002', Account__c = account.Id);
    	insert directDebit;
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Payment__c>{new Payment__c()});
    	
    	ApexPages.currentPage().getParameters().put('amount', '25');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	
    	PaymentController controller = new PaymentController(stdSetController);
        
    	controller.payment.Source__c = 'go_cardless';
    	
    	controller.takePayment();
    	system.assertEquals(ApexPages.getMessages().size(), 1);
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (msg.getDetail() != 'Go Cardless Request Failed') {
        		system.assert(false);
        	}
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPaymentsControllerTakePaymentGoCardless() {
        Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
        
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(Name = 'CU0001', Account__c = account.Id);
    	insert directDebit;
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Payment__c>{new Payment__c()});
    	
    	ApexPages.currentPage().getParameters().put('amount', '25');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	
    	PaymentController controller = new PaymentController(stdSetController);
        
        Set<String> options = new Set<String>{'go_cardless', 'stripe'};
        for (SelectOption option : controller.getPaymentGatewayList()) {
        	if (!options.contains(option.getValue())) {
        		system.assert(false);
        	}
        }
        
    	controller.payment.Source__c = 'go_cardless';
    	controller.takePayment();
    	system.assertEquals(ApexPages.getMessages().size(), 0);
    	
    	Test.stopTest();
    }
    
    static testMethod void testPaymentsControllerTakePaymentGoCardlessTooSmall() {
        Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
        
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Direct_Debit__c directDebit = new Direct_Debit__c(Name = 'CU0001', Account__c = account.Id);
    	insert directDebit;
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Payment__c>{new Payment__c()});
    	
    	ApexPages.currentPage().getParameters().put('amount', '0.5');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	
    	PaymentController controller = new PaymentController(stdSetController);
    	
    	controller.takePayment();
    	system.assertEquals(ApexPages.getMessages().size(), 1);
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (msg.getDetail() != 'Cannot take a Direct Debit for less than £1') {
        		system.assert(false);
        	}
        }
        
    }
    
    static testMethod void testPaymentsControllerTakePaymentGoCardlessInvalidApi() {
    	Account account = new Account(Name = 'Test Account');
    	insert account;
    	
    	Test.startTest();
    	
    	ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(new List<Payment__c>{new Payment__c()});
    	
    	ApexPages.currentPage().getParameters().put('amount', '0.5');
    	ApexPages.currentPage().getParameters().put('account', account.Id);
    	ApexPages.currentPage().getParameters().put('description', 'Test Description');
    	
    	PaymentController controller = new PaymentController(stdSetController);
    	
    	controller.payment.Source__c = 'manual';
    	system.assertEquals(controller.takePayment(), null);
    	system.assertEquals(ApexPages.getMessages().size(), 1);
        for (Apexpages.Message msg : ApexPages.getMessages()) {
        	if (msg.getDetail() != 'Invalid API') {
        		system.assert(false);
        	}
        }
    }
    
    static testMethod void testPaymentsControllerRelatedItems() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Account account = new Account(Name = 'test');
    	insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
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
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false);
        insert refund;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(payment);
        PaymentController controller = new PaymentController(stdController);
        
        system.assertEquals(controller.salesInvoiceRelations.size(), 1);
        system.assertEquals(controller.creditNoteRelations, null);
        system.assertEquals(controller.paymentRelations.size(), 1);
        system.assertEquals(controller.refundRelations.size(), 1);
    }
    
}