@isTest public class CreditCheckConfigTest extends AbstractTestCase {

    @isTest static void testCurrent() {
        Test.startTest();

        final CreditCheckConfig config = CreditCheckConfig.selectCurrent();
        verifyExpected(config);

        Test.stopTest();
    }
        
    @isTest static void testLatest() {
        Test.startTest();

        final CreditCheckConfig latestConfig = CreditCheckConfig.selectLatest();
        verifyExpected(latestConfig);

        Test.stopTest();
    }

    @isTest static void testStable() {
        Test.startTest();

        final CreditCheckConfig stableConfig = CreditCheckConfig.selectStable();
        verifyExpected(stableConfig);

        Test.stopTest();
    }

    @isTest static void testMissing() {
        Test.startTest();

        try {
            final CreditCheckConfig missingConfig = CreditCheckConfig.selectScope('Missing');
            fail('Unexpected behaviour - fail');
        } catch(Exception e) {
            // Then the expected exception occurs.
            System.debug('expected exception - unit test pass');
        }

        Test.stopTest();
    }
    
    private static void verifyExpected(final CreditCheckConfig config) {
        assertNotNull(config, 'Configuration not selected.');
        assertNotNull(config.label(), 'Expected configuration label.');
        assertNotNull(config.version(), 'Expected version identifier for the REST service.');
        assertNotNull(config.endpoint(), 'Expected endpoint for REST Service.');        
        assertNotNull(config.jsonTemplate(), 'Expected JSON template request.');
		assertNotNull(config.asString());
        log(config);
    }
}