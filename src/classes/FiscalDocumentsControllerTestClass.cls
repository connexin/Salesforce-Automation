@isTest
private class FiscalDocumentsControllerTestClass {

    static testMethod void testStandardController() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;
        
        fd = [SELECT Id, Name, Account__c, Description__c, Draft__c, Dispute__c, Price_Book__c, Subtotal__c, Amount_Allocated__c, Reference__c, Sent__c FROM Fiscal_Document__c WHERE Id = :fd.Id];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(fd);
        FiscalDocumentsController controller = new FiscalDocumentsController(stdController);
        
        PageReference pg;
		pg = controller.validateDraft();
		system.assertEquals(pg, null);
		
        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
		
		pg = controller.validateDraft();
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentActionsConfirmation?id=' + String.valueOf(fd.Id));
        
        pg = controller.takePayment();
        system.assertEquals(pg.getUrl(), '/apex/PaymentTake?account=' + fd.Account__c + '&amount=' + String.valueOf(fd.Subtotal__c - fd.Amount_Allocated__c) + '&description=' + EncodingUtil.urlEncode(fd.Reference__c, 'UTF-8') + '&documentid=' + fd.Id);
        
        pg = controller.viewPdf();
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentPDF?id=' + String.valueOf(fd.Id));
        
        controller.sendEmail();
        
        Contact contact = new Contact(FirstName = 'test', LastName = 'email', Email = 'test@test.com', AccountId = account.Id);
        insert contact;
        controller.sendEmail();
        fd = [SELECT Id, Name, Account__c, Description__c, Draft__c, Dispute__c, Price_Book__c, Subtotal__c, Amount_Allocated__c, Reference__c, Sent__c FROM Fiscal_Document__c WHERE Id = :fd.Id];
        system.assertEquals(fd.Sent__c, true);
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = false, Description__c = 'Test', Source__c = 'go_cardless', Reference__c = 'test');
        insert payment;
        
        controller.getLinkedLedgerItems();
        
        system.assertEquals(controller.getOddRowColour(), 'white');
        system.assertEquals(controller.getEvenRowColour(), '#f7f7f9');
        
        system.assertEquals(controller.getTextColour(), '#00bb00');
        system.assertEquals(controller.getLogo(), PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl());
        system.assertEquals(controller.getFooterImage(), PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl());
        system.assertEquals(controller.getWebsite(), 'smartcities.connexin.co.uk');
        
        account.Type = 'Residential';
        controller.account = account;
        system.assertEquals(controller.getTextColour(), '#ec1c24');
        system.assertEquals(controller.getLogo(), PageReference.forResource('Connexin_Home_Logo').getUrl());
        system.assertEquals(controller.getFooterImage(), PageReference.forResource('Connexin_Home_Footer').getUrl());
        system.assertEquals(controller.getWebsite(), 'home.connexin.co.uk');
        
        account.Type = 'Business';
        controller.account = account;
        system.assertEquals(controller.getTextColour(), '#00aff0');
        system.assertEquals(controller.getLogo(), PageReference.forResource('Connexin_Business_Logo').getUrl());
        system.assertEquals(controller.getFooterImage(), PageReference.forResource('Connexin_Business_Footer').getUrl());
        system.assertEquals(controller.getWebsite(), 'business.connexin.co.uk');
        
        account.Type = 'Public Sector';
        controller.account = account;
        system.assertEquals(controller.getTextColour(), '#00bb00');
        system.assertEquals(controller.getLogo(), PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl());
        system.assertEquals(controller.getFooterImage(), PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl());
        system.assertEquals(controller.getWebsite(), 'smartcities.connexin.co.uk');
        
        pg = controller.cloneFiscalDocumentToCreditNote();
    }
}