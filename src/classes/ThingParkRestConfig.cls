public class ThingParkRestConfig {

    private ThingPark_REST_Config__mdt config;

    public ThingParkRestConfig() {
        config = [SELECT label, API_Version__c, Client_ID__c, Client_Password__c, Client_Secret__c, Endpoint__c, Subscriber_JSON__c, Order_JSON__c FROM ThingPark_REST_Config__mdt WHERE label = 'Current'];
    }

    public ThingParkRestConfig(final String scope) {
        config = [SELECT label, API_Version__c, Client_ID__c, Client_Password__c, Client_Secret__c, Endpoint__c, Subscriber_JSON__c, Order_JSON__c FROM ThingPark_REST_Config__mdt WHERE label = :scope];
    }

    public static ThingParkRestConfig selectCurrent() {
        return new ThingParkRestConfig();
    }
    
    public static ThingParkRestConfig selectStable() {
        return new ThingParkRestConfig('Stable');
    }

    public static ThingParkRestConfig selectLatest() {
        return new ThingParkRestConfig('Latest');
    }

    public String label() {
        return config.label;
    }
    
    public String version() {
        return config.API_Version__c;
    }

    public String clientId() {
        return config.Client_ID__c;
    }

    public String clientPassword() {
        return config.Client_Password__c;
    }

    public String clientSecret() {
        return config.Client_Secret__c;
    }

    public String endpoint() {
        return config.Endpoint__c;
    }

    public String subscriberJsonTemplate() {
        return config.Subscriber_JSON__c;
    }

	public String orderJsonTemplate() {
        return config.Order_JSON__c;
    }

	public String asString() {
        return JSON.serialize(config);
    }

	public void toLog() {
        System.debug('toLog : ' + asString());
    }
}