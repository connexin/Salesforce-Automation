trigger insertActilityOrder on LoRaWAN_Package__c (after insert, after update) {

    if (Trigger.isInsert) {
        System.debug('isInsert:' + Trigger.isInsert);

        // Should only be one of these:
        for (LoRaWAN_Package__c item : trigger.new) {
            // Actility_Subscription_ID__c,
            // Device_Rate_after_commitment_end__c,
            // Device_Rate__c,
            // End_Date__c,
            // Id,
            // is_Active__c,
            // is_Cancelled__c,
            // LoRaWAN_Tenancy__c,
            // Name,
            // Quantity_Of_Devices__c,
            // Start_Date__c,
            // Status__c,
            // Term__c

            System.debug( 'Actility_Subscription_ID__c :' + item.Actility_Subscription_ID__c);
            System.debug( 'Device_Rate_after_commitment_end__c :' + item.Device_Rate_after_commitment_end__c);
            System.debug( 'Device_Rate__c :' + item.Device_Rate__c );
            System.debug( 'End_Date__c :' + item.End_Date__c);
            System.debug( 'Id :' + item.Id);
            System.debug( 'is_Active__c :' + item.is_Active__c);
            System.debug( 'is_Cancelled__c :' + item.is_Cancelled__c);
            System.debug( 'LoRaWAN_Tenancy__c :' + item.LoRaWAN_Tenancy__c);
            System.debug( 'Name :' + item.Name);
            System.debug( 'Quantity_Of_Devices__c :' + item.Quantity_Of_Devices__c);
            System.debug( 'Start_Date__c :' + item.Start_Date__c);
            System.debug( 'Status__c : ' + item.Status__c);
            System.debug( 'Term__c :' + item.Term__c);        
    
            // construct the json.
        
            // fire the request
            }        
        }
        
    if (Trigger.isUpdate) {
        System.debug('isUpdate:' + Trigger.isUpdate);
        // so prevent update
        }
}