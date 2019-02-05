@isTest public class ThingParkSubscriberJsonTest extends AbstractTestCase {

    @isTest static void testThingParkSubscriberJson() {
        Test.startTest();

        // Given a Json template for a ThingPark Subscriber
        final ThingParkSubscriberJson instance = new ThingParkSubscriberJson();
        assertNotNull(instance);

        // And the values to be replaced
        instance.firstName = '***firstName***';
        instance.lastName = '***lastName***';
        instance.email = '***email@example.com***';
        instance.organization = '***organization***';
        instance.externalId = '***externalId***';
        instance.password = '***password***';

        // When the json is generated
        final String jsonStr = instance.toJson();

        // Then the Json is valid
		assertNotNull(jsonStr);
        System.debug('jsonStr : ' + jsonStr);
        assertTrue(verifyJson(jsonStr));

		Test.stopTest();
    }

    @isTest static void testThingParkSubscriberJsonDetails() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        // And the values to be replaced
        final ThingParkSubscriberJson instance = new ThingParkSubscriberJson('###firstName###', 
                                                                       '###lastName###', 
                                                                       '###email@example.com###', 
                                                                       '###organization###', 
                                                                       '###externalId###', 
                                                                       '###password###');
        assertNotNull(instance);

        // When the json is generated
        final String jsonStr = instance.toJson();
		assertNotNull(jsonStr);

        // Then the Json is valid        
        assertTrue(verifyJson(jsonStr));
        System.debug('jsonStr : ' + jsonStr);

		Test.stopTest();
    }
    
    @isTest static void testThingParkSubscriberJsonNulls() {
        Test.startTest();

        // Given a Json template for a ThingPark Subscriber
        final ThingParkSubscriberJson instance = new ThingParkSubscriberJson();
        assertNotNull(instance);

        // And the values to be replaced are undefined.
        try {
        	// When the json is generated
            instance.toJson();
            fail('Unexpected behaviour - fail');
        } catch(Exception e) {
            // Then the expected exception occurs.
            System.debug('expected exception - unit test pass');
        }

		Test.stopTest();
    }

    @isTest static void testThingParkSubscriberJsonVerify() {
        Test.startTest();

        // Given a Json template for a ThingPark Subscriber
        final ThingParkSubscriberJson instance = new ThingParkSubscriberJson();
        assertNotNull(instance);
		assertNotNull(instance.verify());

		Test.stopTest();
    }

    @isTest static void testThingParkSubscriberJsonByScope() {
        Test.startTest();

        assertNotNull(new ThingParkSubscriberJson('Current'));
        assertNotNull(new ThingParkSubscriberJson('Latest'));
        assertNotNull(new ThingParkSubscriberJson('Stable'));

        Test.stopTest();
    }
    
    @isTest static void testThingParkSubscriberJsonReplacement() {
        Test.startTest();

        // Given a Json template for a ThingPark Subscriber
        final ThingParkSubscriberJson instance = new ThingParkSubscriberJson();
        assertNotNull(instance);

        // And the values to be replaced
        instance.firstName = '***firstName***';
        instance.lastName = '***lastName***';
        instance.email = '***email@example.com***';
        instance.organization = '***organization***';
        instance.externalId = '***externalId***';
        instance.password = '***password***';

        // When the json is generated
        final String jsonStr = instance.toJson();

        // Then the Json is valid
		assertNotNull(jsonStr);
        System.debug('jsonStr : ' + jsonStr);
        assertTrue(verifyJson(jsonStr));

		Test.stopTest();
    }
}