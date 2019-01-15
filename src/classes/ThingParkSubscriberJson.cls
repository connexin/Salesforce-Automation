/**
    Subscriber {
        id (string, optional): Id of the subscriber.
        ref (string, optional): Ref of the subscriber.
        vendorRef (string, optional): Ref of the vendor in relation with the subscriber.
        name (string, optional): Name of the subscriber.
        contactEmail (string, optional): Email of the subscriber contact.
        contactInfo (string, optional): Information about the subscriber contact.
        organization (string, optional): Organization of the subscriber.
        externalId (string, optional): Third-party identifier of the subscriber.
        defaultISMBandIds (Array[string], optional): List of ids of the default ISM bands for the subscriber.
        primaryUser (User, optional): First user account created for the subscriber. Only returned upon subscriber creation.
    }
*/
public class ThingParkSubscriberJson {
    public String jsonTemplate;
    public String id;
    public String ref;
    public String vendorRef;
    public String name;
    public String contactEmail;
    public String contactInfo;
    public String organization;
    public String externalId;

    public ThingParkSubscriberJson() {
        ThingParkRestConfig config = new ThingParkRestConfig();
        jsonTemplate = config.subscriberJsonTemplate();
        System.debug('jsonTemplate :' + jsonTemplate);
    }

    public ThingParkSubscriberJson(final String subscriberJsonTemplate) {
        jsonTemplate = subscriberJsonTemplate;
        System.debug('jsonTemplate :' + jsonTemplate);
    }

	public String toJson() {
		String subscriberJson = jsonTemplate;
		if (name != null){
			subscriberJson = subscriberJson.replace('${name}', name);
		}
		if (vendorRef != null) {
			subscriberJson = subscriberJson.replace('${vendorRef}', vendorRef);
		}
		if (contactEmail != null)	{
			subscriberJson = subscriberJson.replace('${contactEmail}', contactEmail);
		}
		if (contactInfo != null)	{
			subscriberJson = subscriberJson.replace('${contactInfo}', contactInfo);
		}
		if (organization != null)	{
			subscriberJson = subscriberJson.replace('${organization}', organization);
		}
		if (externalId != null)		{
			subscriberJson = subscriberJson.replace('${externalId}', externalId);
		}
		return subscriberJson;
	}
    
	public String jsonFrom(LoRaWAN_Tenancy__c tenancy) {
    	vendorRef = 'connexin';
        name = tenancy.Account__r.Name;
    	contactEmail = tenancy.Account__r.Email__c;
    	contactInfo = 'contactInfo';
    	organization = 'Organization';
    	externalId = tenancy.id;
		return toJson();
    }
}