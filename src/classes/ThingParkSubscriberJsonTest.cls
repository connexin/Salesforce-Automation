@isTest public class ThingParkSubscriberJsonTest extends AbstractTestCase {

    @isTest static void testThingParkSubscriberJson() {
        Test.startTest();

        // Given a Json template for a ThingPark Subscriber        
        ThingParkSubscriberJson instance = new ThingParkSubscriberJson();
        assertNotNull(instance);
        
        // When the values are replaced        
        instance.firstName = '***firstName***';
        instance.lastName = '***lastName***';
        instance.email = '***emai@example.com***';
        instance.organization = '***organization***';
        instance.password = '***password***';

        // Then the Json is still valid
        final String jsonStr = instance.toJson();
		assertNotNull(jsonStr);
        System.debug('jsonStr : ' + jsonStr);
        assertTrue(verifyJson(jsonStr));

		Test.stopTest();
    }

    @isTest static void testThingParkSubscriberJsonDetails() {
        Test.startTest();

        // Given a Json template for a ThingPark Order        
        ThingParkSubscriberJson instance = new ThingParkSubscriberJson('FirstName', 'LastName', 'test@example.com', 'Test Org', 'password');
        assertNotNull(instance);
        
        // When the values are replaced        
        final String jsonStr = instance.toJson();
		assertNotNull(jsonStr);

        // Then the Json is still valid        
        assertTrue(verifyJson(jsonStr));
        System.debug('jsonStr : ' + jsonStr);

		Test.stopTest();
    }
}