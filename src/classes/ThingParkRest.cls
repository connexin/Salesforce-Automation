public class ThingParkREST {

    private static ThingParkConfig config = new ThingParkConfig();

    private static String authorise() {
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
    public static void addTenancy(final LoRaWAN_Tenancy__c tenancy) {
        // prepare json
        String newTenancyJson = makeSubscriberJsonForTenancy(tenancy);
        System.debug('newTenancyJson : ' + newTenancyJson);

		addTenancy(newTenancyJson);
    }
    
    @future private static void addTenancy(String newTenancyJson) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, newTenancyJson);
        System.debug('responseData : ' + responseData);

        // update LoRaWAN_Tenancy__c with Actility Subscriber Ref
    }

    public static void getTenancy(final LoRaWAN_Tenancy__c tenancy) {
    	String subscriberId = tenancy.Actility_Subscriber_ID__c;

    	getTenancy(subscriberId);
    }

    @future private static void getTenancy(String subscriberId) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl + subscriberId);
        System.debug('responseData : ' + responseData);
    }

    public static void updateTenancy(final LoRaWAN_Tenancy__c tenancy) {
        // prepare json
        String updateTenancyJson = makeSubscriberJsonForTenancy(tenancy);
        System.debug('updateTenancyJson : ' + updateTenancyJson);

		updateTenancy(updateTenancyJson);
    }

    @future private  static void updateTenancy(final String updateTenancyJson) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, updateTenancyJson);
        System.debug('responseData : ' + responseData);
    }

    // Available fields in LoRaWAN_Tenancy__c:
    // 	Account__c
    //  Actility_Subscriber_ID__c
    //  Id
    //  Name
    //  Total_Devices__c
    //  Daily_Max_Average__c
    //  Overage_Rate__c
    private static String makeSubscriberJsonForTenancy(final LoRaWAN_Tenancy__c tenancy) {
        System.debug('makeRequestJsonForTenancy : ' + tenancy);

        // Example json
        // 	'{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"primaryUser": {"firstName":"Alice", "lastName":"Tester","email":"alice.tester@connexin.co.uk", "organization":"Connexin Company UK", "password":"pa55w0rd"}}');
        // System.debug('jsonData = ' + jsonData);

        final String jsonForTenancy = JSON.serialize(tenancy);
        System.debug('jsonForTenancy : ' + jsonForTenancy);

        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonForTenancy);
        System.debug('jsonData = ' + jsonData);

        return jsonForTenancy;
    }

    public static void addOrder(final LoRaWAN_Package__c pckg) {
        // prepare json
        String newOrderJson = makeOrderJsonForPackage(pckg);
        System.debug(newOrderJson);

		addOrder(newOrderJson);
    }

    @future private static void addOrder(final String newOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkREST.makeDxPostRequest(serviceUrl, newOrderJson);
        System.debug('responseData : ' + responseData);
    }
    
    public static void getOrder(final LoRaWAN_Package__c pckg) {
        String orderRef = pckg.Actility_Subscription_ID__c;

		getOrder(orderRef);
    }

    @future private static void getOrder(final String orderRef) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkREST.makeDxGetRequest(serviceUrl + orderRef);
        System.debug('responseData : ' + responseData);
    }

    public static void updateOrder(final LoRaWAN_Package__c pckg) {
        // prepare json
        String updateOrderJson = makeOrderJsonForPackage(pckg);
        System.debug(updateOrderJson);
    }

    @future private static void updateOrder(final String updateOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkREST.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkREST.makeDxPutRequest(serviceUrl, updateOrderJson);
        System.debug('responseData : ' + responseData);
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
    private static String makeOrderJsonForPackage(final LoRaWAN_Package__c pckg) {
        System.debug('makeJsonFor : ' + pckg);

        // Example Json
        // '{ "id":"connexin-vdr/test-offer", "name":"Offer for testing",  "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}';
        // Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped('{"id":"connexin-vdr/test-offer", "name":"Offer for testing", "state":"TEST", "items": [{ "productId":"actility-sup/device-manager", "quantity":1 },{ "productId":"actility-sup/network-manager", "quantity":1 }]}');
        // System.debug('jsonData = ' + jsonData);

        final String jsonForOrder = JSON.serialize(pckg);
        System.debug('jsonForOrder : ' + jsonForOrder);

        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonForOrder);
        System.debug('jsonData = ' + jsonData);

        return jsonForOrder;
    }

    private static String makeUri(final string resourceUri) {
        return config.endpoint() + resourceUri.replace('{version}', config.version());
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