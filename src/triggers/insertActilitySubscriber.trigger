trigger insertActilitySubscriber on LoRaWAN_Tenancy__c (after insert, after update) {

    if (Trigger.isInsert) {
        System.debug('isInsert:' + Trigger.isInsert);

        // Should only be one of these:
        for (LoRaWAN_Tenancy__c item: trigger.new) {   
            // SELECT Account__c,
            // Actility_Subscriber_ID__c,
            // Daily_Max_Average__c,
            // Id,Name,
            // Overage_Rate__c,
            // Total_Devices__c
        
            System.debug( 'Account__c : ' + item.Account__c );
            System.debug( 'Actility_Subscriber_ID__c : ' + item.Actility_Subscriber_ID__c);
            System.debug( 'Daily_Max_Average__c : ' + item.Daily_Max_Average__c);
            System.debug( 'Id : ' + item.Id);
            System.debug( 'Name : ' + item.Name);
            System.debug( 'Overage_Rate__c : ' + item.Overage_Rate__c);
            System.debug( 'Total_Devices__c : ' + item.Total_Devices__c);
        
            // construct the json.
        
            // fire the request
            }        
        }
        
    if (Trigger.isUpdate) {
        System.debug('isUpdate:' + Trigger.isUpdate);
        // so prevent update
        }

}