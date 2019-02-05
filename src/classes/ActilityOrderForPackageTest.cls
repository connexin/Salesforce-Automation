@isTest public class ActilityOrderForPackageTest extends AbstractThingParkTestCase {
    
    @isTest static void testOrderInsertTrigger() {
        Test.startTest();
        
        assertNotNull(createMock());
        
        ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            expectedData.givenThingParkPackage();
            // implies expectedData.givenThingParkTenancy();
            // implies expectedData.givenThingParkProduct();
            // implies expectedData.givenThingParkCustomer();
            expectedData.givenInvoiceVatRate();
            expectedData.givenInvoiceRecordType();
            System.debug('Given the expected test data : ' + expectedData);
            
            LoRaWAN_Package__c lorawanPackage = new LoRaWAN_Package__c();
            lorawanPackage.LoRaWAN_Tenancy__c = expectedData.lorawanTenancy.Id;
            // lorawanPackage.Actility_Subscription_ID__c = expectedData.lorawanTenancy.Actility_Subscriber_ID__c;
            lorawanPackage.Name = 'Test-Package' + Timestamp.timeStamp();
            lorawanPackage.Device_Rate__c = 0.05;
            lorawanPackage.Device_Rate_after_commitment_end__c = 0.10;
            lorawanPackage.Start_Date__c = System.today();
            lorawanPackage.Term__c = 12;
            lorawanPackage.Quantity_Of_Devices__c = 10;
            insert lorawanPackage;
            System.debug('Order created: ' + lorawanPackage);
            // @todo check actililty subscriber ID
        }
        Test.stopTest();
    }
    
    @isTest static void testOrderUpdateTrigger() {
        Test.startTest();
        
        ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            expectedData.givenThingParkPackage();
            // implies expectedData.givenThingParkTenancy();
            // implies expectedData.givenThingParkProduct();
            // implies expectedData.givenThingParkCustomer();
            expectedData.givenInvoiceVatRate();
            expectedData.givenInvoiceRecordType();
            System.debug('Given the expected test data : ' + expectedData);
            
            assertNotNull(createMock());

            LoRaWAN_Package__c lorawanPackage = expectedData.lorawanPackage;
            lorawanPackage.LoRaWAN_Tenancy__c = expectedData.lorawanTenancy.Id;
            // lorawanPackage.Actility_Subscription_ID__c = expectedData.lorawanTenancy.Actility_Subscriber_ID__c;
            lorawanPackage.Name = 'Test-Package' + Timestamp.timeStamp();
            lorawanPackage.Device_Rate__c = 0.10;
            lorawanPackage.Device_Rate_after_commitment_end__c = 0.99;
            lorawanPackage.Start_Date__c = System.today();
            lorawanPackage.Term__c = 60;
            lorawanPackage.Quantity_Of_Devices__c = 99;
            update lorawanPackage;
            System.debug('package updated: ' + lorawanPackage);
            // @todo check actililty subscriber ID
        }
        Test.stopTest();
    }    
}