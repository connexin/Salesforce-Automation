@isTest public class ResidentialCoverageCheckTest extends AbstractTestCase {
    
    @isTest static void testResidentialCoverageCheck() {
		Test.startTest();
        
        ResidentialCoverageCheck instance = new ResidentialCoverageCheck();
        assertNotNull(instance);
        
		Test.stopTest();
    }
}