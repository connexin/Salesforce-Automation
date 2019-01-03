public class ThingParkREST {

    private static ThingParkConfig config = new ThingParkConfig();

    public static String authorise() {
        // prepare authorisation uri for ThingPark
        String serviceUrl = ThingParkREST.makeUri('/admin/{version}/oauth/token');
        System.debug('ThingParkREST authorise : ' + serviceUrl );

		String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', config.clientId())
            .add('client_secret', config.clientSecret())
            .asString();
        System.debug('ThingParkREST authorise parameters : ' + parameters );

        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkREST fullUrl : ' + fullUrl);

        get_request.setEndpoint(fullUrl);
        get_request.setMethod('POST');
        get_request.setBody(parameters);

        Map<String, Object> responseData = dataFromResponse(http.send(get_request));

        return (String) responseData.get('access_token');
    }

    public static Boolean addTenancy(final LoRaWAN_Tenancy__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        // prepare json
        String json = makeRequestJsonForTenancy(item);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, json);

        return true;
    }

    public static Boolean getTenancy(final LoRaWAN_Tenancy__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl);

        return true;
    }
    
    public static Boolean updateTenancy(final LoRaWAN_Tenancy__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        // prepare json
        String json = makeRequestJsonForTenancy(item);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, json);

        return true;
    }

    private static String makeRequestJsonForTenancy(final LoRaWAN_Tenancy__c item) {
        // Available fields:
        //  Account__c
        //  Actility_Subscriber_ID__c
        //  Id
        //  Name
        //  Total_Devices__c
        //  Daily_Max_Average__c
        //  Overage_Rate__c
        // final String json = JSON.serialize(item);
        final String json = '{"primaryUser": {"firstName": "Alice", "lastName": "Automation","email": "alice.automation@connexin.co.uk","organization": "Connexin Company UK","password": "DQ2sO83zXY"}}';
        System.debug(json);
        return json;
    }

    public static Boolean addOrder(final LoRaWAN_Package__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        // prepare json
        String json = makeJsonForOrder(item);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, json);

        return true;
    }
    
    public static Boolean getOrder(final LoRaWAN_Package__c item) {

        final String accessToken = authorise();
        
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        // prepare json
        String json = makeJsonForOrder(item);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl);

        return true;
    }
    
    public static Boolean updateOrder(final LoRaWAN_Package__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        // prepare json
        String json = makeJsonForOrder(item);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, json);

        return true;
    }

    private static String makeUri(final string resourceUri) {
        return config.endpoint() + resourceUri.replace('{version}', config.version());
    }
    
    private static String makeJsonForOrder(final LoRaWAN_Package__c item) {
        // Available fields:            
        //  Id,
        //  Name,
        //  Actility_Subscription_ID__c,
        //  LoRaWAN_Tenancy__c,
        //  Start_Date__c,
        //  Term__c
        //  End_Date__c,
        //  Quantity_Of_Devices__c,            
        //  Device_Rate__c,
        //  Device_Rate_after_commitment_end__c,
        //  Status__c,
        //  is_Active__c,
        //  is_Cancelled__c,
        // final String json = JSON.serialize(item);

        final String json = ' { "name":"New OTAA device", "EUI":"0018A20000000004", "activationType":"OTAA", "deviceProfileId":"ADRF/DemonstratorA.1_EU", "applicationEUI": "70B3D53260000003",  "applicationKey": "258DB54023EA74F0D55085F7351737D0"}';
        System.debug(json);        
        return json;
    }

    private static Map<String, Object> makeDxGetRequest(final String serviceUrl) {
        final String accessToken = authorise();

        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        get_request.setEndpoint(serviceUrl);
        get_request.setMethod('GET');
        get_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        get_request.setHeader('Authorization', 'Bearer '+ accessToken);

        HttpResponse response = http.send(get_request);

        System.assertEquals(200, response.getStatusCode());
		System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));

        return dataFromResponse(response);
    }
    
    private static Map<String, Object> makeDxPostRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();

        Http http = new Http();        
        HttpRequest post_request = new HttpRequest();
        post_request.setEndpoint(serviceUrl);
        post_request.setMethod('POST');
        post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        post_request.setHeader('Authorization', 'Bearer '+ accessToken);
        post_request.setBody(json);

        HttpResponse response = http.send(post_request);

        System.assertEquals(201, response.getStatusCode());
		System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));

        return dataFromResponse(response);
    }

    private static Map<String, Object> makeDxPutRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        
        Http http = new Http();        
        HttpRequest post_request = new HttpRequest();
        post_request.setEndpoint(serviceUrl);
        post_request.setMethod('PUT');
        post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        post_request.setHeader('Authorization', 'Bearer '+ accessToken);
        post_request.setBody(json);

        HttpResponse response = http.send(post_request);

        System.assertEquals(200, response.getStatusCode());
		System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));

        return dataFromResponse(response);
    }

    private static Map<String, Object> dataFromResponse(final HttpResponse response) {
        String body = response.getBody(); 
        System.debug('response.getBody() = ' + body);        

        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(body);
        System.debug('jsonData = ' + jsonData);

        return jsonData;
    }

    public static Boolean thingParkWithCallout(final LoRaWAN_Tenancy__c item) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:thingpark/some_path');
		request.setMethod('GET');
		Http http = new Http();
		HTTPResponse response = http.send(request);
		System.debug(response.getBody());
        return true;
    }
    
}