@isTest
private class FiscalDocumentLineControllerTestClass {

    static testMethod void testStandardController() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Test Pricebook'
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
        
        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(fdl);
        FiscalDocumentLineController controller = new FiscalDocumentLineController(stdController);
        
        controller.save();
        
        Product2 product = new Product2(Name = 'Test Product', Nominal_Code__c = testNominalCode.Id	, IsActive = true);
        insert product;
        
        PricebookEntry pricebookEntry = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product.Id, UnitPrice = 20.83, Tax__c = testTax.Id);
        PricebookEntry pricebookEntry2 = new PricebookEntry(Pricebook2Id = testPricebook.Id, Product2Id = product.Id, UnitPrice = 20.83, Tax__c = testTax.Id);
        insert new List<PricebookEntry>{pricebookEntry, pricebookEntry2};
        
        fdl.Product__c = product.Id;
        controller.selectProduct();
        
        fdl.Tax__c = null;
        controller.calculateSubtotals();
        
        controller.save();
        
        controller = new FiscalDocumentLineController(stdController);
    }
    
    static testMethod void testCustomProductLookupController() {
    	
    	Test.setCurrentPageReference(new PageReference('Page.CustomProductLookup'));
    	System.currentPageReference().getParameters().put('lksrch', 'test');
    	System.currentPageReference().getParameters().put('frm', 'frm');
    	System.currentPageReference().getParameters().put('txt', 'txt');
    	System.currentPageReference().getParameters().put('priceBookId', Test.getStandardPricebookId());
    	CustomProductLookupController controller = new CustomProductLookupController();
    	
    	system.assertEquals(controller.getFormTag(), 'frm');
    	system.assertEquals(controller.getTextBox(), 'txt');
    	system.assertEquals(controller.search(), null);
    }
}