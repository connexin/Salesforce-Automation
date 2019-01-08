// create a order in Actility ThingPark for a Salesforce Package
trigger actilityOrderForPackage on LoRaWAN_Package__c (after insert, after update) {

	System.debug('actilityOrderForPackage');
    
    if (Trigger.isInsert) {
        System.debug('insertActilityOrder.isInsert:' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Package__c pckge : Trigger.New) {
            System.debug('pckge.Name : ' + pckge.Name);           
            System.debug('pckge.Actility_Subscription_ID__c : ' + pckge.Actility_Subscription_ID__c);
            System.debug('pckge.LoRaWAN_Tenancy__c :' + pckge.LoRaWAN_Tenancy__c);
            ThingParkRest.addOrder(pckge);
        }        
    }
        
    if (Trigger.isUpdate) {
        System.debug('insertActilityOrder.isUpdate:' + Trigger.isUpdate);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Package__c pckge : Trigger.New) {
            ThingParkRest.updateOrder(pckge);
        }
    }
}