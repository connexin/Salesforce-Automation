// create a order in Actility ThingPark for a Salesforce Package
trigger actilityOrderForPackage on LoRaWAN_Package__c (after insert, after update) {

    // @TODO: Temporary aid to unit testing, to prevent unwanted looping
    // should be removeable before going live
    if(Test.isRunningTest()) {
        System.debug('Skipping actilityOrderForPackage during Unit Tests');
        return;
    }

    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);
        for (LoRaWAN_Package__c lorawanPackage: trigger.new) {
            if (lorawanPackage.Push_to_Actility__c) {
                final String json = jsonFrom(lorawanPackage);
                ThingParkRest.addOrder(lorawanPackage.id, json);
            }
        }
    } else if (Trigger.isUpdate ) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);
        for (LoRaWAN_Package__c lorawanPackage : trigger.new) {
            if (lorawanPackage.Push_to_Actility__c) {
                final String json = jsonFrom(lorawanPackage);
                ThingParkRest.updateOrder(lorawanPackage.id, json);
            }
        }
    }

    static String jsonFrom(LoRaWAN_Package__c lorawanPackage) {
        System.debug('actilityOrderForPackage.jsonFrom : ' + lorawanPackage);
        System.debug('lorawanPackage.LoRaWAN_Tenancy__c : ' + lorawanPackage.LoRaWAN_Tenancy__c);
        System.debug('lorawanPackage.Actility_Offer_Ref__c : ' + lorawanPackage.Actility_Offer_Ref__c);
        System.debug('lorawanPackage.Actility_Order_ID__c : ' + lorawanPackage.Actility_Order_ID__c);

        final List<LoRaWAN_Tenancy__c> tenancy = [SELECT Actility_Subscriber_ID__c FROM LoRaWAN_Tenancy__c WHERE Id =: lorawanPackage.LoRaWAN_Tenancy__c LIMIT 1];
        System.debug('tenancy.Actility_Subscriber_ID__c : ' + tenancy[0].Actility_Subscriber_ID__c);
        
        final String offerId = lorawanPackage.Actility_Offer_Ref__c;
        final String subscriberId = tenancy[0].Actility_Subscriber_ID__c;
        final String orderJson = new ThingParkOrderJson(offerId, subscriberId).toJson();
        
        System.debug('actilityOrderForPackage.orderJson : ' + orderJson);
        
        return orderJson;
    }
}