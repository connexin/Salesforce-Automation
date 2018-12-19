// to be replaced by : actilityOrderForPackage
trigger insertActilityOrder on LoRaWAN_Package__c (after insert) {
    if (Trigger.isInsert) {
		System.debug('insertActilityOrder.isInsert:' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Package__c item : trigger.new) {
			ThingParkREST.addOrder(item);
        	ThingParkREST.getOrder(item);
        	// update this record from response as necessary.
            }        
        }
	}