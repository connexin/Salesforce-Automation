@RestResource(urlMapping='/ThingParkBillingService/LorawanInvoice/*')
global with sharing class LorawanInvoiceService {
    
    @HttpGet global static Fiscal_Document__c[] doGet() {
        System.debug('LorawanInvoiceService.doGet');
        final RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);
        final Integer idStart = request.requestURI.lastIndexOf('/')+1;
        final String id = request.requestURI.substring(idStart);
        final Fiscal_Document__c[] results = [SELECT Id, Date__c, Name, Description__c, Account__c, Total_Value__c FROM Fiscal_Document__c];
        System.debug('Fiscal_Document__c' + results);
        return results;
    }
    
    @HttpPost global static String doPost() {
        System.debug('LorawanInvoiceService.doPost : ');
        final RestRequest request = RestContext.request;
        System.debug('LorawanInvoiceService.request : ' + request);
        System.debug('LorawanInvoiceService.request.requestURI : ' + request.requestURI);
        System.debug('LorawanInvoiceService.request.resourcePath : ' + request.resourcePath);
        System.debug('LorawanInvoiceService.request.params : ' + request.params);
        System.debug('LorawanInvoiceService.request.requestBody : ' + request.requestBody);
        
        final String requestPayload = request.requestBody.toString();
        System.debug('requestPayload : ' + requestPayload);

		final String resultMessage;
        if (ThingParkInvoiceJson.verify(requestPayload)) {
            ThingParkInvoiceJson jsonData = ThingParkInvoiceJson.parse(requestPayload);
            System.assert(jsonData != null);
            System.debug('jsonData : ' + jsonData);
            System.debug('jsonData.lines : ' + jsonData.lines);

            try {
                new ThingParkBilling().process(jsonData);
                resultMessage = '{"status":"success", "message":"invoice created"}';
            } catch(Exception e) {
                resultMessage = '{"status":"error","description":"' + e.getMessage() + '}"';
                RestContext.response.statusCode = 400;
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