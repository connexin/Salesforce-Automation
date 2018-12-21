public class ThingParkREST {

	private static final String endpoint = 'https://dx-api.thingpark.com';
	private static final String testAccessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJWRU5ET1I6NTI5Il0sImV4cCI6MTU0NTc0MTA2MiwianRpIjoiMjFhY2RhMjMtMTg1YS00MjgzLTk0MjMtNTYyZmVkYmFjMzU0IiwiY2xpZW50X2lkIjoiY29ubmV4aW4tYXBpL3NhbGVzZm9yY2UtYWN0aWxpdHktYXBpQGNvbm5leGluLmNvLnVrIn0.ioTcTbUnkhYYV7RxmWQy9qXNyXB85hSeoYhfKP3TFoFyw_ZSnJYA1ws4y1fUUYmRdS8MKSTsOW0P3oe1LCQRBg';

    private static String authorise() {
    	// makeDxGetRequest()
    	return 'ACCESS_TOKEN';
    }

    public static Boolean addTenancy(final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForTenancy(item);
    	System.debug(json);

		HttpResponse response = ThingParkREST.makeDxPostRequest(authorise(), serviceUrl, json);

		responseJson = jsonFromResponse(response);

		return response.getStatusCode() == 200;
    }

    public static Boolean getTenancy(final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForTenancy(item);
    	System.debug(json);

    	HttpResponse response = ThingParkREST.makeDxGetRequest(authorise(), serviceUrl);

		jsonFromResponse(response);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean updateTenancy(final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForTenancy(item);
    	System.debug(json);

    	HttpResponse response = ThingParkREST.makeDxPutRequest(authorise(), serviceUrl, json);

		jsonFromResponse(response);

		return response.getStatusCode() == 200;
	}

    public static Boolean addOrder(final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response = ThingParkREST.makeDxPostRequest(authorise(), serviceUrl, json);

		jsonFromResponse(response);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean getOrder(final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response =  ThingParkREST.makeDxGetRequest(authorise(), serviceUrl);

		jsonFromResponse(response);

		return response.getStatusCode() == 200;
    }
    
    public static Boolean updateOrder(final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForOrder(item);
    	System.debug(json);

    	HttpResponse response =  ThingParkREST.makeDxPutRequest(authorise(), serviceUrl, json);

		jsonFromResponse(response);

		return response.getStatusCode() == 200;
    }

    private static HttpResponse makeDxGetRequest(final String accessToken, final String serviceUrl) {
        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        get_request.setEndpoint(endpoint);
        get_request.setMethod('GET');

        HttpResponse response = http.send(get_request);

        System.assert(response.getStatusCode() == 200);

		jsonFromResponse(response);

        return response;
    }
    
    private static HttpResponse makeDxPostRequest(final String accessToken, final String serviceUrl, final String json) {
        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('POST');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody(json);

		HttpResponse response = http.send(post_request);

		jsonFromResponse(response);

        System.assert(response.getStatusCode() == 200);

        return response;
    }
    
    private static HttpResponse makeDxPutRequest(final String accessToken, final String serviceUrl, final String json) {
        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('PUT');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody('{"name":"foobar"}');

		HttpResponse response = http.send(post_request);

		jsonFromResponse(response);

        System.assert(response.getStatusCode() == 200);

        return response;
    }

    private static Map<String, Object> jsonFromResponse(final HttpResponse response) {
        System.assert(response.getStatusCode() == 200);
        
        String body = response.getBody(); 
		System.debug(body);        

        Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(body);
		System.debug(json);

        List<String> records = (List<String>)JSON.deserialize(json, List<Account>.class);
		System.debug(records);
        
		return json;
    }

	private static String makeJsonForTenancy(final LoRaWAN_Tenancy__c item) {
    	// Available fields:
        // 	Account__c
        // 	Actility_Subscriber_ID__c
        // 	Id
        //	Name
        // 	Total_Devices__c
        // 	Daily_Max_Average__c
        // 	Overage_Rate__c

		final String json = JSON.serialize(item);
		System.debug(json);        
		return json;
	}

    private static void logTenancy(final LoRaWAN_Tenancy__c item) {
        System.debug(
        	'Id : ' 						+ item.Id + '\n' +
        	'Name : ' 						+ item.Name + '\n' +
        	'Account__c : ' 				+ item.Account__c + '\n' +
        	'Actility_Subscriber_ID__c : '	+ item.Actility_Subscriber_ID__c + '\n' +
        	'Daily_Max_Average__c : '		+ item.Daily_Max_Average__c + '\n' +
        	'Total_Devices__c : ' 			+ item.Total_Devices__c + '\n' +
        	'Overage_Rate__c : ' 			+ item.Overage_Rate__c);
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
		final String json = JSON.serialize(item);
		System.debug(json);        
		return json;
	}

    private static void logPackage(final LoRaWAN_Package__c item) {
        System.debug(
            'Id :' 									+ item.Id + '\n' +
            'Name :' 								+ item.Name + '\n' +
        	'Actility_Subscription_ID__c :'			+ item.Actility_Subscription_ID__c + '\n' +
            'LoRaWAN_Tenancy__c :' 					+ item.LoRaWAN_Tenancy__c+ '\n' +
            'Start_Date__c :' 						+ item.Start_Date__c+ '\n' +
            'Term__c :' 							+ item.Term__c+ '\n' +
            'End_Date__c :' 						+ item.End_Date__c+ '\n' +
            'Quantity_Of_Devices__c :' 				+ item.Quantity_Of_Devices__c+ '\n' +
            'Device_Rate__c :' 						+ item.Device_Rate__c + '\n' +
        	'Device_Rate_after_commitment_end__c :' + item.Device_Rate_after_commitment_end__c+ '\n' +
            'Status__c : ' 							+ item.Status__c+ '\n' +
            'is_Active__c :' 						+ item.is_Active__c+ '\n' +
            'is_Cancelled__c :' 					+ item.is_Cancelled__c);
    }
        
}