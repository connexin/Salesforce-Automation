trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

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
        
    if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);

        // Shouldn't there only be one of these?
        // TODO: assert size is one?
        for (LoRaWAN_Tenancy__c item: trigger.new) {
            ThingParkREST.updateTenancy(item);
            ThingParkREST.getTenancy(item);
            // update this record from response as necessary.           
            }
        }
    }