global class CreditCheckServiceMock implements HttpCalloutMock {

	private final String expectedAuthorization = 'Bearer MOCK_ACCESS_TOKEN';
    private final String authorisationMockResponse = '{"expires_in":99999,"client_id":"connexin-api/salesforce-actility-api@connexin.co.uk","token_type":"bearer","access_token":"MOCK_ACCESS_TOKEN"}';
    private final String authorisationMockErrorResponse =  '{...}';    
    private final String expectedEndpoint = 'https://creditcheck.example.com';
    
    global HTTPResponse respond(final HTTPRequest request) {
        System.debug('CreditCheckServiceMock request  : ' + request);
        System.debug('CreditCheckServiceMock endpoint : ' + request.getEndpoint());
        System.assert(request.getEndpoint().contains(expectedEndpoint));
        
		if (isAuthorisationRequest(request.getEndpoint())) {
            System.debug('Processing request as authorise');
            return authorise(request);
        } else {
            final String authorization = request.getHeader('Authorization');
            System.assertEquals(expectedAuthorization, authorization, 
                                'Expected ' + expectedAuthorization + ' but was : ' + authorization);
            final HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json;charset=UTF-8');
            response.setBody('true');
            response.setStatusCode(200);
            return response;
            }
    }

    public Boolean isAuthorisationRequest(String requestEndpoint) {
        // if request.getEndpoint includes /admin/{version}/oauth/token
		final String regEx = '\\/admin\\/[\\w\\d\\/]+\\/oauth\\/token';
		final Pattern oauthUriPattern = Pattern.compile(regEx);
		final Matcher oauthUriMatcher = oauthUriPattern.matcher(requestEndpoint);
		final Boolean result = oauthUriMatcher.find();
        System.debug('isAuthorisationRequest : ' + requestEndpoint + ' is ' + result);
        return result;
	}    
    
	public HttpResponse authorise(final HTTPRequest request) {
        final HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        System.assert(request.getMethod() == 'POST');

        final PageReference pageRef = new PageReference(request.getEndpoint());
        System.debug('pageRef.getParameters() : ' + pageRef.getParameters());

        final String grantType = pageRef.getParameters().get('grant_type');
        System.debug('grant_type : ' + grantType);
        System.assertEquals('client_credentials', grantType, 'Unexpected grantType : ' + grantType);

        final String clientId = pageRef.getParameters().get('client_id');
        System.debug('client_id : ' + clientId);
        System.assertEquals('connexin-api/salesforce-actility-api@connexin.co.uk', clientId, 'Unexpected clientId : ' + clientId);

        final String clientSecret  = pageRef.getParameters().get('client_secret');
        System.debug('client_secret : ' + clientSecret);
        System.assert(clientSecret.isAlphanumeric(), 'Unexpected clientSecret : ' + clientSecret);

        response.setBody(authorisationMockResponse);
        response.setStatusCode(200);

        return response;
    }

	public HttpResponse unsupportedRequest(final HTTPRequest request) {
            System.debug('Unsupported Request in Mock : ' + request.getMethod() + ' ' + request.getEndpoint());
			final HttpResponse response = new HttpResponse();
        	String errorBody = '{ "CreditCheckServiceMock":"mock",'
                             + '"Error":"Unsupported Request in Mock",'
                             + '"Method":"' + request.getMethod() + '",'
                             + '"Method":"' + request.getEndpoint() + '" }';
            System.debug('errorBody : ' + errorBody);
            response.setBody(errorBody);
            response.setStatusCode(500);
	        return response;
    }
        
}