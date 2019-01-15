@isTest
private class FiscalDocumentTestClass {

    static testMethod void validationTest() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	RecordType creditNoteRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'credit_note'];

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

        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;
		
        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Fiscal_Document__c fd2 = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd2;
        
        fdl.Fiscal_Document__c = fd2.Id;
        try {
        	update fdl;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
        
        Fiscal_Document_Line__c fdl2 = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        try {
          	insert fdl2;
            system.assert(false);
        } catch (DMLException e) {
            
        }
        
        fdl2.Fiscal_Document__c = fd2.Id;
        insert fdl2;
        
        fdl2.Fiscal_Document__c = fd.Id;
        try {
          	update fdl2;
            system.assert(false);
        } catch (DMLException e) {
            
        }
        
        try {
          	delete fdl;
            system.assert(false);
        } catch (DMLException e) {
            
        }
        
        Fiscal_Document__c fd3 = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = creditNoteRecordType.Id);
        insert fd3;
        
        Fiscal_Document_Line__c fdl3 = new Fiscal_Document_Line__c(Fiscal_Document__c = fd3.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl3;
        
        fd3.Draft__c = false;
        update fd3;
        
        try {
        	delete fd;	
        	system.assert(false);
        } catch (DMLException e) {
            
        }
    }
}