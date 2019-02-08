@isTest public class StringTemplateTests {

    @isTest static void testStringTemplate() {
        Test.startTest();
        final StringTemplate template = new StringTemplate('forname:{forename}, surname:{surname}');
        System.debug('template : ' + template);
        Test.stopTest();
    }

    @isTest static void testStringTemplateReplace() {
        Test.startTest();
        final StringTemplate template = new StringTemplate('forname:{forename}, surname:{surname}');
        System.debug('template : ' + template);
        System.debug('template : ' + template.replace('{forename}', 'Bob'));
        System.debug('template : ' + template.replace('{surname}', 'Baker'));
        Test.stopTest();
    }

    @isTest static void testStringTemplateReplaceAll() {
        final Map<String, String> testValues = new Map<String, String> {
            '{forename}' => 'Alice',
			'{surname}' => 'Smith' };

        Test.startTest();
        final StringTemplate template = new StringTemplate('forname:{forename}, surname:{surname}');
        System.debug('template : ' + template);
        System.debug('template : ' + template.replaceAll(testValues));
        Test.stopTest();
    }

}