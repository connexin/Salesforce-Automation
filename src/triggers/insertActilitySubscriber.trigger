// to be replaced by : actilitySubscriberForTenancy
trigger insertActilitySubscriber on LoRaWAN_Tenancy__c (after insert) {
    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Tenancy__c item: trigger.new) {        	
			ThingParkREST.addTenancy(item);
        	ThingParkREST.getTenancy(item);
        	// add the subscriberID to this record.        	
            }
        }
	}