@isTest public class ResidentialCreditCheckTest extends AbstractTestCase {
    
    @isTest static void testResidentialCreditCheck() {
		Test.startTest();
        
        ResidentialCreditCheck instance = new ResidentialCreditCheck();
        assertNotNull(instance);
        
		Test.stopTest();
    }
}