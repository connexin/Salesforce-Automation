@isTest public class ThingParkInvoiceTest extends AbstractTestCase {
    
    @isTest static void testThingParkInvoiceCreate() {
        System.debug('testThingParkInvoiceCreate');
		System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c ]);

        // Given pre-requisite data for a provisioned service
        ExpectedDataManager expectedData = new ExpectedDataManager();
        expectedData.givenThingParkProducts();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTenancy();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        expectedData.givenInvoiceRecordType();
        System.debug('***** expectedData : ' + expectedData);

			// System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c WHERE Account__c =: expectedData.account.id]);

        // create one line for each LoRaWAN product
        for(Product2 product : expectedData.lorawanProducts) {
            assertNotNull(product);
            System.debug(product);
            
            // Then test ThingPark Invoice Creation
            // public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
            ThingParkInvoice invoice = ThingParkInvoice.create(expectedData.account.id,
                                                               'Test-Invoice ' + TimeStamp.timeStamp(),
                                                               product.id);
            assertNotNull(invoice);
            
            // public ThingParkInvoice addDeviceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addDeviceCharges(product.id,
                                     expectedData.lorawanTenancy.Total_Devices__c,
                                     expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addServiceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addServiceCharges(product.id,
                                      expectedData.lorawanTenancy.Daily_Max_Average__c,
                                      expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addOverageCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            Decimal totalMessage = 100;
            invoice.addOverageCharges(product.id,
                                      totalMessage - expectedData.lorawanTenancy.Daily_Max_Average__c,
                                      expectedData.lorawanTenancy.Overage_Rate__c);
            
            invoice.addEndOfLifeCharges(product.id,
                                        expectedData.lorawanTenancy.Total_Devices__c,
                                        expectedData.lorawanPackage.Device_Rate_after_commitment_end__c);

            System.debug('invoice : ' + invoice);
        }
        
        verifyFiscalDocument(expectedData.account.id);
    }

    @isTest static void testInvoiceCreate() {
        System.debug('testInvoiceCreate');
        System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c]);

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

		// System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c WHERE Account__c =: expectedData.account.id]);
        
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
        
        verifyFiscalDocument(expectedData.account.id);        
    }
    
    private static void verifyFiscalDocument(final String accountId) {
		System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c WHERE Account__c =: accountId]);
        List<Fiscal_Document__c> invoices = [
            SELECT id, Name, Account__c, Description__c, Date__c, Actual_Due_Date__c, 
            Net_Subtotal__c, Subtotal_Value__c, Subtotal__c, Tax_Subtotal__c, Tax_Value__c, Total_Value__c 
            FROM Fiscal_Document__c
            WHERE Account__c =: accountId];
        assertTrue((invoices.size() > 0), 'Expected invoices to exist');
        for(Fiscal_Document__c invoice : invoices) {
        	System.debug('invoice : ' + invoice);
			// System.debug('count invoices lines : ' + [SELECT count() FROM Fiscal_Document_Line__c WHERE Fiscal_Document__c =: invoice.id].count);
            List<Fiscal_Document_Line__c> invoiceLines = [
                SELECT id, Name, Description__c, Amount__c, Amount_Value__c, Fiscal_Document__c
            	FROM Fiscal_Document_Line__c
                WHERE Fiscal_Document__c =: invoice.id];
        	assertTrue((invoiceLines.size() > 0), 'Expected invoiceLines to exist');
        	for(Fiscal_Document_Line__c invoiceLine : invoiceLines) {
        		System.debug('invoiceLines : ' + invoiceLines);
            }
        }
    }
}