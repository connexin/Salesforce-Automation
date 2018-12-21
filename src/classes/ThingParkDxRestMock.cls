global class ThingParkDxRestMock implements WebServiceMock {

	private static final String expectedEndpoint = 'https://dx-api.thingpark.com';

	global void doInvoke(
    	Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            // docSample.EchoStringResponse_element responseElement = new docSample.EchoStringResponse_element();
            // responseElement = '{reponse=true}';
            // response.put('response_x', responseElement);
            System.assertEquals(expectedEndpoint, endpoint);
            System.debug(requestName);
            System.debug(request);
            System.debug(endpoint);
   }
}