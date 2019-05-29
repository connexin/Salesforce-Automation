public class ThingParkRestConfig implements ConfigurationInterface {
    
    public class ThingParkConfigException extends Exception {}
    private ThingPark_REST_Config__mdt config;

    // Use the Current default configuration
    private ThingParkRestConfig() {
        this.config = getRow('Current');
    }

    // Use the named configuration
    private ThingParkRestConfig(final String scope) {
        this.config = getRow(scope);
    }

    private ThingPark_REST_Config__mdt getRow(final String scope) {
        final List<ThingPark_REST_Config__mdt> configRows = [
            SELECT label, API_Version__c, Client_ID__c, Client_Password__c, Client_Secret__c, Endpoint__c, Subscriber_JSON__c, Order_JSON__c 
            FROM ThingPark_REST_Config__mdt 
            WHERE label = :scope 
            LIMIT 1];

        if (configRows.size() == 0) {
            throw new ThingParkConfigException('Configuration not found with label : ' + scope);
        } else if (configRows.size() > 1) {
            throw new ThingParkConfigException('To many Configurations found with label : ' + scope);
        } else  {
            return configRows.get(0);
        }
    }

    // factory method for current default configuration
    public static ThingParkRestConfig selectCurrent() {
        return new ThingParkRestConfig();
    }

    // factory method for last known stable configuration
    public static ThingParkRestConfig selectStable() {
        return new ThingParkRestConfig('Stable');
    }

    // factory method for latest defined configuration
    public static ThingParkRestConfig selectLatest() {
        return new ThingParkRestConfig('Latest');
    }

    // factory method for named configuration
    public static ThingParkRestConfig selectScope(final String scopeLabel) {
        return new ThingParkRestConfig(scopeLabel);
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
        System.debug('ThingParkRestConfig.toLog : ' + asString());
    }
}