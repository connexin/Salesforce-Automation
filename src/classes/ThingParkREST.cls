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
        HttpRequest request = new HttpRequest();
        String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkREST fullUrl : ' + fullUrl);

        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        request.setBody(parameters);

        Map<String, Object> responseData = dataFromResponse(http.send(request));

        return (String) responseData.get('access_token');
    }

    // A Saleforce tenancy is a ThingPark Subscriber.
    public static Boolean addTenancy(final LoRaWAN_Tenancy__c tenancy) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        // prepare json
        String newTenancyJson = makeRequestJsonForTenancy(tenancy);
        System.debug(newTenancyJson);

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, newTenancyJson);

        // update LoRaWAN_Tenancy__c with Actility Subscriber Ref

        return true;
    }

    public static Boolean getTenancy(final LoRaWAN_Tenancy__c tenancy) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

		// serviceUrl + tenancy.Actility_Subscriber_ID__c
        
        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl);
        System.debug('responseData : ' + responseData);

        return true;
    }

    public static Boolean updateTenancy(final LoRaWAN_Tenancy__c tenancy) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        // prepare json
        String newTenancyJson = makeRequestJsonForTenancy(tenancy);
        System.debug(newTenancyJson);

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, newTenancyJson);

        return true;
    }

    // Available fields in LoRaWAN_Tenancy__c:
    // 	Account__c
    //  Actility_Subscriber_ID__c
    //  Id
    //  Name
    //  Total_Devices__c
    //  Daily_Max_Average__c
    //  Overage_Rate__c
    private static String makeRequestJsonForTenancy(final LoRaWAN_Tenancy__c item) {
        System.debug('makeRequestJsonForTenancy : ' + item);

        // Example json
        // 	'{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);

        final String jsonForTenancy = JSON.serialize(item);
        System.debug('jsonForTenancy : ' + jsonForTenancy);

        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonForTenancy);
        System.debug('jsonData = ' + jsonData);

        return jsonForTenancy;
    }

    public static Boolean addOrder(final LoRaWAN_Package__c order) {
        // String orderRef = order...;

        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        // prepare json
        String orderJson = makeJsonFor(order);
        System.debug(orderJson);

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, orderJson);
        System.debug('responseData : ' + responseData);

        return true;
    }
    
    public static Boolean getOrder(final LoRaWAN_Package__c order) {
        // String orderRef = order.Actility_Subscriber_ID__c;

        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl);
        System.debug('responseData : ' + responseData);

        return true;
    }
    
    public static Boolean updateOrder(final LoRaWAN_Package__c order) {
		// String orderRef = order.Actility_Subscriber_ID__c;

        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        // prepare json
        String json = makeJsonFor(order);
        System.debug(json);

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, json);
        System.debug('responseData : ' + responseData);

        return true;
    }

    private static String makeUri(final string resourceUri) {
        return config.endpoint() + resourceUri.replace('{version}', config.version());
    }

    // Available fields in LoRaWAN_Package__c:
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
    private static String makeJsonFor(final LoRaWAN_Package__c order) {
        System.debug('makeJsonFor : ' + order);

        // Example Json
        // '{ "id":"connexin-vdr/test-offer", "name":"Offer for testing",  "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"id":"connexin-vdr/test-offer", "name":"Offer for testing", "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}');
        // System.debug('jsonData = ' + jsonData);

        final String jsonForOrder = JSON.serialize(order);
        System.debug('jsonForOrder : ' + jsonForOrder);

        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonForOrder);
        System.debug('jsonData = ' + jsonData);

        return jsonForOrder;
    }

    private static Map<String, Object> makeDxGetRequest(final String serviceUrl) {
        final String accessToken = authorise();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);

        HttpResponse response = http.send(request);

        System.assertEquals(200, response.getStatusCode());
		System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));

        return dataFromResponse(response);
    }
    
    private static Map<String, Object> makeDxPostRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();

        Http http = new Http();        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setBody(json);

        HttpResponse response = http.send(request);

        System.assertEquals(201, response.getStatusCode());
		System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));

        return dataFromResponse(response);
    }

    private static Map<String, Object> makeDxPutRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        
        Http http = new Http();        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setBody(json);

        HttpResponse response = http.send(request);

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

    public static Boolean thingParkWithCallout() {
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:thingpark/some_path');
		request.setMethod('GET');
		Http http = new Http();
		HTTPResponse response = http.send(request);
		System.debug(response.getBody());
        return true;
    }
    
}