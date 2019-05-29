@isTest public class CreditCheckServiceTest extends AbstractTestCase {

    @isTest static void testCreditCheck() {
        Test.startTest();

        StatusResult pending = new CreditCheck();

        StatusResult passed = CreditCheck.fromValue(true);
        assertTrue(passed.isPassed());
        assertFalse(passed.isFailed());

        StatusResult failed = CreditCheck.fromValue(false);
        assertTrue(failed.isFailed());
        assertFalse(failed.isPassed());

        Test.stopTest();        
    }
    
    
    @isTest static void testCreditCheckService() {
        Test.startTest();

        assumeNotNull(createMock());
        
        Test.stopTest();        
    }
    
    private static CreditCheckServiceMock mock;

    public static CreditCheckServiceMock createMock() {
        if (mock == null) {
            // Create the mock response based on a static resource
            mock = new CreditCheckServiceMock();
            Test.setMock(CreditCheckServiceMock.class, mock);
        }
        return mock;
    }

}