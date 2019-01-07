@isTest public class ThingParkTest {


	@isTest static void testAddTenancy() {
		Test.startTest();

		createMock();

        // Example json
        // 	'{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);

        ThingParkREST.addTenancy(new LoRaWAN_Tenancy__c());

		Test.stopTest();
    }

    @isTest static void testGetTenancy() {
		Test.startTest();

		createMock();

        ThingParkREST.getTenancy(new LoRaWAN_Tenancy__c());

		Test.stopTest();
    }

    @isTest static void testUpdateTenancy() {
		Test.startTest();

		createMock();

        // Example json
        // 	'{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);
        
        ThingParkREST.updateTenancy(new LoRaWAN_Tenancy__c());

		Test.stopTest();
    }

	@isTest static void testAddOrder() {
		Test.startTest();

		createMock();

        // Example Json
        // '{ "id":"connexin-vdr/test-offer", "name":"Offer for testing",  "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"id":"connexin-vdr/test-offer", "name":"Offer for testing", "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}');
        // System.debug('jsonData = ' + jsonData);

        ThingParkREST.addOrder(new LoRaWAN_Package__c());

		Test.stopTest();
    }

    @isTest static void testGetOrder() {
		Test.startTest();

		createMock();

        ThingParkREST.getOrder(new LoRaWAN_Package__c());

		Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
		Test.startTest();

		createMock();

        ThingParkREST.updateOrder(new LoRaWAN_Package__c());

		Test.stopTest();
    }

    private static HttpCalloutMock createMock() {
		// Create the mock response based on a static resource
        HttpCalloutMock mock = new ThingParkDxRestMock();
		Test.setMock(HttpCalloutMock.class, mock);
        return mock;
	}
}