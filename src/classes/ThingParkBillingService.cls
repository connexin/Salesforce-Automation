@RestResource(urlMapping='/ThingParkBilling/*')
global with sharing class ThingParkBillingService {
    
    @HttpGet
    global static LoRaWAN_Subscriber__c doGet() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Integer idStart = request.requestURI.lastIndexOf('/')+1;
        String id = request.requestURI.substring(idStart);
        LoRaWAN_Subscriber__c subscriber = [SELECT Id, Name, Device_Rate__c, Account__c, Message_Rate__c, Commitment__c, Overage_Rate__c, Fair_Usage_Limit__c FROM LoRaWAN_Subscriber__c WHERE Id = :id];
        System.debug('get : ' + subscriber);
        return subscriber;
    }
    
    @HttpPost
    global static String doPost(String name) {
        System.debug('create : ' + name);
        LoRaWAN_Subscriber__c subscriber = new LoRaWAN_Subscriber__c();
        // Name, Device_Rate__c, Account__c, Message_Rate__c, Commitment__c, Overage_Rate__c, Fair_Usage_Limit__c
        subscriber.Name = name;
        insert subscriber;
        return subscriber.Id;
    }
    
    @HttpDelete
    global static void doDelete() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Integer idStart = request.requestURI.lastIndexOf('/')+1;
        String id = request.requestURI.substring(idStart);
        LoRaWAN_Subscriber__c subscriber = [SELECT Id, Name FROM LoRaWAN_Subscriber__c WHERE Id = :id];
        System.debug('delete : ' + subscriber);
        // delete subscriber;
    }
}