@isTest public class ThingParkRestTest {

    @isTest static void testAddTenancy() {
        Test.startTest();

        createMock();

        // Example json
        //  '{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);

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

        // Example json
        //  '{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);
        
        ThingParkRest.updateTenancy(new LoRaWAN_Tenancy__c());

        Test.stopTest();
    }

    @isTest static void testAddOrder() {
        Test.startTest();

        createMock();

        // Example Json
        // '{ "id":"connexin-vdr/test-offer", "name":"Offer for testing",  "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"id":"connexin-vdr/test-offer", "name":"Offer for testing", "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}');
        // System.debug('jsonData = ' + jsonData);

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

    private static HttpCalloutMock createMock() {
        // Create the mock response based on a static resource
        HttpCalloutMock mock = new ThingParkDxRestMock();
        Test.setMock(HttpCalloutMock.class, mock);
        return mock;
    }
}