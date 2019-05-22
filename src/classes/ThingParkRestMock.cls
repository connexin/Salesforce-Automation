global class ThingParkRestMock implements HttpCalloutMock {

	private final String expectedAuthorization = 'Bearer MOCK_ACCESS_TOKEN';
    private final String expectedEndpoint = 'https://dx-api.thingpark.com';
    private final String authorisationMockResponse = '{"expires_in":99999,"client_id":"connexin-api/salesforce-actility-api@connexin.co.uk","token_type":"bearer","access_token":"MOCK_ACCESS_TOKEN"}';
    private final String authorisationMockErrorResponse =  '{...}';
    private final String subscriberMockResponse = '{ "id": "100030634", "ref": "88888", "name": "Alice Automation", "contactEmail": "alice.automation@connexin.co.uk","organization": "Hull Digital City", "primaryUser": { "id": "tpk-100036913", "ref": "36913", "firstName": "Alice", "lastName": "Tester", "email": "alice.test@connexin.co.uk", "organization": "Hull Digital City", "scopes": ["SUBSCRIBER:30634"]}}';
    private final String subscriberMockErrorResponse = '{ ... }';
    private final String orderMockResponse = '{"id":"200021233","ref":"44914","offerId":"connexin-vdr/test-offer","subscriberId":"100030634","state": "TEST"}';
    private final String orderMockErrorResponse = '{...}';
    private final String offerMockResponse  = '{"id":"connexin-vdr/test-offer","ref":"8404","name":"Starter test offer","state":"TEST","items":[{"productId":"actility-sup/device-manager","productType":"APPLICATION","quantity":1},{"productId":"actility-sup/network-manager","productType":"APPLICATION","quantity":1}]}';
    private final String offerMockErrorResponse = '{...}';
    private final String deviceMockResponse = '{"ref":"333580","name":"0018B20000001BF0","EUI":"0018B20000001BF0","networkAddress":"2FDB487E"},' +
        '{"ref":"336532","name":"Waste Sensor #1","EUI":"70B3D53260000ED0","networkAddress":"60000ED0"},' +
        '{"ref":"336538","name":"Waste Sensor #2","EUI":"70B3D53260000FA4","networkAddress":"60000FA4"},' +
        '{"ref":"344170","name":"Bin Sensor #2","EUI":"70B3D5326000908D","networkAddress":"6000908D"},' +
        '{"ref":"344173","name":"Bin Sensor #3","EUI":"70B3D53260009093","networkAddress":"60009093"},' +
        '{"ref":"344176","name":"Bin Sensor #4","EUI":"70B3D53260009098","networkAddress":"60009098"},' +
        '{"ref":"344221","name":"Bin Sensor #1","EUI":"70B3D53260009257","networkAddress":"60009257"},' +
        '{"ref":"405868","name":"Brighter Bins Test Unit LEU66","EUI":"0004A30B0023AC69","networkAddress":"2E92DCF0"},' +
        '{"ref":"405871","name":"Brighter Bins Test Unit LEU74","EUI":"0004A30B002402B4","networkAddress":"2F21DD81"},' +
        '{"ref":"417649","name":"Workshop2","EUI":"0495956030101011","networkAddress":"2E2A04AE"},' +
        '{"ref":"424903","name":"Pharox 166","EUI":"70B3D58627441AF0"},' +
        '{"ref":"424909","name":"Pharox 167","EUI":"70B3D5862598382D"},' +
        '{"ref":"600460","name":"Test Waste Sensor LEU68","EUI":"0004A30B0023FD08","networkAddress":"FC005F47"}';
    private final String deviceMockErrorResponse = '{...}';
    

    // Implement this interface method
    global HTTPResponse respond(final HTTPRequest request) {
        System.debug('ThingParkRestMock request received : ' + request);
        System.debug('ThingParkRestMock endpoint : ' + request.getEndpoint());
        System.assert(request.getEndpoint().contains(expectedEndpoint));

		if (isAuthorisationRequest(request.getEndpoint())) {
            System.debug('Processing request as authorise');
            return authorise(request);
        } else {
            final String authorization = request.getHeader('Authorization');
            System.assertEquals(expectedAuthorization, authorization, 
                                'Expected ' + expectedAuthorization + ' but was : ' + authorization);

            if (isSubscribersRequest(request.getEndpoint())) {
				System.debug('Process request as subscribers');
                return processSubscriberRequest(request);
            } else if (isOrderRequest(request.getEndpoint())) {
				System.debug('Process request as orders');
                return processOrderRequest(request);
            } else if (isOfferRequest(request.getEndpoint())) {
				System.debug('Process request as offers');
                return processOfferRequest(request);
            } else if (isDeviceRequest(request.getEndpoint())) {
				System.debug('Process request as devices');
                return processDeviceRequest(request);
            } else {
	        	return unsupportedRequest(request);
            }
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

    public Boolean isSubscribersRequest(String requestEndpoint) {
		// if request.getEndpoint includes /core/{version}/subscribers
		final String regEx = '\\/core\\/[\\w\\d\\/]+\\/subscribers';
		final Pattern subscriberUriPattern = Pattern.compile(regEx);
		final Matcher subscriberUriMatcher = subscriberUriPattern.matcher(requestEndpoint);
		final Boolean result =  subscriberUriMatcher.find();
        System.debug('isSubscribersRequest : ' + requestEndpoint  + ' is ' + result);
        return result;        
	}
    
    public HttpResponse processSubscriberRequest(final HTTPRequest request) {
        if (request.getMethod() == 'GET') {
            return provideGetSubscriberResponse(request);
        } else if (request.getMethod() == 'POST') {
            return provideCreateSubscriberResponse(request);
        } else if (request.getMethod() == 'PUT') {
            return provideUpdateSubscriberResponse(request);
        } else {
	        return unsupportedRequest(request);
        }
    }

	public HttpResponse provideGetSubscriberResponse(final HTTPRequest request) {    
		System.assertEquals('GET', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // {"primaryUser":{
        // "firstName":"Alice",
        // "lastName":"Automation",
        // "email":"alice.automation@connexin.co.uk",
        // "organization":"Connexin Company UK",
        // "password":"mock-password"}}';
        response.setBody(subscriberMockResponse);
        response.setStatusCode(200);
        return response;
    }
    
	public HttpResponse provideCreateSubscriberResponse(final HTTPRequest request) {    
		System.assertEquals('POST', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(subscriberMockResponse);
        response.setStatusCode(201);
        return response;
    }

    public HttpResponse provideUpdateSubscriberResponse(final HTTPRequest request) {    
		System.assertEquals('PUT', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(subscriberMockResponse);
        response.setStatusCode(200);
        return response;
    }

    public Boolean isOrderRequest(String requestEndpoint) {
		// if request.getEndpoint includes /core/{version}/orders
		final String regEx = '\\/core\\/[\\w\\d\\/]+\\/orders';
		final Pattern orderUriPattern = Pattern.compile(regEx);
		final Matcher orderUriMatcher = orderUriPattern.matcher(requestEndpoint);
		final Boolean result =  orderUriMatcher.find();
        System.debug('isOrderRequest : ' + requestEndpoint + ' is ' + result);
        return result;        
	}
    
	public HttpResponse processOrderRequest(final HTTPRequest request) {
        if (request.getMethod() == 'GET') {
            return provideGetOrderResponse(request);
        } else if (request.getMethod() == 'POST') {
            return provideCreateOrderResponse(request);
        } else if (request.getMethod() == 'PUT') {
            return provideUpdateOrderResponse(request);
        } else {
	        return unsupportedRequest(request);
        }
    }

	public HttpResponse provideGetOrderResponse(final HTTPRequest request) {
		System.assertEquals('GET', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(orderMockResponse);
        response.setStatusCode(200);
        return response;
    }
    
	public HttpResponse provideCreateOrderResponse(final HTTPRequest request) {    
		System.assertEquals('POST', request.getMethod());
        
        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(orderMockResponse);
        response.setStatusCode(201);
        return response;
    }

	public HttpResponse provideUpdateOrderResponse(final HTTPRequest request) {    
		System.assertEquals('PUT', request.getMethod());
        
        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(orderMockResponse);
        response.setStatusCode(200);
        return response;
    }
    
    public Boolean isOfferRequest(String requestEndpoint) {
		// if request.getEndpoint includes /core/{version}/offer
		final String regEx = '\\/core\\/[\\w\\d\\/]+\\/offer';
		final Pattern offerUriPattern = Pattern.compile(regEx);
		final Matcher offerUriMatcher = offerUriPattern.matcher(requestEndpoint);
		final Boolean result =  offerUriMatcher.find();
        System.debug('isOfferRequest : ' + requestEndpoint + ' is ' + result);
        return result;
        
	}

	public HttpResponse processOfferRequest(final HTTPRequest request) {
        if (request.getMethod() == 'GET') {
            return provideGetOfferResponse(request);
        } else if (request.getMethod() == 'POST') {
            return provideCreateOfferResponse(request);
        } else if (request.getMethod() == 'PUT') {
            return provideUpdateOfferResponse(request);
        } else {
	        return unsupportedRequest(request);
        }
    }

	public HttpResponse provideGetOfferResponse(final HTTPRequest request) {
		System.assertEquals('GET', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(offerMockResponse);
        response.setStatusCode(200);
        return response;
    }

	public HttpResponse provideCreateOfferResponse(final HTTPRequest request) {
		System.assertEquals('POST', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(offerMockResponse);
        response.setStatusCode(201);
        return response;
    }

	public HttpResponse provideUpdateOfferResponse(final HTTPRequest request) {
		System.assertEquals('PUT', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');

        response.setBody(offerMockResponse);
        response.setStatusCode(200);
        return response;
    }
    
    public Boolean isDeviceRequest(String requestEndpoint) {
        // if request.getEndpoint includes /core/{version}/devices
		final String regEx = '\\/core\\/[\\w\\d\\/]+\\/devices';
		final Pattern devicesUriPattern = Pattern.compile(regEx);
		final Matcher devicesUriMatcher = devicesUriPattern.matcher(requestEndpoint);
		final Boolean result = devicesUriMatcher.find();
        System.debug('isDeviceRequest : ' + requestEndpoint + ' is ' + result);
        return result;
        
	}

	public HttpResponse processDeviceRequest(final HTTPRequest request) {
        if (request.getMethod() == 'GET') {
            return provideGetDeviceResponse(request);
        } else if (request.getMethod() == 'POST') {
            return provideCreateDeviceResponse(request);
        } else if (request.getMethod() == 'PUT') {
            return provideUpdateDeviceResponse(request);
        } else {
	        return unsupportedRequest(request);
        }
    }
    
	public HttpResponse provideGetDeviceResponse(final HTTPRequest request) {            
		System.assertEquals('GET', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        response.setBody(deviceMockResponse);
        response.setStatusCode(200);
        return response;
    }

	public HttpResponse provideCreateDeviceResponse(final HTTPRequest request) {
		System.assertEquals('POST', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        response.setBody(deviceMockResponse);
		response.setStatusCode(201);
        return response;
    }

	public HttpResponse provideUpdateDeviceResponse(final HTTPRequest request) {
		System.assertEquals('PUT', request.getMethod());

        final HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        response.setBody(deviceMockResponse);
		response.setStatusCode(200);
        return response;
    }

	public HttpResponse unsupportedRequest(final HTTPRequest request) {
            System.debug('Unsupported Request in Mock : ' + request.getMethod() + ' ' + request.getEndpoint());
			final HttpResponse response = new HttpResponse();
        	String errorBody = '{ "ThingParkRestMock":"mock",'
                             + '"Error":"Unsupported Request in Mock",'
                             + '"Method":"' + request.getMethod() + '",'
                             + '"Method":"' + request.getEndpoint() + '" }';
            System.debug('errorBody : ' + errorBody);
            response.setBody(errorBody);
            response.setStatusCode(500);
	        return response;
    }

}