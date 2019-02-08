@isTest public class ThingParkInvoiceCreateTest extends AbstractTestCase {

    @isTest static void testThingParkInvoiceCreate() {		
        ExpectedDataManager expectedData = new ExpectedDataManager();
        System.assert(expectedData != null);
        
        // Given pre-requisite data for a provisioned service
        expectedData.givenTestProduct();
        expectedData.givenThingParkPackage();
        // implies expectedData.givenThingParkTenancy();
        // implies expectedData.givenThingParkCustomer();
        expectedData.givenInvoiceVatRate();
        expectedData.givenInvoiceRecordType();
        
        Test.startTest();
        
        ThingParkInvoice invoice = invoiceFor(expectedData);
        System.assert(invoice != null);
        invoice.toLog();
        
        Test.stopTest();
    }
    
    private static ThingParkInvoice invoiceFor(final ExpectedDataManager expectedData) {
        final ThingParkInvoice invoice = ThingParkInvoice.create(expectedData.account.id,
                                                                 'Test-Invoice ' + TimeStamp.timeStamp());
        
        invoice.addDeviceCharges('Device Charges',
                                 expectedData.testProduct.id,
                                 expectedData.lorawanPackage.Quantity_Of_Devices__c,
                                 expectedData.lorawanPackage.Device_Rate__c);
        
        invoice.addServiceCharges('Service Charges',
                                  expectedData.testProduct.id,
                                  expectedData.lorawanPackage.Quantity_Of_Devices__c,
                                  expectedData.lorawanPackage.Device_Rate__c);
        
        final Decimal messageOverage = 100 - expectedData.lorawanTenancy.Daily_Max_Average__c;
        invoice.addOverageCharges('Overage Charges',
                                  expectedData.testProduct.id,
                                  messageOverage,
                                  expectedData.lorawanTenancy.Overage_Rate__c);
        
        invoice.addEndOfLifeCharges('EOL Charges',
                                    expectedData.testProduct.id,
                                    expectedData.lorawanPackage.Quantity_Of_Devices__c,
                                    expectedData.lorawanPackage.Device_Rate_after_commitment_end__c);
        
        System.debug('@4 invoiceForProduct.invoice : ' + invoice);
        
        return invoice;
    }
}