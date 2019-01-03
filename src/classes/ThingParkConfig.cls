public class ThingParkConfig {

    private ThingPark_REST_Config__mdt config ;

    public ThingParkConfig() {
        config = [SELECT API_Version__c, Client_ID__c, Client_Password__c, Client_Secret__c, Endpoint__c FROM ThingPark_REST_Config__mdt WHERE label = 'stable'];
        System.debug('ThingParkConfig : ' + config);
    }
    
    public ThingParkConfig(final String scope) {
        config = [SELECT API_Version__c, Client_ID__c, Client_Password__c, Client_Secret__c, Endpoint__c FROM ThingPark_REST_Config__mdt WHERE label = :scope];
        System.debug('ThingParkConfig : ' + config);
    }
    
    public static ThingParkConfig selectLatest() {
        return new ThingParkConfig('latest');
    }
    
    public static ThingParkConfig selectStable() {
        return new ThingParkConfig('stable');
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

}