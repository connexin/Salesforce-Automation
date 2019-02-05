public class ThingParkRest {
    public class AccessNotAuthorisedException extends Exception {}
    private static ThingParkRestConfig config = ThingParkRestConfig.selectCurrent();

    private static String authorise() {
        // prepare authorisation uri for ThingPark
        final String serviceUrl = makeUri('/admin/{version}/oauth/token');
        final String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', config.clientId())
            .add('client_secret', config.clientSecret())
            .asString();

        final HttpRequest request = new HttpRequest();
        final String fullUrl = serviceUrl+parameters;
        System.debug('ThingParkRest.authorise : ' + fullUrl);

        request.setEndpoint(fullUrl);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        final Http http = new Http();
        final HttpResponse response = http.send(request);
        System.assertEquals(200, response.getStatusCode(), 'Expected Status : 200 but was :' + response.getStatusCode());

        final Map<String, Object> responseData = dataFrom(Response);
        final String accessToken = (String) responseData.get('access_token');
        System.debug('access_token : ' + accessToken);
        if (String.isNotBlank(accessToken)) {
            System.assert(accessToken.length()>0, 'No access_token found in the response');
        	return accessToken;
        } else {
            throw new AccessNotAuthorisedException(response.getBody());
        }
    }
    
    @Future(callout=true)
    public static void addSubscriber(final String tenancyId, final String newTenancyJson) {
        System.debug('ThingParkRest.addSubscriber : ' + newTenancyJson);

        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        final Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newTenancyJson);

        // update LoRaWAN_Tenancy__c from Actility Subscriber 
        updateTenancyFromActilityResponse(tenancyId, responseData);
    }
    
    @Future(callout=true)
    public static void getSubscriber(final String tenancyId, final String subscriberId) {
        System.debug('ThingParkRest.getSubscriber : ' + subscriberId);
        
        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');
        
        final Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + subscriberId);
        
        updateTenancyFromActilityResponse(tenancyId, responseData);
    }
    
    @Future(callout=true)
    public static void updateSubscriber(final String tenancyId, final String updateTenancyJson) {
        System.debug('ThingParkRest.updateSubscriber : ' + updateTenancyJson);

        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/subscribers/');

        final Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateTenancyJson);

        updateTenancyFromActilityResponse(tenancyId, responseData);
    }
    
    @Future(callout=true)
    public static void addOrder(final String packageId, final String newOrderJson) {
        System.debug('ThingParkRest.addOrder : ' + newOrderJson);

        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        final Map<String, Object> responseData = ThingParkRest.makeDxPostRequest(serviceUrl, newOrderJson);
        
        updatePackageFromActilityResponse(packageId, responseData);
    }
    
    @Future(callout=true)
    public static void getOrder(final String packageId, final String orderRef) {
        System.debug('ThingParkRest.getOrder : ' + orderRef);
        
        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        final Map<String, Object> responseData = ThingParkRest.makeDxGetRequest(serviceUrl + orderRef);
        
        updatePackageFromActilityResponse(packageId, responseData);
    }
    
    @Future(callout=true)
    public static void updateOrder(final String packageId, final String updateOrderJson) {
        System.debug('ThingParkRest.updateOrder : ' + updateOrderJson);

        final String serviceUrl = ThingParkRest.makeUri('/core/{version}/orders/');
        
        final Map<String, Object> responseData = ThingParkRest.makeDxPutRequest(serviceUrl, updateOrderJson);
		System.debug(responseData.get('ref'));
        
        updatePackageFromActilityResponse(packageId, responseData);
    }

    private static String makeUri(final string uriTemplate) {
        // @todo use callout?
        // request.setEndpoint('callout:thingpark/some_path');
        final String resourceUri = uriTemplate.replace('{version}', config.version());
        final String targetUri = config.endpoint() + resourceUri;
        return targetUri;
    }    

    private static Map<String, Object> makeDxGetRequest(final String serviceUrl) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxGetRequest : ' + serviceUrl);
        
        final Http http = new Http();
        final HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);        

        final HttpResponse response = http.send(request);

        System.assertEquals(200, response.getStatusCode(), 'Expected Status : 200 but was :' + response.getStatusCode() + '\n' + response.getBody());

        System.assert(response.getHeader('Content-Type').equalsIgnoreCase('application/json;charset=utf-8'),
                      'Unexpected Content-Type value :' + response.getHeader('Content-Type'));
        
        return dataFrom(response);
    }
    
    private static Map<String, Object> makeDxPostRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxPostRequest : ' + serviceUrl);
        
        final Http http = new Http();        
        final HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        System.debug('makeDxPostRequest.request : ' + request);

        request.setBody(json);
        
        final HttpResponse response = http.send(request);
        System.debug('makeDxPostRequest.response : ' + response);

        System.assertEquals(201, response.getStatusCode(),
                            'Expected Status : 201 but was :' +
                            response.getStatusCode() + '\n' +
                            response.getBody());

        System.assert(response.getHeader('Content-Type').equalsIgnoreCase('application/json;charset=utf-8'),
                      'Unexpected Content-Type value : ' + response.getHeader('Content-Type'));
        
        return dataFrom(response);
    }

    private static Map<String, Object> makeDxPutRequest(final String serviceUrl, final String json) {
        final String accessToken = authorise();
        System.debug('ThingParkRest.makeDxPutRequest : ' + serviceUrl);
        
        final Http http = new Http();        
        final HttpRequest request = new HttpRequest();
        request.setEndpoint(serviceUrl);
        request.setMethod('PUT');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        System.debug('makeDxPutRequest.request : ' + request);

        request.setBody(json);
        
        final HttpResponse response = http.send(request);
        System.debug('makeDxPostRequest.response : ' + response);
        
        System.assertEquals(200, response.getStatusCode(),
                            'Expected Status : 200 but was :' +
                            response.getStatusCode() + '\n' +
                            response.getBody());
        System.assert(response.getHeader('Content-Type').equalsIgnoreCase('application/json;charset=utf-8'),
                      'Unexpected Content-Type value : ' + response.getHeader('Content-Type'));
        
        return dataFrom(response);
    }

    private static Map<String, Object> dataFrom(final HttpResponse response) {
        System.debug('ThingParkRest.dataFrom : ' + response);
        final String body = response.getBody();
        final Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(body);
        System.debug('response : ' + response);
        logPrettyData(jsonData);
        return jsonData;
    }

    private static void logPrettyData(final Map<String, Object> jsonData) {
        System.debug('ThingParkRest.logPrettyData : ' + jsonData);
        for (String key : jsonData.keySet()) {
        	System.debug('___' + key + ' = ' + jsonData.get(key));
        }
    }
    
    public static void updateTenancyFromActilityResponse(final String tenancyId, final Map<String, Object> responseData) {
        System.debug('updateTenancyFromActilityResponse : ' + responseData);
        
        final String actilitySubscriberId = (String) responseData.get('id');
        System.assert(actilitySubscriberId != null, 'SubscriberId not found in response');
        System.debug('actilitySubscriberId : ' + actilitySubscriberId);

        final List<LoRaWAN_Tenancy__c> tenancies = [SELECT Id, Actility_Subscriber_ID__c, Contact__r.email, Push_to_Actility__c  
                                                    FROM LoRaWAN_Tenancy__c 
                                                    WHERE id =: tenancyId 
                                                    LIMIT 1];
        System.debug('updateTenancyFromActilityResponse.tenancies : ' + tenancies );

        if (tenancies.size() == 0) {
            System.debug('LoRaWAN_Packages not found for : ' + actilitySubscriberId);
        } else if (tenancies.size() == 1) {            
            final LoRaWAN_Tenancy__c tenancy = tenancies.get(0);
            System.debug('ThingParkRest.updateTenancyFromActilityResponse.tenancy : ' + tenancy);

            tenancy.Actility_Subscriber_ID__c = actilitySubscriberId;
            tenancy.Push_to_Actility__c = false;
            
            update tenancy;
        } else { // if (tenancies.size() > 1)
            System.debug('Too many LoRaWAN_Packages found for : ' + actilitySubscriberId);
        }        
    }

    public static void updatePackageFromActilityResponse(final String packageId, final Map<String, Object> responseData) {
        System.debug('updatePackageFromActilityResponse : ' + responseData);
        
        final String actilityOrderId = (String) responseData.get('id');
        System.assert(actilityOrderId != null, 'actilityOrderId not found in response');
        System.debug('actilityOrderId : ' + actilityOrderId);

        //Actility_Order_ID__c,
        List<LoRaWAN_Package__c> packages = [SELECT Id, Push_to_Actility__c 
                                             FROM LoRaWAN_Package__c 
                                             WHERE id =: packageId
                                             LIMIT 1];

        if (packages.size() == 0) {
            System.debug('LoRaWAN_Packages not found for : ' + packageId);
        } else if (packages.size() == 1) {            
            final LoRaWAN_Package__c lorawanPackage = packages.get(0);
            System.debug('ThingParkRest.updatePackageFromActilityResponse.lorawanPackage : ' + lorawanPackage);
            
            lorawanPackage.Actility_Order_ID__c = actilityOrderId;
            lorawanPackage.Push_to_Actility__c = false;
    
            update lorawanPackage;
        } else { // if (packages.size() > 1)
            System.debug('Too many LoRaWAN_Packages found for : ' + packageId);
        }
    }
}