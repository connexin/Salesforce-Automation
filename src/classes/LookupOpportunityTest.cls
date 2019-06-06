@isTest public class LookupOpportunityTest extends AbstractTestCase {

    @isTest static void testLookupOpportunityByName() {
        Test.startTest();
		List<String> names = new List<String>();
        assertNotNull(LookupOpportunity.byName(names));
		Test.stopTest();
    }

}