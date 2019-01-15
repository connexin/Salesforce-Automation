@isTest public class ThingParkInvoiceTest extends AbstractTestCase {
    
    @isTest static void testThingParkInvoiceCreate() {
        // Given pre-requisite data for a provisioned service
        ExpectedDataManager expectedData = new ExpectedDataManager();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTennancy();
        // implies expectedData.givenThingParkProduct();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        
        // public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
        ThingParkInvoice invoice = ThingParkInvoice.create(
            expectedData.account.id,
            'Test-Invoice ' + TimeStamp.timeStamp(),
            expectedData.testProduct.id);
        assertNotNull(invoice);
        
        // public ThingParkInvoice addDeviceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        invoice.addDeviceCharges(expectedData.account.id,
                                 expectedData.testProduct.id,
                                 expectedData.lorawanTenancy.Total_Devices__c,
                                 expectedData.lorawanPackage.Device_Rate__c);
        
        // public ThingParkInvoice addServiceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        invoice.addServiceCharges(expectedData.account.id,
                                  expectedData.testProduct.id,
                                  expectedData.lorawanTenancy.Daily_Max_Average__c,
                                  expectedData.lorawanPackage.Device_Rate__c);
        
        // public ThingParkInvoice addOverageCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        Decimal totalMessage = 100;
        invoice.addOverageCharges(expectedData.account.id,
                                  expectedData.testProduct.id,
                                  totalMessage - expectedData.lorawanTenancy.Daily_Max_Average__c,
                                  expectedData.lorawanTenancy.Overage_Rate__c);
        
        invoice.addEndOfLineCharges(expectedData.account.id,
                                    expectedData.testProduct.id,
                                    expectedData.lorawanTenancy.Total_Devices__c,
                                    expectedData.lorawanPackage.Device_Rate_after_commitment_end__c);
        
        System.debug('invoice : ' + invoice);
    }   
    
    
    @isTest static void testInvoiceCreate() {
        // Given pre-requisite data for a provisioned service
        ExpectedDataManager expectedData = new ExpectedDataManager();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTennancy();
        // implies expectedData.givenThingParkProduct();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        
        // public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
        // ThingParkInvoice invoice = ThingParkInvoice.create();
        
        // When we create an invoice for the service usage
        Fiscal_Document__c invoice = new Fiscal_Document__c(
            Account__c = expectedData.account.Id, 
            Description__c = 'Test', 
            Draft__c = true, 
            Dispute__c = false, 
            Price_Book__c = expectedData.pricebook.Id, 
            RecordTypeId = expectedData.invoiceRecordType.Id);
        insert invoice;
        
        // Service charge line
        Fiscal_Document_Line__c serviceInvoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.Id,
            Description__c = 'Test-Service-Line',
            Tax__c = expectedData.vatRate.Id,
            // Nominal_Code__c = testNominalCode.Id, 
            Product__c = expectedData.testProduct.Id, 
            Quantity__c = expectedData.lorawanPackage.Quantity_Of_Devices__c,
            Amount__c = expectedData.lorawanPackage.Device_Rate__c);
        insert serviceInvoiceLine;
        
        // Overage charge line
        Fiscal_Document_Line__c overageInvoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.Id,
            Description__c = 'Test-Overage-Line',
            Tax__c = expectedData.vatRate.Id,
            // Nominal_Code__c = testNominalCode.Id, 
            Product__c = expectedData.testProduct.Id, 
            Quantity__c = 99,
            Amount__c = expectedData.lorawanTenancy.Overage_Rate__c);
        insert overageInvoiceLine;
        
        // ThingParkInvoice invoice ThingParkInvoice.create();
        // assertNotNull(invoice);
        // invoice.addLine();
        System.debug('invoice : ' + invoice);
    }
}