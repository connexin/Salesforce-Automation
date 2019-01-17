@RestResource(urlMapping='/ThingParkBillingService/LorawanInvoice/*')
global with sharing class LorawanInvoiceService {
    
    @HttpGet
    global static Fiscal_Document__c[] doGet() {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);
        Integer idStart = request.requestURI.lastIndexOf('/')+1;
        String id = request.requestURI.substring(idStart);
        Fiscal_Document__c[] results = [SELECT Id, Name, Description__c, Account__c, Total_Value__c FROM Fiscal_Document__c];
        System.debug('Fiscal_Document__c' + results);
        return results;
    }
    
    @HttpPost
    global static String doPost(String name) {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);

        // Integer idStart = request.requestURI.lastIndexOf('/')+1;
        // String id = request.requestURI.substring(idStart);
        // System.debug('request.requestURI : ' + request.requestURI);
        
        // LoRaWAN_Subscriber__c subscriber = new LoRaWAN_Subscriber__c();
        // Name, Device_Rate__c, Account__c, Message_Rate__c, Commitment__c, Overage_Rate__c, Fair_Usage_Limit__c
        // subscriber.Name = name;
        // insert subscriber;
        // return subscriber.Id;
        return name;
    }
    
    @HttpDelete
    global static void doDelete() {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);

        // Integer idStart = request.requestURI.lastIndexOf('/')+1;
        // String id = request.requestURI.substring(idStart);
        // System.debug('request.requestURI : ' + request.requestURI);

        // LoRaWAN_Subscriber__c subscriber = [SELECT Id, Name FROM LoRaWAN_Subscriber__c WHERE Id = :id];
        // System.debug('delete : ' + subscriber);
        // delete subscriber;
    }
}