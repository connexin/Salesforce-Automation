@isTest public class ActilitySubscriberForTenancyTest extends AbstractThingParkTestCase {

    @isTest static void testTenancyInsertTrigger() {
		Test.startTest();

		assertNotNull(createMock());
        
		ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            expectedData.givenThingParkProducts();
            expectedData.givenThingParkCustomer();
            expectedData.givenCustomerContacts();
            System.debug('Given the expected test data : ' + expectedData);

            // When the Tenancy is created in salesforce
            LoRaWAN_Tenancy__c lorawanTenancy = new LoRaWAN_Tenancy__c();
            lorawanTenancy.Account__c = expectedData.account.Id;
            lorawanTenancy.Contact__c = expectedData.primaryContact.Id;
            lorawanTenancy.Name = 'Test-' + Timestamp.timeStamp();
            lorawanTenancy.Daily_Max_Average__c = 99;
            lorawanTenancy.Overage_Rate__c = 0.05;
            insert lorawanTenancy;
            System.debug('tenancy created : ' + lorawanTenancy);
        }
	Test.stopTest();
    }
    
    @isTest static void testTenancyUpdateTrigger() {
		Test.startTest();

		assertNotNull(createMock());

		ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            // Given the expected data
            expectedData.givenThingParkProducts();
            LoRaWAN_Tenancy__c lorawanTenancy = expectedData.givenThingParkTenancy();
            System.debug('Given the expected test data : ' + expectedData);

            // When the Tenancy is updated in salesforce
            lorawanTenancy.Name = 'Test-Update-' + Timestamp.timeStamp();
            lorawanTenancy.Daily_Max_Average__c = 999;
            lorawanTenancy.Overage_Rate__c = 0.10;
            update lorawanTenancy;
            System.debug('tenancy updated: ' + lorawanTenancy);

 			Test.stopTest();
        }
    }
}