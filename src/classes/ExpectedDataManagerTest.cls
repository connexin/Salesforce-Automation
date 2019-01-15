@isTest public class ExpectedDataManagerTest extends AbstractThingParkTestCase {

	@isTest static void testGivenTestPriceBook() {
        assertNotNull(ExpectedDataManager.givenTestPriceBook());
    }

	@isTest static void testGivenTestProduct() {
        assertNotNull(ExpectedDataManager.givenTestProduct());
    }
    
	@isTest static void testGivenThingParkProduct() {
        assertNotNull(ExpectedDataManager.givenThingParkProducts());
    }

	@isTest static void testGivenThingParkCustomer() {
        assertNotNull(ExpectedDataManager.givenThingParkCustomer());
    }

	@isTest static void testGivenThingParkTennancy() {
        assertNotNull(ExpectedDataManager.givenThingParkTennancy());
    }

	@isTest static void testGivenThingParkPackage() {
        assertNotNull(ExpectedDataManager.givenThingParkPackage());
    }

	@isTest static void testGivenInvoiceTaxRate() {
        assertNotNull(ExpectedDataManager.givenInvoiceVatRate());
    }
}