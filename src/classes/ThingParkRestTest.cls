@isTest public class ThingParkRestTest extends AbstractThingParkTestCase {

    @isTest static void testAddTenancy() {
        Test.startTest();

        createMock();

        ThingParkRest.addTenancy(new LoRaWAN_Tenancy__c());

        Test.stopTest();
    }

    @isTest static void testGetTenancy() {
        Test.startTest();

        createMock();

        ThingParkRest.getTenancy(new LoRaWAN_Tenancy__c());

        Test.stopTest();
    }

    @isTest static void testUpdateTenancy() {
        Test.startTest();

        createMock();

        ThingParkRest.updateTenancy(new LoRaWAN_Tenancy__c());

        Test.stopTest();
    }

    @isTest static void testAddOrder() {
        Test.startTest();

        createMock();

        ThingParkRest.addOrder(new LoRaWAN_Package__c());

        Test.stopTest();
    }

    @isTest static void testGetOrder() {
        Test.startTest();

        createMock();

        ThingParkRest.getOrder(new LoRaWAN_Package__c());

        Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
        Test.startTest();

        createMock();

        ThingParkRest.updateOrder(new LoRaWAN_Package__c());

        Test.stopTest();
    }

}