// create a subscriber in Actility ThingPark for a Salesforce Tenancy
trigger actilitySubscriberForTenancy on LoRaWAN_Tenancy__c (after insert, after update) {

    System.debug('actilitySubscriberForTenancy');

    if (Trigger.isInsert) {
        System.debug('insertActilitySubscriber.isInsert :' + Trigger.isInsert);
        System.debug('Trigger.New : ' + Trigger.New);

        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {            
            // @TODO: Temporary to aid testing should be removed before going live
            if(Test.isRunningTest()) {
                System.debug('Skipping actility call');
                return;
            } else {
            	String subscriberJson = jsonFrom(tenancy);
                System.debug('subscriberJson : ' + subscriberJson);
	            ThingParkRest.addTenancy(subscriberJson);
            }
        }
    } else if (Trigger.isUpdate) {
        System.debug('insertActilitySubscriber.isUpdate :' + Trigger.isUpdate);

        System.debug('Trigger.New : ' + Trigger.New);
        for (LoRaWAN_Tenancy__c tenancy: Trigger.New) {
            // @TODO: Temporary to aid testing should be removed before deployment
            if(Test.isRunningTest()) {
                System.debug('Skipping actility call');
                return;
            } else {
            	String subscriberJson = jsonFrom(tenancy);
                System.debug('subscriberJson : ' + subscriberJson);

            	ThingParkRest.updateTenancy(subscriberJson);
            }
        }
    }
    
    public static String jsonFrom(LoRaWAN_Tenancy__c tenancy) {
        System.debug('tenancy : ' + tenancy);

        String firstName = tenancy.Contact__r.firstName;
        String lastName = tenancy.Contact__r.lastName;
        String email = tenancy.Contact__r.email;
        String organization = tenancy.Account__r.Name;
        String password = RandomData.actiltyPolicyPassword();
        String subscriberJson = new ThingParkSubscriberJson(firstName, lastName, email, organization, password).toJson();
        System.debug('actilitySubscriberForTenancy.subscriberJson : ' + subscriberJson);
        return subscriberJson;
    }
}