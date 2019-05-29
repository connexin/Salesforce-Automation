@isTest public class CoverageCheckResultTest  extends AbstractTestCase {

    @isTest static void testCreditCheck() {
        Test.startTest();

        CoverageCheckResult pending = new CoverageCheckResult();

        CoverageCheckResult passed = CoverageCheckResult.fromValue(true);
        assertTrue(passed.isPassed());
        assertFalse(passed.isFailed());

        CoverageCheckResult failed = CoverageCheckResult.fromValue(false);
        assertTrue(failed.isFailed());
        assertFalse(failed.isPassed());

        Test.stopTest();        
    }    

}