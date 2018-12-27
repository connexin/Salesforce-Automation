@isTest public class ThingParkTest {

	@isTest static void testAddTenancy() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.addTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

    @isTest static void testGetTenancy() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.getTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

    @isTest static void testUpdateTenancy() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.updateTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

	@isTest static void testAddOrder() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.addOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }

    @isTest static void testGetOrder() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.getOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
		Test.startTest();

		createMock();

        System.assert(ThingParkREST.updateOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }

	@isTest static void testThingParkHttpMock() {
		createMock();

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://dx-api.thingpark.com');
        request.setMethod('GET');
        // request.setParameter();
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Verify response received contains fake values
        System.assert(response.getHeader('Content-Type') == 'application/json');
        String expectedBody = '{"ThingPark":"mock"}';
        System.assertEquals(expectedBody, response.getBody());
        System.assertEquals(200, response.getStatusCode());
    }

    private static HttpCalloutMock createMock() {
		// Create the mock response based on a static resource
        HttpCalloutMock mock = new ThingParkDxRestMock();
		Test.setMock(HttpCalloutMock.class, mock);
        return mock;
	}
    
}