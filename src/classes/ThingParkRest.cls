public class ThingParkRest {
    public class AccessNotAuthorisedException extends Exception {}
    private static ThingParkRestConfig config = ThingParkRestConfig.selectCurrent();

    private static String authorise() {
        // prepare authorisation uri for ThingPark
        String serviceUrl = makeUri('/admin/{version}/oauth/token');
        String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', config.clientId())
            .add('client_secret', config.clientSecret())
            .asString();

        HttpRequest request = new HttpRequest();
        final String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkRest.authorise : ' + fullUrl);

        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        Http http = new Http();
        final HttpResponse response = http.send(request);
        System.assertEquals(200, response.getStatusCode(), 'Expected Status : 200 but was :' + response.getStatusCode());

        Map<String, Object> responseData = dataFrom(Response);
        final String accessToken = (String) responseData.get('access_token');
        System.debug('access_token : ' + accessToken);
        if (String.isNotBlank(accessToken)) {
            System.assert(accessToken.length()>0, 'No access_token found in the response');
            System.assert(accessToken.isAlpha(), 'access_token is not unicode string');
        	return accessToken;
        } else {
            throw new AccessNotAuthorisedException(response.getBody());
        }
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
        
        return dataFrom(response);
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
        
        return dataFrom(response);
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
        
        return dataFrom(response);
    }

    private static Map<String, Object> dataFrom(final HttpResponse response) {
        String body = response.getBody(); 
        System.debug('ThingParkRest.response.getBody() = ' + body);        
        
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(body);
        System.debug('ThingParkRest.jsonData = ' + jsonData);
        
        return jsonData;
    }

    public static void updateTenancyFromActilityResponse(final Map<String, Object> responseData) {
        String actilitySubscriberRef = (String) responseData.get('ref');
        System.debug('ThingParkRest.updateTenancyFromActilityResponse.actilitySubscriberRef : ' + actilitySubscriberRef);

        String contactEmail = (String) responseData.get('contactEmail');
        System.debug('ThingParkRest.updateTenancyFromActilityResponse.contactEmail : ' + contactEmail);

        System.debug('SELECT count() FROM LoRaWAN_Package__c : ' + [SELECT count() FROM LoRaWAN_Package__c]);
        
        List<LoRaWAN_Tenancy__c> tenancies = [SELECT Id, Actility_Subscriber_ID__c, Contact__r.email 
                                              FROM LoRaWAN_Tenancy__c 
                                              WHERE Actility_Subscriber_ID__c =: actilitySubscriberRef 
                                              LIMIT 1];

        if (tenancies.size() == 0) {
            System.debug('LoRaWAN_Packages not found for : ' + actilitySubscriberRef);
        } else if (tenancies.size() == 1) {
            System.debug('ThingParkRest.updateTenancyFromActilityResponse.tenancy : ' + tenancies);
            
            tenancies.get(0).Actility_Subscriber_ID__c = actilitySubscriberRef;
            tenancies.get(0).Push_to_Actility__c = false;
            
            update tenancies;
        } else { // if (tenancies.size() > 1)
            System.debug('Too many LoRaWAN_Packages found for : ' + actilitySubscriberRef);
        }        
    }

    public static void updatePackageFromActilityResponse(final Map<String, Object> responseData) {
        String actilityPackageRef = (String) responseData.get('ref');
        System.debug('ThingParkRest.updatePackageFromActilityResponse.actilityPackageRef : ' + actilityPackageRef);

        System.debug('SELECT count() FROM LoRaWAN_Package__c : ' + [SELECT count() FROM LoRaWAN_Package__c]);

        List<LoRaWAN_Package__c> packages = [SELECT Id, Actility_Subscription_ID__c, Push_to_Actility__c 
                                             FROM LoRaWAN_Package__c 
                                             WHERE Actility_Order_Ref__c =: actilityPackageRef 
                                             LIMIT 1];

        if (packages.size() == 0) {
            System.debug('LoRaWAN_Packages not found for : ' + actilityPackageRef);
        } else if (packages.size() == 1) {
            System.debug('ThingParkRest.updatePackageFromActilityResponse.pckge : ' + packages.get(0));
            
            packages.get(0).Actility_Subscription_ID__c = actilityPackageRef;
            packages.get(0).Push_to_Actility__c = false;
    
            update packages;
        } else { // if (packages.size() > 1)
            System.debug('Too many LoRaWAN_Packages found for : ' + actilityPackageRef);
        }
    }

    private static String makeUri(final string uriTemplate) {
        // @todo use callout?
        // request.setEndpoint('callout:thingpark/some_path');
        final String resourceUri = uriTemplate.replace('{version}', config.version());
        final String targetUri = config.endpoint() + resourceUri;
        return targetUri;
    }

}