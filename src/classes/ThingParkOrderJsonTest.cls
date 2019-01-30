@isTest public class ThingParkOrderJsonTest extends AbstractTestCase {

    @isTest static void testMakeThingParkOrderJson() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson();
        assertNotNull(instance);
        
        // And the values to be replaced
        instance.offerId = '***offerId***';
        instance.subscriberId = '***subscriberId***';

        // When the json is generated
        final String jsonStr = instance.toJson();
        
        // Then the Json is still valid
		assertNotNull(jsonStr);
        System.debug('jsonStr : ' + jsonStr);
        assertTrue(verifyJson(jsonStr));

        Test.stopTest();
    }

    @isTest static void testMakeThingParkOrderJsonDetails() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson('###offerId###', '###subscriberId###');
        assertNotNull(instance);

        // When the json is generated
        final String jsonStr = instance.toJson();
		assertNotNull(jsonStr);

        // Then the Json is still valid        
        assertTrue(verifyJson(jsonStr));
        System.debug('jsonStr : ' + jsonStr);

        Test.stopTest();
    }

    @isTest static void testMakeThingParkOrderJsonNulNull() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson();
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
    @isTest static void testThingParkOrderJsonVerify() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson();
        assertNotNull(instance);
		assertNotNull(instance.verify());

		Test.stopTest();
    }
    
    @isTest static void testThingParkOrderJsonByScope() {
        Test.startTest();

        assertNotNull(new ThingParkOrderJson('Current'));
        assertNotNull(new ThingParkOrderJson('Latest'));
        assertNotNull(new ThingParkOrderJson('Stable'));

        Test.stopTest();
    }
}