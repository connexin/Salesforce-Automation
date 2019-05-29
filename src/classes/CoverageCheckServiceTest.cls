@isTest public class CoverageCheckServiceTest extends AbstractTestCase {
    
    @isTest static void testCoverageCheckService() {
        Test.startTest();

        assumeNotNull(createMock());
        
        Test.stopTest();        
    }

    private static CoverageCheckServiceMock mock;
    
    public static CoverageCheckServiceMock createMock() {
        if (mock == null) {
            // Create the mock response based on a static resource
            mock = new CoverageCheckServiceMock();
            Test.setMock(CoverageCheckServiceMock.class, mock);
        }
        return mock;
    }
}