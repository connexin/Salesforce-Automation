trigger insertActilityOrder on LoRaWAN_Package__c (after insert, after update) {

	String accessToken = ThingParkREST.authorise();

    if (Trigger.isInsert) {
        System.debug('isInsert:' + Trigger.isInsert);

        // Should only be one of these:
        for (LoRaWAN_Package__c item : trigger.new) {
			HttpResponse result = ThingParkREST.addOrder(accessToken, item);

        	HttpResponse result2 = ThingParkREST.getOrder(accessToken, item);            
            }        
        }
        
    if (Trigger.isUpdate) {
        System.debug('isUpdate:' + Trigger.isUpdate);

			HttpResponse result = ThingParkREST.updateOrder(accessToken, item);

        	HttpResponse result2 = ThingParkREST.getOrder(accessToken, item);
        
        }

}