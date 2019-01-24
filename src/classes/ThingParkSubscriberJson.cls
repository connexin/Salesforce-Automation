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

User {
id (string, optional): Id of the user. ,
ref (string, optional): Ref of the user. ,
firstName (string, optional): First name of the user. ,
lastName (string, optional): Last name of the user. ,
email (string, optional): Email of the user. ,
organization (string, optional): Organization of the user. ,
password (string, optional): New password for the user account. ,
oldPassword (string, optional): Old password of the user account. Only required when replacing an existing password. ,
scopes (Array[string], optional): List of scopes available for the user. Note that this attribute is READ-ONLY. ,
apiOnly (boolean, optional): If true, the user account can only be used for API-based authentication and requests, no GUI-based actions will be available. API-only user accounts are not subject to password expiration. Note that this attribute can be set during user creation but is not returned on further retrievals.
}

*/
public class ThingParkSubscriberJson extends AbstractJsonTemplate {
    private ThingParkRestConfig config;
    public String firstName { get; set;}
    public String lastName { get; set;}
    public String email { get; set;}
    public String organization { get; set;}
    public String password { get; set;}

    public ThingParkSubscriberJson() {
        this.config = ThingParkRestConfig.selectCurrent();
    }

    public ThingParkSubscriberJson(String scopeLabel) {
        this.config = ThingParkRestConfig.selectScope(scopeLabel);
    }
    
    public ThingParkSubscriberJson(final String firstName,
                                   final String lastName,
                                   final String email,
                                   final String organization,
                                   final String password) {
                                       this.config = ThingParkRestConfig.selectCurrent();
                                       this.firstName = firstName;
                                       this.lastName = lastName;
                                       this.email = email;
                                       this.organization = organization;
                                       this.password = password;
                                   }
    
    public String toJson() {
        jsonTemplate = config.subscriberJsonTemplate();

        replace('${firstName}', firstName);
        replace('${lastName}', lastName);
        replace('${email}', email);
        replace('${organization}', organization);
        replace('${password}', password);

        return jsonTemplate;
    }
}