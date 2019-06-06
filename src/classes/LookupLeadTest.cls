@isTest public class LookupLeadTest extends AbstractTestCase {

	@isTest static void testLookupLeadByPostcode() {
        Test.startTest();
		List<String> postcodes = new List<String>();
        assertNotNull(LookupLead.byPostcode(postcodes));
		Test.stopTest();
    }

}