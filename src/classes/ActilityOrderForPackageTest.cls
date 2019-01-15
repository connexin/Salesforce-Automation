@isTest public class ActilityOrderForPackageTest extends AbstractThingParkTestCase {

    @isTest static void testOrderTrigger() {
        // Given Test User
        // User user = [SELECT Name FROM User WHERE Name LIKE '%Test User%'];
        User user = [SELECT name, Id  FROM user LIMIT 1];
		assertNotNull(user, 'Expected user to be available for test.');
        System.debug('Running as : ' + user);

        system.runAs(user) {
        	// And Given Test Account
			Account newAccount = new Account(Name='Test LoRaWAN Customer ' + Timestamp.timestamp());
			assertNotNull(newAccount);
            insert newAccount;

            Account testAccount = [SELECT Name FROM Account WHERE Name LIKE '%Test LoRaWAN Customer%'];
			assertNotNull(testAccount);

            // And Given a Tenancy
            LoRaWAN_Tenancy__c newTenancy = new LoRaWAN_Tenancy__c();
            newTenancy.Account__c = testAccount.Id;
            newTenancy.Name = 'Test-' + Timestamp.timeStamp();
            newTenancy.Daily_Max_Average__c = 99;
            newTenancy.Overage_Rate__c = 0.05;
            insert newTenancy;

            Test.startTest();

			ThingParkRestMock mock = createMock();

            LoRaWAN_Package__c order = new LoRaWAN_Package__c();
            order.LoRaWAN_Tenancy__c = newTenancy.Id;
            order.Actility_Subscription_ID__c = newTenancy.Actility_Subscriber_ID__c;
            order.Name = 'Test-Package' + Timestamp.timeStamp();
            order.Device_Rate__c = 0.05;
            order.Device_Rate_after_commitment_end__c = 0.10;
            order.Start_Date__c = System.today();
            order.Term__c = 12;
            order.Quantity_Of_Devices__c = 99;
            insert order;

            System.debug('mock : ' + mock);

 			Test.stopTest();
        }
    }    
}