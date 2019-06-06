@isTest public class GenerateApexDtoTest extends AbstractTestCase {

    @isTest static void testGenerateApexDto() {
		Test.startTest();

        assertNotNull(new GenerateApexDto('SELECT FIELDS'));

		Test.stopTest();
    }
}