public class ThingParkREST {

	private static final String endpoint = 'https://dx-api.thingpark.com';
	private static final String accessToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZSI6WyJWRU5ET1I6NTI5Il0sImV4cCI6MTU0NTc0MTA2MiwianRpIjoiMjFhY2RhMjMtMTg1YS00MjgzLTk0MjMtNTYyZmVkYmFjMzU0IiwiY2xpZW50X2lkIjoiY29ubmV4aW4tYXBpL3NhbGVzZm9yY2UtYWN0aWxpdHktYXBpQGNvbm5leGluLmNvLnVrIn0.ioTcTbUnkhYYV7RxmWQy9qXNyXB85hSeoYhfKP3TFoFyw_ZSnJYA1ws4y1fUUYmRdS8MKSTsOW0P3oe1LCQRBg';

    public static String authorise() {
    	// makeDxGetRequest()
    	return 'ACCESS_TOKEN'
    }

    public static HttpResponse getTenancy(LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String service_url = ""

    	// prepare json
    	String json = "";

    	return ThingParkREST.makeDxGetRequest(service_url, json);
    }

    public static HttpResponse addTenancy(LoRaWAN_Tenancy__c item) {
    	// prepare service url
    	String service_url = ""

    	// prepare json
    	String json = "";

    	return ThingParkREST.makeDxPostRequest(service_url, json);
    }
    
    public static HttpResponse updateTenancy() {
    	// prepare service url
    	String service_url = ""

    	// prepare json
    	String json = "";

    	return ThingParkREST.makeDxPushRequest(service_url, json);
    }
        
    public static HttpResponse makeDxGetRequest() {
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
    
    public static HttpResponse makeDxPostRequest(final String json) {    	
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
    
    public static HttpResponse makeDxPutRequest() {    	
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
			System.debug('The status code returned was not expected: ' +
				post_response.getStatusCode() + ' ' + post_response.getStatus());
		} else {
			System.debug(post_response.getBody());
		}
        return post_response;
    }
    
    public static void logTenancy(LoRaWAN_Tenancy__c item) {
    	// Available fields:
        // 	Account__c
        // 	Actility_Subscriber_ID__c
        // 	Id
        //	Name
        // 	Total_Devices__c
        // 	Daily_Max_Average__c
        // 	Overage_Rate__c
        System.debug(
        	'Account__c : ' + item.Account__c + '\n'
        	'Actility_Subscriber_ID__c : ' + item.Actility_Subscriber_ID__c + '\n'
        	'Daily_Max_Average__c : ' + item.Daily_Max_Average__c + '\n'
        	'Id : ' + item.Id + '\n'
        	'Name : ' + item.Name + '\n'
        	'Overage_Rate__c : ' + item.Overage_Rate__c + '\n'
        	'Total_Devices__c : ' + item.Total_Devices__c);
    }
        
}
