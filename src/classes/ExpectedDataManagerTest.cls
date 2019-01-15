@isTest public class ExpectedDataManagerTest extends AbstractThingParkTestCase {

	@isTest static void testGivenTestPriceBook() {
        assertNotNull(new ExpectedDataManager().givenTestPriceBook());
    }

	@isTest static void testGivenTestProduct() {
        assertNotNull(new ExpectedDataManager().givenTestProduct());
    }
    
	@isTest static void testGivenThingParkProduct() {
        assertNotNull(new ExpectedDataManager().givenThingParkProducts());
    }

	@isTest static void testGivenThingParkCustomer() {
        assertNotNull(new ExpectedDataManager().givenThingParkCustomer());
    }

	@isTest static void testGivenThingParkTennancy() {
        assertNotNull(new ExpectedDataManager().givenThingParkTenancy());
    }

	@isTest static void testGivenThingParkPackage() {
        assertNotNull(new ExpectedDataManager().givenThingParkPackage());
    }

	@isTest static void testGivenInvoiceTaxRate() {
        assertNotNull(new ExpectedDataManager().givenInvoiceVatRate());
    }
}