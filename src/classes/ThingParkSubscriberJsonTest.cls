@isTest public class ThingParkSubscriberJsonTest extends AbstractTestCase {

    @isTest static void testThingParkSubscriberJson() {
        Test.startTest();

        ThingParkSubscriberJson factory = new ThingParkSubscriberJson();
        final String newTenancyJson = factory.toJson();
        System.debug('newTenancyJson : ' + newTenancyJson);

		Test.stopTest();
    }
}