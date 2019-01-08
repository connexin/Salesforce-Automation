public class ThingParkRest {

    private static ThingParkRestConfig config = new ThingParkRestConfig();

    private static String authorise() {
        // prepare authorisation uri for ThingPark
        String serviceUrl = ThingParkRest.makeUri('/admin/{version}/oauth/token');
        System.debug('ThingParkRest authorise : ' + serviceUrl );

        String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', config.clientId())
            .add('client_secret', config.clientSecret())
            .asString();
        System.debug('ThingParkRest authorise parameters : ' + parameters );

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkRest fullUrl : ' + fullUrl);

        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        request.setBody(parameters);

        Map<String, Object> responseData = dataFromResponse(http.send(request));

        return (String) responseData.get('access_token');
    }

    // A Saleforce tenancy is a ThingPark Subscriber.
    public static void addTenancy(final LoRaWAN_Tenancy__c tenancy) {
        ThingParkSubscriberJson factory = new ThingParkSubscriberJson(config.subscriberJsonTemplate());

        // prepare json
        String newTenancyJson = factory.jsonFrom(tenancy);
        System.debug('newTenancyJson : ' + newTenancyJson);

        addTenancy(newTenancyJson);
    }
    
    @Future(callout=true)
    private static void addTenancy(String newTenancyJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newTenancyJson);
        System.debug('responseData : ' + responseData);

        // update LoRaWAN_Tenancy__c with Actility Subscriber Ref
    }

    public static void getTenancy(final LoRaWAN_Tenancy__c tenancy) {
        String subscriberId = tenancy.Actility_Subscriber_ID__c;

        getTenancy(subscriberId);
    }

    @Future(callout=true)
    private static void getTenancy(String subscriberId) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + subscriberId);
        System.debug('responseData : ' + responseData);
    }

    public static void updateTenancy(final LoRaWAN_Tenancy__c tenancy) {
         ThingParkSubscriberJson factory = new ThingParkSubscriberJson(config.subscriberJsonTemplate());

        // prepare json
        String updateTenancyJson = factory.jsonFrom(tenancy);
        System.debug('updateTenancyJson : ' + updateTenancyJson);

        updateTenancy(updateTenancyJson);
    }

    @Future(callout=true)
	private static void updateTenancy(final String updateTenancyJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateTenancyJson);
        System.debug('responseData : ' + responseData);
    }

    public static void addOrder(final LoRaWAN_Package__c pckage) {
         ThingParkOrderJson factory = new ThingParkOrderJson(config.orderJsonTemplate());

        // prepare json
        String newOrderJson = factory.jsonFrom(pckage);
        System.debug('newOrderJson : ' + newOrderJson);

        addOrder(newOrderJson);
    }

	@Future(callout=true)
    private static void addOrder(final String newOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newOrderJson);
        System.debug('responseData : ' + responseData);
    }
    
    public static void getOrder(final LoRaWAN_Package__c pckg) {
        String orderRef = pckg.Actility_Subscription_ID__c;

        getOrder(orderRef);
    }

	@Future(callout=true)
    private static void getOrder(final String orderRef) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + orderRef);
        System.debug('responseData : ' + responseData);
    }

    public static void updateOrder(final LoRaWAN_Package__c pckage) {
        ThingParkOrderJson factory = new ThingParkOrderJson(config.orderJsonTemplate());
        
        // prepare json
        String updateOrderJson = factory.jsonFrom(pckage);
        System.debug('updateOrderJson : ' + updateOrderJson);
        
        updateOrder(updateOrderJson);
    }

	@Future(callout=true)
    private static void updateOrder(final String updateOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');

        Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateOrderJson);
        System.debug('responseData : ' + responseData);
    }

    private static String makeUri(final string uriTemplate) {
    	final String resourceUri = uriTemplate.replace('{version}', config.version());
    	final String targetUri = config.endpoint() + resourceUri;
    	System.debug('targetUri : ' + targetUri);

        return targetUri;
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
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
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
        System.debug('response.getBody() : ' + response.getBody());
        return true;
    }
}