@RestResource(urlMapping='/ThingParkBillingService/LorawanUsage/*')
global with sharing class ThingParkBillingService {

    @HttpPost global static String doPost() {
        System.debug('ThingParkBillingService.doPost : ');
        final RestRequest request = RestContext.request;
        System.debug('ThingParkBillingService.request : ' + request);
        System.debug('ThingParkBillingService.request.requestURI : ' + request.requestURI);
        System.debug('ThingParkBillingService.request.resourcePath : ' + request.resourcePath);
        System.debug('ThingParkBillingService.request.params : ' + request.params);
        System.debug('ThingParkBillingService.request.requestBody : ' + request.requestBody);
        
        final String requestPayload = request.requestBody.toString();
        System.debug('requestPayload : ' + requestPayload);
        
		final String resultMessage;
        if (ThingParkUsageJson.verify(requestPayload)) {
            ThingParkUsageJson jsonData = ThingParkUsageJson.parse(requestPayload);
            System.assert(jsonData != null, 'jsonData cannot be null for requestPayload : ' + requestPayload);
            System.debug('jsonData : ' + jsonData);

            try {
                new ThingParkBilling().process(jsonData);
                resultMessage = '{"status":"success", "message":"invoice created"}';
            } catch(Exception e) {
                resultMessage = '{"status":"error","description":"' + e.getMessage() + '}"';
                RestContext.response.statusCode = 400;
                System.debug(e);
            }
            System.debug(resultMessage);
            return resultMessage;
        } else {
            resultMessage = '{"status":"error","description":"Invalid Json", "payload":"' + requestPayload + '}"';
            RestContext.response.statusCode = 400;
            System.debug(resultMessage);
            return resultMessage;
        }
    }
}