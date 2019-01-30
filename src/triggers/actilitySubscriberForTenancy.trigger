// create a subscriber in Actility ThingPark for a Salesforce Tenancy
trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

    // @TODO: Temporary to aid unit testing should be removed before going live
    if(Test.isRunningTest()) {
        System.debug('Skipping actilitySubscriberForTenancy during Unit Tests');
        return;
    } else {
		System.debug('actilitySubscriberForTenancy');
    }

    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);
        System.debug('Trigger.New : ' + Trigger.New);
        
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            if (tenancy.Push_to_Actility__c) {
				ThingParkRest.addTenancy(jsonFrom(tenancy));
            }
        }
        
    } else if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);
        
        System.debug('Trigger.New : ' + Trigger.New);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            // @TODO: Temporary to aid testing should be removed before deployment
            if (tenancy.Push_to_Actility__c) {
                ThingParkRest.updateTenancy(jsonFrom(tenancy));
            }
        }
    }

    public static String jsonFrom(LoRaWAN_Tenancy__c tenancy) {
        List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact WHERE Id =: tenancy.Contact__c LIMIT 1];
        String organization = [SELECT Name from Account WHERE Id =: tenancy.Account__c LIMIT 1].Name;
        String rndPassword = RandomData.actiltyPolicyPassword();
        String subscriberJson = new ThingParkSubscriberJson(contacts[0].FirstName,
                                                            contacts[0].LastName,
                                                            contacts[0].email,
                                                            organization,
                                                            tenancy.id,
                                                            rndPassword).toJson();
        System.debug('actilitySubscriberForTenancy.subscriberJson : ' + subscriberJson);
        return subscriberJson;
    }
}