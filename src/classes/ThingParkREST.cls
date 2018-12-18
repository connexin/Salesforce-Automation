public class ThingParkREST {

	private static final String endpoint = 'https://dx-api.thingpark.com';
	private static final String testAccessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJWRU5ET1I6NTI5Il0sImV4cCI6MTU0NTc0MTA2MiwianRpIjoiMjFhY2RhMjMtMTg1YS00MjgzLTk0MjMtNTYyZmVkYmFjMzU0IiwiY2xpZW50X2lkIjoiY29ubmV4aW4tYXBpL3NhbGVzZm9yY2UtYWN0aWxpdHktYXBpQGNvbm5leGluLmNvLnVrIn0.ioTcTbUnkhYYV7RxmWQy9qXNyXB85hSeoYhfKP3TFoFyw_ZSnJYA1ws4y1fUUYmRdS8MKSTsOW0P3oe1LCQRBg';

    public static String authorise() {
    	// makeDxGetRequest()
    	return 'ACCESS_TOKEN';
    }

    public static HttpResponse getTenancy(final String accessToken, final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

    	return ThingParkREST.makeDxGetRequest(serviceUrl, accessToken);
    }

    public static HttpResponse addTenancy(final String accessToken, final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

		return ThingParkREST.makeDxPostRequest(serviceUrl, accessToken, json);
    }
    
    public static HttpResponse updateTenancy(final String accessToken, final LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

    	return ThingParkREST.makeDxPutRequest(serviceUrl, accessToken, json);
	}

    public static HttpResponse getOrder(final String accessToken, final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

    	return ThingParkREST.makeDxGetRequest(serviceUrl, accessToken);
    }

    public static HttpResponse addOrder(final String accessToken, final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

    	return ThingParkREST.makeDxPostRequest(serviceUrl, accessToken, json);
    }
    
    public static HttpResponse updateOrder(final String accessToken, final LoRaWAN_Package__c item) {
    	// prepare service url
    	String serviceUrl = ThingParkREST.endpoint;

    	// prepare json
    	String json = makeJsonForItem(item);

    	return ThingParkREST.makeDxPutRequest(serviceUrl, accessToken, json);
    }
    

    public static HttpResponse makeDxGetRequest(final String serviceUrl, final String accessToken) {
        Http http = new Http();
        HttpRequest get_request = new HttpRequest();
        get_request.setEndpoint(endpoint);
        get_request.setMethod('GET');
        
        HttpResponse get_response = http.send(get_request);
        
        if (get_response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> json = (Map<String, Object>) JSON.deserializeUntyped(get_response.getBody());
			System.debug(json);

            // Cast the values in json as a list
            List<Object> items = (List<Object>) json.get('');
            System.debug('Received the following json:');
            for (Object item: items) {
                System.debug(item);
            }
        }
        return get_response;
    }
    
    public static HttpResponse makeDxPostRequest(final String serviceUrl, final String accessToken, final String json) {    	
        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('POST');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody(json);

		HttpResponse post_response = http.send(post_request);
		
		if (post_response.getStatusCode() != 201) {
			System.debug('The status code returned was not expected: ' +
				post_response.getStatusCode() + ' ' + post_response.getStatus());
		} else {
			System.debug(post_response.getBody());
		}
        return post_response;
    }
    
    public static HttpResponse makeDxPutRequest(final String serviceUrl, final String accessToken, final String json ) {    	
        Http http = new Http();        
		HttpRequest post_request = new HttpRequest();
		post_request.setEndpoint(endpoint);
		post_request.setMethod('PUT');
		post_request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		post_request.setHeader('Authorization', 'Bearer '+ accessToken);
		post_request.setBody('{"name":"foobar"}');

		HttpResponse post_response = http.send(post_request);

		// Parse the JSON response
		if (post_response.getStatusCode() != 201) {
			System.debug('The status code returned was not expected: ' + post_response.getStatusCode() + ' ' + post_response.getStatus());
		} else {
			System.debug(post_response.getBody());
		}
        return post_response;
    }

	public static String makeJsonForItem(final LoRaWAN_Tenancy__c item) {
    	// Available fields:
        // 	Account__c
        // 	Actility_Subscriber_ID__c
        // 	Id
        //	Name
        // 	Total_Devices__c
        // 	Daily_Max_Average__c
        // 	Overage_Rate__c
		return 'JSON[]';
	}

    public static void logTenancy(final LoRaWAN_Tenancy__c item) {
        System.debug(
        	'Account__c : ' + item.Account__c + '\n' +
        	'Actility_Subscriber_ID__c : ' + item.Actility_Subscriber_ID__c + '\n' +
        	'Daily_Max_Average__c : ' + item.Daily_Max_Average__c + '\n' +
        	'Id : ' + item.Id + '\n' +
        	'Name : ' + item.Name + '\n' +
        	'Overage_Rate__c : ' + item.Overage_Rate__c + '\n' +
        	'Total_Devices__c : ' + item.Total_Devices__c);
    }

	public static String makeJsonForItem(LoRaWAN_Package__c item) {
		// Available fields:        	
		// 	Actility_Subscription_ID__c,
		// 	LoRaWAN_Tenancy__c,
		// 	Id,
		// 	Name,
		// 	Start_Date__c,
		// 	Term__c
		// 	End_Date__c,
		// 	Quantity_Of_Devices__c,            
		// 	Device_Rate__c,
		// 	Device_Rate_after_commitment_end__c,
		// 	Status__c,
		// 	is_Active__c,
		// 	is_Cancelled__c,
		return 'JSON[]';
	}

    public static void logPackage(final LoRaWAN_Package__c item) {
        System.debug(
        	'Actility_Subscription_ID__c :' + item.Actility_Subscription_ID__c + '\n' +
        	'Device_Rate_after_commitment_end__c :' + item.Device_Rate_after_commitment_end__c+ '\n' +
            'Device_Rate__c :' + item.Device_Rate__c + '\n' +
            'End_Date__c :' + item.End_Date__c+ '\n' +
            'Id :' + item.Id + '\n' +
            'is_Active__c :' + item.is_Active__c+ '\n' +
            'is_Cancelled__c :' + item.is_Cancelled__c+ '\n' +
            'LoRaWAN_Tenancy__c :' + item.LoRaWAN_Tenancy__c+ '\n' +
            'Name :' + item.Name + '\n' +
            'Quantity_Of_Devices__c :' + item.Quantity_Of_Devices__c+ '\n' +
            'Start_Date__c :' + item.Start_Date__c+ '\n' +
            'Status__c : ' + item.Status__c+ '\n' +
            'Term__c :' + item.Term__c);
    }
        
}