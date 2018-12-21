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

    private static void createMock() {
    	createHttpMock();
    }

    private static HttpCalloutMock createHttpMock() {
		// Create the mock response based on a static resource
        // HttpCalloutMock mock = new ThingParkHttpMock();
		// Test.setMock(WebServiceMock.class, mock);        
        // mock.setStatusCode(200);
        // mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // return mock;

        HttpCalloutMock mock = new ThingParkHttpMock();

		Test.setMock(HttpCalloutMock.class, mock);

		return mock;
    }

    // private static WebServiceMock createRestMock() {
		// Create the mock response based on a static resource
        // WebServiceMock mock = new ThingParkDxRestMock();
		// Test.setMock(WebServiceMock.class, mock);        
        // mock.setStatusCode(200);
        // mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // return mock;

        // WebServiceMock mock = new ThingParkDxRestMock();

		// Test.setMock(WebServiceMock.class, mock);

		// return mock;
    // }

	@isTest static void testThingParkHttpMock() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ThingParkHttpMock());

        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse response = makeMockRequest();
        
        // Verify response received contains fake values
        verifyMockResponse(response);
    }

    public static HttpResponse makeMockRequest() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://dx-api.thingpark.com');
        request.setMethod('GET');
        Http http = new Http();
        return http.send(request);
    }

    public static HttpResponse verifyMockResponse(final HttpResponse response) {
        System.assert(response.getHeader('Content-Type') == 'application/json');
        String expectedBody = '{"example":"test"}';
        System.assertEquals(expectedBody, response.getBody());
        System.assertEquals(200, response.getStatusCode());
        return response;
    }    
}
