public class ThingParkRest {

    private static ThingParkRestConfig config = ThingParkRestConfig.selectCurrent();

    private static String authorise() {
        // prepare authorisation uri for ThingPark
        String serviceUrl = ThingParkRest.makeUri('/admin/{version}/oauth/token');
        String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', config.clientId())
            .add('client_secret', config.clientSecret())
            .asString();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkRest.authorise : ' + fullUrl);

        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        request.setBody(parameters);

        Map<String, Object> responseData = dataFromResponse(http.send(request));
        String accessToken = (String) responseData.get('access_token');
        System.assert(accessToken.length()>0);

        return accessToken;
    }
    
    @Future(callout=true)
    public static void addTenancy(String newTenancyJson) {
        System.debug('ThingParkRest.addTenancy : ' + newTenancyJson);

        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newTenancyJson);
        System.debug('ThingParkRest.addTenancy.responseData : ' + responseData);

        // update LoRaWAN_Tenancy__c with Actility Subscriber Ref
        updateTenancyFromActilityResponse(responseData);
    }
    
    @Future(callout=true)
    public static void getTenancy(String subscriberId) {
        System.debug('ThingParkRest.getTenancy : ' + subscriberId);
        
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');
        
        Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + subscriberId);
        System.debug('ThingParkRest.getTenancy.responseData : ' + responseData);
		System.debug(responseData.get('ref'));
        
        // must forward call, @future cannot return data.
    }
    
    @Future(callout=true)
    public static void updateTenancy(final String updateTenancyJson) {
        System.debug('ThingParkRest.updateTenancy : ' + updateTenancyJson);
        
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');
        
        Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateTenancyJson);
        System.debug('ThingParkRest.updateTenancy.responseData : ' + responseData);
		System.debug(responseData.get('ref'));
        
        // update LoRaWAN_Tenancy__c with Actility Subscriber Ref
        updateTenancyFromActilityResponse(responseData);
    }
    
    @Future(callout=true)
    public static void addOrder(final String newOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newOrderJson);
        System.debug('ThingParkRest.addOrder.responseData : ' + responseData);
		System.debug(responseData.get('ref'));
        
        updatePackageFromActilityResponse(responseData);
    }
    
    @Future(callout=true)
    public static void getOrder(final String orderRef) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + orderRef);
        System.debug('ThingParkRest.getOrder.responseData : ' + responseData);
		System.debug(responseData.get('ref'));
        
        // must forward call, @future cannot return data.
    }
    
    @Future(callout=true)
    public static void updateOrder(final String updateOrderJson) {
        // prepare service url
        String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateOrderJson);
        System.debug('ThingParkRest.updateOrder.responseData : ' + responseData);
		System.debug(responseData.get('ref'));
        
        updatePackageFromActilityResponse(responseData);
    }
    
    private static String makeUri(final string uriTemplate) {
        final String resourceUri = uriTemplate.replace('{version}', config.version());
        final String targetUri = config.endpoint() + resourceUri;
        return targetUri;
    }
    
    private static Map<String, Object> makeDxGetRequest(final String serviceUrl) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxGetRequest : ' + serviceUrl);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        
        System.debug('request : ' + request);
        
        HttpResponse response = http.send(request);

        System.assertEquals(200, response.getStatusCode(), 'Expected Status : 200 but was :' + response.getStatusCode() + '\n' + response.getBody());
        System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));
        
        return dataFromResponse(response);
    }
    
    private static Map<String, Object> makeDxPostRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxPostRequest : ' + serviceUrl);
        
        Http http = new Http();        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        System.debug('ThingParkRest.makeDxPostRequest : ' + json);
        request.setBody(json);
        
        HttpResponse response = http.send(request);
        System.debug('ThingParkRest.makeDxPostRequest.response : ' + response.getBody());

        System.assertEquals(201, response.getStatusCode(), 'Expected Status : 201 but was :' + response.getStatusCode());
        
        System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));
        
        return dataFromResponse(response);
    }

    private static Map<String, Object> makeDxPutRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxPutRequest : ' + serviceUrl);
        
        Http http = new Http();        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('PUT');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        System.debug('ThingParkRest.makeDxPutRequest : ' + json);
        request.setBody(json);
        
        HttpResponse response = http.send(request);
        System.debug('ThingParkRest.makeDxPutRequest.response : ' + response.getBody());
        
        System.assertEquals(200, response.getStatusCode(), 'Expected Status : 200 but was :' + response.getStatusCode());
        System.assertEquals('application/json;charset=UTF-8',
                            response.getHeader('Content-Type'),
                            'Unexpected Content-Type value :' + response.getHeader('Content-Type'));
        
        return dataFromResponse(response);
    }

    private static Map<String, Object> dataFromResponse(final HttpResponse response) {
        String body = response.getBody(); 
        System.debug('ThingParkRest.response.getBody() = ' + body);        
        
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(body);
        System.debug('ThingParkRest.jsonData = ' + jsonData);
        
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

    public static void updateTenancyFromActilityResponse(final Map<String, Object> responseData) {
        String actilitySubscriberRef = (String) responseData.get('ref');
        System.debug('ThingParkRest.updateTenancyFromActilityResponse.actilitySubscriberRef : ' + actilitySubscriberRef);

        String contactEmail = (String) responseData.get('contactEmail');
        System.debug('ThingParkRest.updateTenancyFromActilityResponse.contactEmail : ' + contactEmail);

        System.debug('SELECT count() FROM LoRaWAN_Package__c : ' + [SELECT count() FROM LoRaWAN_Package__c]);
        
        LoRaWAN_Tenancy__c tenancy = [SELECT Id, Actility_Subscriber_ID__c, Contact__r.email 
                                      FROM LoRaWAN_Tenancy__c 
                                      WHERE Actility_Subscriber_ID__c =: actilitySubscriberRef 
                                      LIMIT 1].get(0);
        System.debug('ThingParkRest.updateTenancyFromActilityResponse.tenancy : ' + tenancy);

		tenancy.Actility_Subscriber_ID__c = actilitySubscriberRef;
		tenancy.Push_to_Actility__c = false;

        update tenancy;
    }

    public static void updatePackageFromActilityResponse(final Map<String, Object> responseData) {
        String actilityPackageRef = (String) responseData.get('ref');
        System.debug('ThingParkRest.updatePackageFromActilityResponse.actilityPackageRef : ' + actilityPackageRef);

        System.debug('SELECT count() FROM LoRaWAN_Package__c : ' + [SELECT count() FROM LoRaWAN_Package__c]);
        
        LoRaWAN_Package__c pckge = [SELECT Id, Actility_Subscription_ID__c, Push_to_Actility__c 
                                    FROM LoRaWAN_Package__c 
                                    WHERE Actility_Order_Ref__c =: actilityPackageRef 
                                    LIMIT 1].get(0);
        System.debug('ThingParkRest.updatePackageFromActilityResponse.pckge : ' + pckge);
        
		pckge.Actility_Subscription_ID__c = actilityPackageRef;
		pckge.Push_to_Actility__c = false;

        update pckge;        
    }
}