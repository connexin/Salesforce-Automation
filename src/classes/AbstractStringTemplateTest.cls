@isTest public class AbstractStringTemplateTest extends AbstractTestCase {

    private class MockStringTemplate extends AbstractStringTemplate {
        MockStringTemplate(final String template) {
            super(template);
        }
    }    
    
    @isTest static void testGenerateApexDto() {
		Test.startTest();

        assertNotNull(new MockStringTemplate('SELECT {FIELDS} FROM {TABLE}'));

		Test.stopTest();
    }
    
    
}