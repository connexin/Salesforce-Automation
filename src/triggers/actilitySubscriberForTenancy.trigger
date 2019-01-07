trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Tenancy__c item: Trigger.New) {
            System.debug('item.Name : ' + item.Name);
            System.debug('item.Actility_Subscriber_ID__c : ' + item.Actility_Subscriber_ID__c);
            System.debug('item.Account__c :' + item.Account__c);
            ThingParkRest.addTenancy(item);
        }
    }
        
    if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Tenancy__c item: Trigger.New) {
            ThingParkRest.updateTenancy(item);
        }
    }
}