@isTest public class ThingParkOrderJsonTest extends AbstractTestCase {

    @isTest static void testMakeThingParkOrderJson() {
        Test.startTest();

        ThingParkOrderJson factory = new ThingParkOrderJson();
        String newOrderJson = factory.jsonFrom(new LoRaWAN_Package__c());
        System.debug('newOrderJson : ' + newOrderJson);

        Test.stopTest();
    }
}