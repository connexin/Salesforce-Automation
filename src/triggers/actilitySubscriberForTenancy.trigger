// create a subscriber in Actility ThingPark for a Salesforce Tenancy
trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

    System.debug('actilitySubscriberForTenancy');    
    
    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        System.debug('Trigger.New : ' + Trigger.New);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            System.debug('tenancy.Name : ' + tenancy.Name);
            System.debug('tenancy.Actility_Subscriber_ID__c : ' + tenancy.Actility_Subscriber_ID__c);
            System.debug('tenancy.Account :' + tenancy.Account__c);
            System.debug('tenancy.Account.Name : ' + tenancy.Account__r.Name);
            ThingParkRest.addTenancy(tenancy);
        }
    }

    if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        System.debug('Trigger.New : ' + Trigger.New);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            System.debug('tenancy.Name : ' + tenancy.Name);
            System.debug('tenancy.Actility_Subscriber_ID__c : ' + tenancy.Actility_Subscriber_ID__c);
            System.debug('tenancy.Account__c :' + tenancy.Account__c);            
            System.debug('tenancy.Account.Name : ' + tenancy.Account__r.Name);
            ThingParkRest.updateTenancy(tenancy);
        }
    }
}