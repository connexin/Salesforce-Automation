public class ThingParkREST {

    private static final String VERSION = 'latest/api';
	private static final String ENDPOINT = 'https://dx-api.thingpark.com';

    public static String authorise() {
		ThingPark_REST__mdt config = new ThingPark_REST__mdt();
        System.debug('config : ' + config);
        // String clientId = config.Client_ID__c;
        // String clientSecret = config.Client_Secret__c;
        
    	// prepare authorisation uri for ThingPark
        String serviceUrl = ThingParkREST.makeUri('/admin/{version}/oauth/token');
        String grantType = 'grant_type=client_credentials';
        String clientId = 'client_id=connexin-api';
        String clientSecret = '373C2US9JU131Pw';

        String parameters = grantType + '&' + clientId + '&' + clientSecret;
        System.debug('parameters : ' + parameters );

        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        get_request.setEndpoint(endpoint);
        get_request.setMethod('POST');
		get_request.setBody(parameters);

        HttpResponse response = http.send(get_request);
        System.debug('response : ' + response);
        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);
        
        String accessToken = 'MOCK_ACCESS_TOKEN';

    	return accessToken;
    }
    
    
    public static Boolean addTenancy(final LoRaWAN_Tenancy__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

    	// prepare json
    	String json = makeRequestJsonForTenancy(item);
    	System.debug(json);

		HttpResponse response = ThingParkREST.makeDxPostRequest(serviceUrl, json);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
    }

    public static Boolean getTenancy(final LoRaWAN_Tenancy__c item) {
    	// prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

    	HttpResponse response = ThingParkREST.makeDxGetRequest(serviceUrl);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean updateTenancy(final LoRaWAN_Tenancy__c item) {
    	// prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

    	// prepare json
    	String json = makeRequestJsonForTenancy(item);
    	System.debug(json);

    	HttpResponse response = ThingParkREST.makeDxPutRequest(serviceUrl, json);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
	}

	private static String makeRequestJsonForTenancy(final LoRaWAN_Tenancy__c item) {
    	// Available fields:
        // 	Account__c
        // 	Actility_Subscriber_ID__c
        // 	Id
        //	Name
        // 	Total_Devices__c
        // 	Daily_Max_Average__c
        // 	Overage_Rate__c
		// final String json = JSON.serialize(item);
        final String json = '{"primaryUser": {"firstName": "Alice", "lastName": "Automation","email": "alice.automation@connexin.co.uk","organization": "Connexin Company UK","password": "DQ2sO83zXY"}}';
		System.debug(json);
		return json;
	}

    public static Boolean addOrder(final LoRaWAN_Package__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/devices/');

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response = ThingParkREST.makeDxPostRequest(serviceUrl, json);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean getOrder(final LoRaWAN_Package__c item) {

		final String accessToken = authorise();
        
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/devices/');

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response =  ThingParkREST.makeDxGetRequest(serviceUrl);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean updateOrder(final LoRaWAN_Package__c item) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/devices/');

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response =  ThingParkREST.makeDxPutRequest(serviceUrl, json);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

		return response.getStatusCode() == 200;
    }

    private static String makeUri(final string resourceUri) {
        return ENDPOINT + resourceUri.replace('{version}', VERSION);
    }
    
	private static String makeJsonForOrder(final LoRaWAN_Package__c item) {
		// Available fields:        	
		// 	Id,
		// 	Name,
		// 	Actility_Subscription_ID__c,
		// 	LoRaWAN_Tenancy__c,
		// 	Start_Date__c,
		// 	Term__c
		// 	End_Date__c,
		// 	Quantity_Of_Devices__c,            
		// 	Device_Rate__c,
		// 	Device_Rate_after_commitment_end__c,
		// 	Status__c,
		// 	is_Active__c,
		// 	is_Cancelled__c,
		// final String json = JSON.serialize(item);

        final String json = ' { "name":"New OTAA device", "EUI":"0018A20000000004", "activationType":"OTAA", "deviceProfileId":"ADRF/DemonstratorA.1_EU", "applicationEUI": "70B3D53260000003",  "applicationKey": "258DB54023EA74F0D55085F7351737D0"}';
		System.debug(json);        
		return json;
	}

    private static HttpResponse makeDxGetRequest(final String serviceUrl) {
		final String accessToken = authorise();

        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        get_request.setEndpoint(endpoint);
        get_request.setMethod('GET');

        HttpResponse response = http.send(get_request);

        System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

        return response;
    }
    
    private static HttpResponse makeDxPostRequest(final String serviceUrl, final String json) {
		final String accessToken = authorise();

        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('POST');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody(json);

		HttpResponse response = http.send(post_request);

		System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

        return response;
    }

    private static HttpResponse makeDxPutRequest(final String serviceUrl, final String json) {
		final String accessToken = authorise();
        
        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('PUT');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody('{"name":"foobar"}');

		HttpResponse response = http.send(post_request);

		System.assert(response.getStatusCode() == 200);

        Map<String, Object> responseData = dataFromResponse(response);
        System.debug(responseData);

        return response;
    }

    private static Map<String, Object> dataFromResponse(final HttpResponse response) {
        System.assert(response.getStatusCode() == 200);

        String body = response.getBody(); 
		System.debug(body);        

        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(body);
		System.debug(data);

		return data;
    }

}