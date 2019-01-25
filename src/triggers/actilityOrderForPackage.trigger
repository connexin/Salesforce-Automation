trigger actilityOrderForPackage on LoRaWAN_Package__c (after insert, after update) {

	System.debug('actilityOrderForPackage');

    if ( trigger.isInsert ) {
        for (LoRaWAN_Package__c lorawanPackage: trigger.new) {
            // @TODO: Temporary to aid testing should be removed before deployment
            if(Test.isRunningTest()) {
                System.debug('Skipping actility call');
                return;
            } else {
                String orderJson = jsonFrom(lorawanPackage);
                System.debug('orderJson : ' + orderJson);
            }
        }
    } else if ( trigger.isUpdate ) {
        for (LoRaWAN_Package__c lorawanPackage : trigger.new) {
            // @TODO: Temporary to aid testing should be removed before deployment
            if(Test.isRunningTest()) {
                System.debug('Skipping actility call');
                return;
            } else {
                String orderJson = jsonFrom(lorawanPackage);
                System.debug('orderJson : ' + orderJson);
            }
        }
    }

    public static String jsonFrom(LoRaWAN_Package__c lorawanPackage) {
        System.debug('lorawanPackage : ' + lorawanPackage);
        String offerId = 'connexin-vdr/starter-kit';
        String orderJson = new ThingParkOrderJson(offerId, lorawanPackage.id).toJson();
        System.debug('actilitySubscriberForTenancy.orderJson : ' + orderJson);
        return orderJson;
    }
}