@isTest public class ThingParkRestConfigTest extends AbstractTestCase {

    @isTest static void testCurrent() {
        Test.startTest();

        final ThingParkRestConfig config = ThingParkRestConfig.selectCurrent();
        verifyExpected(config);

        Test.stopTest();
    }
        
    @isTest static void testLatest() {
        Test.startTest();

        final ThingParkRestConfig latestConfig = ThingParkRestConfig.selectLatest();
        verifyExpected(latestConfig);

        Test.stopTest();
    }

    @isTest static void testStable() {
        Test.startTest();

        final ThingParkRestConfig stableConfig = ThingParkRestConfig.selectStable();
        verifyExpected(stableConfig);

        Test.stopTest();
    }

    @isTest static void testMissing() {
        Test.startTest();

        try {
            final ThingParkRestConfig missingConfig = ThingParkRestConfig.selectScope('Missing');
            fail('Unexpected behaviour - fail');
        } catch(Exception e) {
            // Then the expected exception occurs.
            System.debug('expected exception - unit test pass');
        }

        Test.stopTest();
    }
    
    private static void verifyExpected(final ThingParkRestConfig config) {
        assertNotNull(config, 'Configuration not selected.');
        assertNotNull(config.label(), 'Expected configuration label.');
        assertNotNull(config.version(), 'Expected version identifier for the REST service.');
        assertNotNull(config.clientId(), 'Expected client identifier to be defined for REST service.');
        assertNotNull(config.clientPassword(), 'Expected client password to be defined for REST service.');
        assertNotNull(config.clientSecret(), 'Expected client secret to be defined for REST service.');
        assertNotNull(config.endpoint(), 'Expected endpoint for ThingPark REST.');
        assertNotNull(config.subscriberJsonTemplate(), 'Expected JSON template for Subscriber.');
        assertNotNull(config.orderJsonTemplate(), 'Expected JSON template for Order.');
		assertNotNull(config.asString());
        log(config);
    }
}