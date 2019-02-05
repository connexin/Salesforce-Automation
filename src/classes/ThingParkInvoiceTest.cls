@isTest public class ThingParkInvoiceTest extends AbstractTestCase {

    private static String invoiceJson = '{"description": "ThingPark Usage Invoice", "invoice_date": "2019-02-01", "due_date": "2019-03-31", "accountId": "000000000", "lines": [{ "productId": "lorawan-01", "description": "service","qty": "1","unit_price": "2.00"},{ "productId": "lorawan-01", "description": "devices","qty": "2","unit_price": "2.00"},{ "productId": "lorawan-01", "description": "overage","qty": "3","unit_price": "2.00"}]}';

    @isTest static void testThingParkInvoiceJson() {
        verifyJson(invoiceJson);
    }
    
    @isTest static void testThingParkInvoiceCreate() {
        System.debug('testThingParkInvoiceCreate');
		System.debug('count invoices : ' + [SELECT count() FROM Fiscal_Document__c ]);

        // Given pre-requisite data for a provisioned service
        final ExpectedDataManager expectedData = new ExpectedDataManager();
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
            // Then test ThingPark Invoice Creation
            // public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
            final ThingParkInvoice invoice = ThingParkInvoice.create(expectedData.account.id,
                                                               'Test-Invoice ' + TimeStamp.timeStamp());
            assertNotNull(invoice);
            
            // public ThingParkInvoice addDeviceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addDeviceCharges(product.id,
                                     expectedData.lorawanTenancy.Total_Devices__c);
                                     // expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addServiceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            invoice.addServiceCharges(product.id,
                                      expectedData.lorawanTenancy.Daily_Max_Average__c);
                                      // expectedData.lorawanPackage.Device_Rate__c);
            
            // public ThingParkInvoice addOverageCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
            final Decimal totalMessage = 100;
            invoice.addOverageCharges(product.id,
                                      totalMessage - expectedData.lorawanTenancy.Daily_Max_Average__c);
                                      // expectedData.lorawanTenancy.Overage_Rate__c);
            
            invoice.addEndOfLifeCharges(product.id,
                                        expectedData.lorawanTenancy.Total_Devices__c);
                                        // expectedData.lorawanPackage.Device_Rate_after_commitment_end__c);

            System.debug('invoice : ' + invoice);
        }
        
        verifyFiscalDocument(expectedData.account.id);
    }

    private static void verifyFiscalDocument(final String accountId) {
		System.debug('verifyFiscalDocument count invoices : ' + [SELECT count() FROM Fiscal_Document__c WHERE Account__c =: accountId]);
        final List<Fiscal_Document__c> invoices = [
            SELECT id, Name, Account__c, Description__c, Date__c, Actual_Due_Date__c, 
            Net_Subtotal__c, Subtotal_Value__c, Subtotal__c, Tax_Subtotal__c, Tax_Value__c, Total_Value__c 
            FROM Fiscal_Document__c
            WHERE Account__c =: accountId];
        assertTrue((invoices.size() > 0), 'Expected invoices to exist');
        for(Fiscal_Document__c invoice : invoices) {
        	System.debug('invoice : ' + invoice);
			// System.debug('count invoices lines : ' + [SELECT count() FROM Fiscal_Document_Line__c WHERE Fiscal_Document__c =: invoice.id].count);
            final List<Fiscal_Document_Line__c> invoiceLines = [
                SELECT id, Name, Description__c, Amount__c, Amount_Value__c, Fiscal_Document__c
            	FROM Fiscal_Document_Line__c
                WHERE Fiscal_Document__c =: invoice.id];

        	// assertTrue((invoiceLines.size() > 0), 'Expected invoiceLines to exist');
        	for(Fiscal_Document_Line__c invoiceLine : invoiceLines) {
        		System.debug('invoiceLines : ' + invoiceLines);
            }
        }
    }
}