@isTest public class ActilitySubscriberForTenancyTest extends AbstractThingParkTestCase {

    @isTest static void testTenancyTrigger() {
        // Given Test User
    	// User user = [SELECT Name FROM User WHERE Name LIKE '%Test User%'];
		User user = [select name, Id  FROM user LIMIT 1];
		assertNotNull(user, 'Expected user to be available for test.');
        System.debug('Running as : ' + user);

        system.runAs(user) {
        	// And Given Test Account
			Account newAccount = new Account(Name='Test LoRaWAN Customer ' + Timestamp.timestamp());
			assertNotNull(newAccount);
            insert newAccount;

            Account testAccount = [SELECT Name FROM Account WHERE Name LIKE '%Test LoRaWAN Customer%'];
			assertNotNull(testAccount);

			Test.startTest();

			ThingParkRestMock mock = createMock();

            // When the Tenancy is created
            LoRaWAN_Tenancy__c tenancy = new LoRaWAN_Tenancy__c();
            tenancy.Account__c = testAccount.Id;
            tenancy.Name = 'Test-' + Timestamp.timeStamp();
            tenancy.Daily_Max_Average__c = 99;
            tenancy.Overage_Rate__c = 0.05;
            insert tenancy;

            // Whent the Tenancy is updated
            LoRaWAN_Tenancy__c testTenancy = [SELECT Name FROM LoRaWAN_Tenancy__c WHERE Account__r.Name LIKE '%Test LoRaWAN Customer%'];
            testTenancy.Name = 'Test-Update-' + Timestamp.timeStamp();
            testTenancy.Daily_Max_Average__c = 999;
            testTenancy.Overage_Rate__c = 0.10;
            update testTenancy;

            System.debug('mock : ' + mock);
            
 			Test.stopTest();
        }
    }
}