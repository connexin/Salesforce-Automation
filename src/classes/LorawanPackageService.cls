@RestResource(urlMapping='/ThingParkBillingService/LorawanPackages/*')
global with sharing class LorawanPackageService {
	static String regExp = '\\/ThingParkBillingService\\/LorawanPackages\\/(\\d+)';
	@HttpGet
    global static LoRaWAN_Package__c[] doGet() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if (System.Pattern.matches(regExp, request.requestURI)) {
	        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        	return [SELECT Id, Name, LoRaWAN_Tenancy__c, LoRaWAN_Tenancy__r.Id, LoRaWAN_Tenancy__r.Name, Actility_Subscription_ID__c, Start_Date__c, Term__c, Quantity_Of_Devices__c, Device_Rate__c, Device_Rate_after_commitment_end__c, is_Active__c, is_Cancelled__c, Status__c FROM LoRaWAN_Package__c WHERE id=:id];
        } else {
        	return [SELECT Id, Name, LoRaWAN_Tenancy__c, LoRaWAN_Tenancy__r.Id, LoRaWAN_Tenancy__r.Name, Actility_Subscription_ID__c, Start_Date__c, Term__c, Quantity_Of_Devices__c, Device_Rate__c, Device_Rate_after_commitment_end__c, is_Active__c, is_Cancelled__c, Status__c FROM LoRaWAN_Package__c];
        }
    }
}