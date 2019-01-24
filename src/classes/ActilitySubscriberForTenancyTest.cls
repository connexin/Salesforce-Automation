@isTest public class ActilitySubscriberForTenancyTest extends AbstractThingParkTestCase {

    @isTest static void testTenancyInsertTrigger() {
		Test.startTest();

		assertNotNull(createMock());
        
		ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            expectedData.givenThingParkProducts();
            expectedData.givenThingParkCustomer();
            expectedData.givenCustomerContacts();
            System.debug('***** expectedData : ' + expectedData);

            // When the Tenancy is created
            LoRaWAN_Tenancy__c tenancy = new LoRaWAN_Tenancy__c();
            tenancy.Account__c = expectedData.account.Id;
            tenancy.Contact__c = expectedData.primaryContact.Id;
            tenancy.Name = 'Test-' + Timestamp.timeStamp();
            tenancy.Daily_Max_Average__c = 99;
            tenancy.Overage_Rate__c = 0.05;
            System.debug('create tenancy : ' + tenancy);
            insert tenancy;
        }
	Test.stopTest();
    }
    
    @isTest static void testTenancyUpdateTrigger() {
		Test.startTest();

		assertNotNull(createMock());
        
		ExpectedDataManager expectedData = new ExpectedDataManager();
        
        system.runAs(expectedData.givenTestUser()) {
            expectedData.givenThingParkProducts();
            LoRaWAN_Tenancy__c testTenancy = expectedData.givenThingParkTenancy();
            System.debug('***** expectedData : ' + expectedData);

            // When the Tenancy is updated
            testTenancy.Name = 'Test-Update-' + Timestamp.timeStamp();
            testTenancy.Daily_Max_Average__c = 999;
            testTenancy.Overage_Rate__c = 0.10;
            System.debug('update tenancy : ' + testTenancy);
            update testTenancy;

 			Test.stopTest();
        }
    }
}