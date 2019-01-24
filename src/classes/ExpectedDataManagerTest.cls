@isTest public class ExpectedDataManagerTest extends AbstractThingParkTestCase {
    
    @isTest static void testGivenTestPriceBook() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);

        PriceBook2 priceBook = expectedDataManager.givenTestPriceBook();
        assertNotNull(priceBook);
        System.debug('priceBook : ' + priceBook);

		List<PriceBook2> actual = [SELECT Id, Name, Description, IsActive FROM Pricebook2 WHERE IsActive = true];
		assertTrue(actual.size() == 1);

        System.debug('expectedDataManager : ' + expectedDataManager.priceBook);

        assertNotNull(expectedDataManager.pricebook);
        System.debug('expectedDataManager.pricebook : ' + expectedDataManager.pricebook);
    }
    
    @isTest static void testGivenTestProduct() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        Product2 product = expectedDataManager.givenTestProduct();
        assertNotNull(product);
        System.debug('product : ' + product);
        System.debug('expectedDataManager : ' + expectedDataManager);

        assertNotNull(expectedDataManager.testProduct);
        System.debug('expectedDataManager.testProduct : ' + expectedDataManager.testProduct);
    }
    
    @isTest static void testGivenThingParkProduct() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        Product2[] thingParkProducts = expectedDataManager.givenThingParkProducts();
        assertNotNull(thingParkProducts);
        System.debug('thingParkProducts : ' + thingParkProducts);
        System.debug('expectedDataManager : ' + expectedDataManager);

        assertNotNull(expectedDataManager.lorawanProducts);
        System.debug('expectedDataManager.lorawanProducts : ' + expectedDataManager.lorawanProducts);
    }
    
    @isTest static void testGivenThingParkCustomer() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        Account thingParkCustomer = expectedDataManager.givenThingParkCustomer();
        assertNotNull(thingParkCustomer);
        System.debug('thingParkCustomer : ' + thingParkCustomer);        
        System.debug('expectedDataManager : ' + expectedDataManager);

        assertNotNull(expectedDataManager.account);
        System.debug('expectedDataManager.account : ' + expectedDataManager.account);
    }
    
    @isTest static void testGivenCustomerContacts() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        Contact primaryContact = expectedDataManager.givenCustomerContacts();
        assertNotNull(primaryContact);
        System.debug('primaryContact : ' + primaryContact);

        assertNotNull(expectedDataManager.primaryContact);
        System.debug('expectedDataManager.primaryContact : ' + expectedDataManager.primaryContact);
        assertNotNull(expectedDataManager.altContact);
        System.debug('expectedDataManager.altContact : ' + expectedDataManager.altContact);
    }
    
    @isTest static void testGivenThingParkTenancy() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        LoRaWAN_Tenancy__c tenancy = expectedDataManager.givenThingParkTenancy();
        assertNotNull(tenancy);
        System.debug('tenancy : ' + tenancy);

        assertNotNull(expectedDataManager.lorawanTenancy);
        System.debug('expectedDataManager.lorawanTenancy : ' + expectedDataManager.lorawanTenancy);
    }
    
    @isTest static void testGivenThingParkPackage() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        LoRaWAN_Package__c pckge = expectedDataManager.givenThingParkPackage();
        assertNotNull(pckge);
        System.debug('package : ' + pckge);

        assertNotNull(expectedDataManager.lorawanPackage);
        System.debug('expectedDataManager.lorawanPackage : ' + expectedDataManager.lorawanPackage);
    }

    @isTest static void testGivenInvoiceTaxRate() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        Tax__c vatRate = expectedDataManager.givenInvoiceVatRate();
        assertNotNull(vatRate);
        System.debug('vatRate : ' + vatRate);
        
        assertNotNull(expectedDataManager.vatRate);        
        System.debug('expectedDataManager.vatRate : ' + expectedDataManager.vatRate);
    }
    
    @isTest static void testGivenInvoiceRecordType() {
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assertNotNull(expectedDataManager);
        
        RecordType recordType = expectedDataManager.givenInvoiceRecordType();
        assertNotNull(recordType);
        System.debug('recordType : ' + recordType);

        assertNotNull(expectedDataManager.invoiceRecordType);
        System.debug('expectedDataManager.invoiceRecordType : ' + expectedDataManager.invoiceRecordType);
    }

}