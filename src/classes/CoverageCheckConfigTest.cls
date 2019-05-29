@isTest public class CoverageCheckConfigTest extends AbstractTestCase {

    @isTest static void testCurrent() {
        Test.startTest();

        final CoverageCheckConfig config = CoverageCheckConfig.selectCurrent();
        verifyExpected(config);

        Test.stopTest();
    }
        
    @isTest static void testLatest() {
        Test.startTest();

        final CoverageCheckConfig latestConfig = CoverageCheckConfig.selectLatest();
        verifyExpected(latestConfig);

        Test.stopTest();
    }

    @isTest static void testStable() {
        Test.startTest();

        final CoverageCheckConfig stableConfig = CoverageCheckConfig.selectStable();
        verifyExpected(stableConfig);

        Test.stopTest();
    }

    @isTest static void testMissing() {
        Test.startTest();

        try {
            final CoverageCheckConfig missingConfig = CoverageCheckConfig.selectScope('Missing');
            fail('Unexpected behaviour - fail');
        } catch(Exception e) {
            // Then the expected exception occurs.
            System.debug('expected exception - unit test pass');
        }

        Test.stopTest();
    }
    
    private static void verifyExpected(final CoverageCheckConfig config) {
        assertNotNull(config, 'Configuration not selected.');
        assertNotNull(config.label(), 'Expected configuration label.');
        assertNotNull(config.version(), 'Expected version identifier for the REST service.');
        assertNotNull(config.endpoint(), 'Expected endpoint for REST Service.');
        assertNotNull(config.jsonTemplate(), 'Expected JSON template request.');
		assertNotNull(config.asString());
        log(config);
    }
}