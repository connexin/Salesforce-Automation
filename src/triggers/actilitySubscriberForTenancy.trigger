// create a subscriber in Actility ThingPark for a Salesforce Tenancy
trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

    // @TODO: Temporary aid to unit testing, prevent unwanted looping
    // should be removeable before going live
    if(Test.isRunningTest()) {
        System.debug('Skipping actilitySubscriberForTenancy during Unit Tests');
        return;
    }

    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            if (tenancy.Push_to_Actility__c) {
				ThingParkRest.addSubscriber(tenancy.id, jsonFrom(tenancy));
            }
        }
    } else if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            if (tenancy.Push_to_Actility__c) {
                ThingParkRest.updateSubscriber(tenancy.id, jsonFrom(tenancy));
            }
        }
    }

    private static String jsonFrom(LoRaWAN_Tenancy__c tenancy) {
        System.debug('actilitySubscriberForTenancy.jsonFrom : ' + tenancy);
        System.debug('lorawanTenancy.Account__c : ' + tenancy.Account__c);
        System.debug('lorawanTenancy.Contact__c : ' + tenancy.Contact__c);

        final List<Account> account = [SELECT Name from Account WHERE Id =: tenancy.Account__c LIMIT 1];
        final List<Contact> contacts = [SELECT FirstName, LastName, Email FROM Contact WHERE Id =: tenancy.Contact__c LIMIT 1];
        final String externalId = tenancy.id;
        final String rndPassword = RandomData.actiltyPolicyPassword();

        final String subscriberJson = new ThingParkSubscriberJson(contacts[0].FirstName,
                                                                  contacts[0].LastName,
                                                                  contacts[0].email,
                                                                  account[0].name,
                                                                  externalId,
                                                                  rndPassword).toJson();

        System.debug('actilitySubscriberForTenancy.subscriberJson : ' + subscriberJson);

        return subscriberJson;
    }
}