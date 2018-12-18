trigger insertActilitySubscriber on LoRaWAN_Tenancy__c (after insert, after update) {

	String accessToken = ThingParkREST.authorise();

    if (Trigger.isInsert) {
        System.debug('isInsert :' + Trigger.isInsert);

        // Should only be one of these:
        for (LoRaWAN_Tenancy__c item: trigger.new) {        	
			HttpResponse result = ThingParkREST.addTenancy(accessToken, item);

        	HttpResponse result2 = ThingParkREST.getTenancy(accessToken, item);            
            }
        }
        
    if (Trigger.isUpdate) {
        System.debug('isUpdate :' + Trigger.isUpdate);

        // Should only be one of these:
        for (LoRaWAN_Tenancy__c item: trigger.new) {
			HttpResponse result = ThingParkREST.updateTenancy(accessToken, item);

        	HttpResponse result2 = ThingParkREST.getTenancy(accessToken, item);
            }
        }

}