@isTest global class ThingParkHttpMock implements HttpCalloutMock {

	private String expectedEndpoint = 'https://dx-api.thingpark.com';

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Optionally, only send a mock response for a specific endpoint
        System.assertEquals(expectedEndpoint, request.getEndpoint());
        System.assertEquals('GET', request.getMethod());

        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"example":"test"}');
        response.setStatusCode(200);
        return response;
    }    

}
