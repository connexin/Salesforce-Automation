// create a order in Actility ThingPark for a Salesforce Package
trigger actilityOrderForPackage on LoRaWAN_Package__c (after insert, after update) {

    // @TODO: Temporary to aid unit testing should be removed before going live
    if(Test.isRunningTest()) {
        System.debug('Skipping actilityOrderForPackage during Unit Tests');
        return;
    } else {
		System.debug('actilityOrderForPackage');
    }
    
    if ( trigger.isInsert ) {
        for (LoRaWAN_Package__c lorawanPackage: trigger.new) {
            if (lorawanPackage.Push_to_Actility__c) {
                ThingParkRest.addOrder(jsonFrom(lorawanPackage));
            } else {
                // reset the push flag, to prevent infinit loop.
                lorawanPackage.Push_to_Actility__c = false;
                update lorawanPackage;
            }
        }
    } else if ( trigger.isUpdate ) {
        for (LoRaWAN_Package__c lorawanPackage : trigger.new) {
            if (lorawanPackage.Push_to_Actility__c) {
                ThingParkRest.updateOrder(jsonFrom(lorawanPackage));
            } else {
                // reset the push flag, to prevent infinit loop.
                lorawanPackage.Push_to_Actility__c = false;
                update lorawanPackage;
            }
        }
    }

    public static String jsonFrom(LoRaWAN_Package__c lorawanPackage) {
        System.debug('lorawanPackage : ' + lorawanPackage);
        String offerId = 'connexin-vdr/tpw-starter-kit';
        String orderJson = new ThingParkOrderJson(offerId, lorawanPackage.id).toJson();
        System.debug('actilitySubscriberForTenancy.orderJson : ' + orderJson);
        return orderJson;
    }
}