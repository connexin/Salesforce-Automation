@isTest public class CreditCheckResultTest  extends AbstractTestCase {

    @isTest static void testCreditCheck() {
        Test.startTest();

        CreditCheckResult pending = new CreditCheckResult();

        CreditCheckResult passed = CreditCheckResult.fromValue(true);
        assertTrue(passed.isPassed());
        assertFalse(passed.isFailed());

        CreditCheckResult failed = CreditCheckResult.fromValue(false);
        assertTrue(failed.isFailed());
        assertFalse(failed.isPassed());

        Test.stopTest();        
    }    

}