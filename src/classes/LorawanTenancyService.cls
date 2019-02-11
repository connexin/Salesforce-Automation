@RestResource(urlMapping='/ThingParkBillingService/LorawanTenancies/*')
global with sharing class LorawanTenancyService {
    static String regExp = '\\/ThingParkBillingService\\/LorawanTenancies\\/(\\d+)';
    
    @HttpGet global static LoRaWAN_Tenancy__c[] doGet() {
        final RestRequest request = RestContext.request;
        final RestResponse response = RestContext.response;
        
        if (System.Pattern.matches(regExp, request.requestURI)) {
            final String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            
            return [SELECT Id, Name, Account__c, Account__r.Id, Account__r.Name, Contact__c, 
                    Actility_Subscriber_ID__c, Push_to_Actility__c,
                    Daily_Max_Average__c, Overage_Rate__c, Total_Devices__c
                    FROM LoRaWAN_Tenancy__c 
                    WHERE id=:id];
        } else {
            return [SELECT Id, Name, Account__c, Account__r.Id, Account__r.Name, Contact__c, 
                    Actility_Subscriber_ID__c, Push_to_Actility__c,
                    Daily_Max_Average__c, Overage_Rate__c, Total_Devices__c
                    FROM LoRaWAN_Tenancy__c];
        }
    }
}