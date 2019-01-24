@isTest public class ThingParkOrderJsonTest extends AbstractTestCase {

    @isTest static void testMakeThingParkOrderJson() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson();
        assertNotNull(instance);
        
        // When the values are replaced
        instance.offerId = '***offerId***';
        instance.subscriberId = '***subscriberId***';

        // Then the Json is still valid
        final String jsonStr = instance.toJson();
		assertNotNull(jsonStr);
        System.debug('jsonStr : ' + jsonStr);
        assertTrue(verifyJson(jsonStr));

        Test.stopTest();
    }

    @isTest static void testMakeThingParkOrderJsonDetails() {
        Test.startTest();

        // Given a Json template for a ThingPark Order
        ThingParkOrderJson instance = new ThingParkOrderJson('foo', 'bar');
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