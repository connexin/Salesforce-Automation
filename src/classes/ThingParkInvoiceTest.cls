@isTest public class ThingParkInvoiceTest extends AbstractTestCase {

	@isTest static void testThingParkInvoiceCreate() {
        ExpectedDataManager.givenThingParkPackage();
        	// implied ExpectedDataManager.givenThingParkTennancy();
        	// implied ExpectedDataManager.givenThingParkProduct();
        	// implied ExpectedDataManager.givenThingParkCustomer();

		// Manager.givenInvoiceTaxRate();
        // Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        // insert fd;
		
        // Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        // insert fdl;
        
		// ThingParkInvoice invoice ThingParkInvoice.create();
        // assertNotNull(invoice);
        // invoice.addLine();
    }

    
}