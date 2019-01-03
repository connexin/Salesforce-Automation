global class ThingParkDxRestMock implements HttpCalloutMock {

    private String mockAccessToken = 'MOCK_ACCESS_TOKEN';
    private String expectedEndpoint = 'https://dx-api.thingpark.com';

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        System.debug('ThingParkDxRestMock received request : ' + request);
        System.debug('ThingParkDxRestMock endpoint : ' + request.getEndpoint());
        System.assert(request.getEndpoint().contains(expectedEndpoint));

        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');

        if (request.getEndpoint().contains('/oauth/token')) {
            System.assert(request.getMethod() == 'POST');

			PageReference pageRef = new PageReference(request.getEndpoint());
			System.debug('pageRef.getParameters() : ' + pageRef.getParameters());

			String grantType = pageRef.getParameters().get('grant_type');
            System.debug('grant_type : ' + grantType);
            System.assertEquals('client_credentials : ', grantType, 'Unexpected grantType : ' + grantType);
            
            String clientId = pageRef.getParameters().get('client_id');
            System.debug('client_id : ' + clientId);
            System.assertEquals('connexin-api/salesforce-actility', clientId, 'Unexpected clientId : ' + clientId);
            
            String clientSecret  = pageRef.getParameters().get('client_secret');
            System.debug('client_secret : ' + clientSecret);
            System.assert(request.getHeader('client_secret').isAlpha(), 'Unexpected clientSecret : ' + clientSecret);

            String jsonBody = '{"expires_in":99999,"client_id":"connexin-api/salesforce-actility-api@connexin.co.uk","token_type":"bearer","access_token":"' + mockAccessToken + '"}';
            response.setBody(jsonBody);
            response.setStatusCode(200);
        } else if (request.getEndpoint().endsWith('subscribers')) {
            System.debug('Authorization : ' + request.getHeader('Authorization'));
			System.assert(request.getHeader('Authorization') == mockAccessToken);
            if (request.getMethod() == 'GET') {
                String jsonBody = '{"id":"100029341","ref":"29341","name":"Alice Tester-20181231.141221","contactEmail":"Alice.Tester-20181231.141221@connexin.co.uk","organization":"Connexin UK Ltd"}';
                response.setBody(jsonBody);
                response.setStatusCode(200);
            } else if (request.getMethod() == 'POST') {
                System.debug('post new subscriber');
                response.setStatusCode(201);
            }
        } else if (request.getEndpoint().endsWith('orders')) {
            System.debug('Authorization : ' + request.getHeader('Authorization'));
			System.assert(request.getHeader('Authorization') == mockAccessToken);
            if (request.getMethod() == 'GET') {
                String jsonBody = '[{"id":"200021233","ref":"44914","offerId":"connexin-vdr/afb8b9d1-12da-46d0-b180-1e7578305df2","subscriberId":"100029374","state": "COMPLETED/CHARGING"}]';
                response.setStatusCode(200);
            } else if (request.getMethod() == 'POST') {
                System.debug('post new device');
                response.setStatusCode(201);
            }
        } else if (request.getEndpoint().endsWith('devices')) {
            System.debug('Authorization : ' + request.getHeader('Authorization'));
			System.assert(request.getHeader('Authorization') == mockAccessToken);
            if (request.getMethod() == 'GET') {
                String jsonBody = '{"ref":"333580","name":"0018B20000001BF0","EUI":"0018B20000001BF0","networkAddress":"2FDB487E"},{"ref":"336532","name":"Waste Sensor #1","EUI":"70B3D53260000ED0","networkAddress":"60000ED0"},{"ref":"336538","name":"Waste Sensor #2","EUI":"70B3D53260000FA4","networkAddress":"60000FA4"},{"ref":"344170","name":"Bin Sensor #2","EUI":"70B3D5326000908D","networkAddress":"6000908D"},{"ref":"344173","name":"Bin Sensor #3","EUI":"70B3D53260009093","networkAddress":"60009093"},{"ref":"344176","name":"Bin Sensor #4","EUI":"70B3D53260009098","networkAddress":"60009098"},{"ref":"344221","name":"Bin Sensor #1","EUI":"70B3D53260009257","networkAddress":"60009257"},{"ref":"405868","name":"Brighter Bins Test Unit LEU66","EUI":"0004A30B0023AC69","networkAddress":"2E92DCF0"},{"ref":"405871","name":"Brighter Bins Test Unit LEU74","EUI":"0004A30B002402B4","networkAddress":"2F21DD81"},{"ref":"417649","name":"Workshop2","EUI":"0495956030101011","networkAddress":"2E2A04AE"},{"ref":"424903","name":"Pharox 166","EUI":"70B3D58627441AF0"},{"ref":"424909","name":"Pharox 167","EUI":"70B3D5862598382D"},{"ref":"600460","name":"Test Waste Sensor LEU68","EUI":"0004A30B0023FD08","networkAddress":"FC005F47"}';
                response.setBody(jsonBody);
                response.setStatusCode(200);
            } else if (request.getMethod() == 'POST') {
                System.debug('post new device');
                response.setStatusCode(201);
            }
        } else {
            System.debug('Unknown endpoint : ' + request.getEndpoint());
            response.setBody('{"ThingPark":"mock","Error":"Unknown endpoint"}');
            response.setStatusCode(500);
        }
        
        // if get access token
        // if get subscribers
        // if get devices
        // if add subsciber
        // if add device
        
        return response;
    }
}