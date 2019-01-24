@isTest public class ThingParkInvoiceTest extends AbstractTestCase {
    
    @isTest static void testThingParkInvoiceCreate() {
        System.debug('testThingParkInvoiceCreate');

        // Given pre-requisite data for a provisioned service
        ExpectedDataManager expectedData = new ExpectedDataManager();
        expectedData.givenThingParkProducts();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTenancy();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        expectedData.givenInvoiceRecordType();
        System.debug('***** expectedData : ' + expectedData);
        
        // create one line for each LoRaWAN product
        for(Product2 product : expectedData.lorawanProducts) {
            assertNotNull(product);
            System.debug(product);
            
            // Then test ThingPark Invoice Creation
            // public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
            ThingParkInvoice invoice = ThingParkInvoice.create(
                expectedData.account.id,
                'Test-Invoice ' + TimeStamp.timeStamp(),
                product.id);
            assertNotNull(invoice);
            
            // public ThingParkInvoice addDeviceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addDeviceCharges(expectedData.account.id,
                                     product.Id,
                                     expectedData.lorawanTenancy.Total_Devices__c,
                                     expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addServiceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addServiceCharges(expectedData.account.id,
                                      product.id,
                                      expectedData.lorawanTenancy.Daily_Max_Average__c,
                                      expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addOverageCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            Decimal totalMessage = 100;
            invoice.addOverageCharges(expectedData.account.id,
                                      product.id,
                                      totalMessage - expectedData.lorawanTenancy.Daily_Max_Average__c,
                                      expectedData.lorawanTenancy.Overage_Rate__c);
            
            invoice.addEndOfLineCharges(expectedData.account.id,
                                        product.id,
                                        expectedData.lorawanTenancy.Total_Devices__c,
                                        expectedData.lorawanPackage.Device_Rate_after_commitment_end__c);
            
            System.debug('invoice : ' + invoice);
        }
    }
    
    // @isTest 
    static void testInvoiceCreate() {
        System.debug('testInvoiceCreate');

        // Given pre-requisite data for a provisioned service
        ExpectedDataManager expectedData = new ExpectedDataManager();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTennancy();
        // implies expectedData.givenThingParkProduct();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        System.debug('expectedData : ' + expectedData);

        // When we create an invoice for the service usage
        Fiscal_Document__c invoice = new Fiscal_Document__c(
            Account__c = expectedData.account.Id,
            Description__c = 'Test Invoice',
            // Price_Book__c = expectedData.pricebook.Id, 
            // RecordTypeId = expectedData.invoiceRecordType.Id
            Draft__c = true,
            Dispute__c = false);
        insert invoice;
        System.debug('1) invoice : ' + invoice);
        
        // Service charge line
        Fiscal_Document_Line__c serviceInvoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.Id,
            Description__c = 'Test-Service-Line',
            Tax__c = expectedData.vatRate.Id,
            // Nominal_Code__c = testNominalCode.Id, 
            // Product__c = expectedData.testProduct.Id,
            Quantity__c = expectedData.lorawanPackage.Quantity_Of_Devices__c,
            Amount__c = expectedData.lorawanPackage.Device_Rate__c);
        insert serviceInvoiceLine;
        System.debug('serviceInvoiceLine : ' + serviceInvoiceLine);
        
        // Overage charge line
        Fiscal_Document_Line__c overageInvoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.Id,
            Description__c = 'Test-Overage-Line',
            Tax__c = expectedData.vatRate.Id,
            // Nominal_Code__c = testNominalCode.Id,
            // Product__c = expectedData.testProduct.Id,
            Quantity__c = 99,
            Amount__c = expectedData.lorawanTenancy.Overage_Rate__c);
        insert overageInvoiceLine;
        System.debug('overageInvoiceLine : ' + overageInvoiceLine);

        System.debug('2) invoice : ' + invoice);
    }
}