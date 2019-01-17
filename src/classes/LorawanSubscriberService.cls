@RestResource(urlMapping='/ThingParkBillingService/LorawanSubscribers/*')
global with sharing class LorawanSubscriberService {
	static String regExp = '\\/ThingParkBillingService\\/LorawanSubscribers\\/(\\d+)';

    @HttpGet global static LoRaWAN_Subscriber__c[] doGet() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if (System.Pattern.matches(regExp, request.requestURI)) {
	        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
	        return [SELECT Id, Name FROM LoRaWAN_Subscriber__c WHERE id=:id];
        } else {
        	return [SELECT Id, Name FROM LoRaWAN_Subscriber__c];            
        }
    }
}