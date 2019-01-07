trigger actilityOrderForPackage on LoRaWAN_Package__c (after insert, after update) {

    if (Trigger.isInsert) {
        System.debug('insertActilityOrder.isInsert:' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Package__c item : Trigger.New) {
            System.debug('item.Name : ' + item.Name);           
            System.debug('item.Actility_Subscription_ID__c : ' + item.Actility_Subscription_ID__c);
            System.debug('item.LoRaWAN_Tenancy__c :' + item.LoRaWAN_Tenancy__c);
            ThingParkRest.addOrder(item);
        }        
    }
        
    if (Trigger.isUpdate) {
        System.debug('insertActilityOrder.isUpdate:' + Trigger.isUpdate);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Package__c item : Trigger.New) {
            ThingParkRest.updateOrder(item);
        }
    }
}