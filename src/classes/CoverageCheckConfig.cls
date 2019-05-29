public class CoverageCheckConfig {

    public class ConfigException extends Exception {}
    private Coverage_Check_Configuration__mdt config;

    // Use the Current default configuration
    private CoverageCheckConfig() {
        this.config = getRow('Current');
    }
    
    // Use the named configuration
    private CoverageCheckConfig(final String scope) {
        this.config = getRow(scope);
    }
    
    private Coverage_Check_Configuration__mdt getRow(final String scope) {
        final List<Coverage_Check_Configuration__mdt> configRows = [
            SELECT label, description__c, API_Version__c, Endpoint__c, JSON_Template__c , Active__c
            FROM Coverage_Check_Configuration__mdt 
            WHERE label = :scope 
            LIMIT 1];

        if (configRows.size() == 0) {
            throw new ConfigException('Configuration not found with label : ' + scope);
        } else if (configRows.size() > 1) {
            throw new ConfigException('To many Configurations found with label : ' + scope);
        } else  {
            return configRows.get(0);
        }
    }
 
    // factory method for current default configuration
    public static CoverageCheckConfig selectCurrent() {
        return new CoverageCheckConfig();
    }

    // factory method for last known stable configuration
    public static CoverageCheckConfig selectStable() {
        return new CoverageCheckConfig('Stable');
    }

    // factory method for latest defined configuration
    public static CoverageCheckConfig selectLatest() {
        return new CoverageCheckConfig('Latest');
    }

    // factory method for named configuration
    public static CoverageCheckConfig selectScope(final String scopeLabel) {
        return new CoverageCheckConfig(scopeLabel);
    }

    public String label() {
        return config.label;
    }

    public String description() {
        return config.description__c;
    }

    public Boolean active() {
        return config.Active__c;
    }
    
    public String version() {
        return config.API_Version__c;
    }
    
    public String endpoint() {
        return config.Endpoint__c;
    }    

    public String jsonTemplate() {
        return config.JSON_Template__c;
    }

	public String asString() {
        return JSON.serialize(config);
    }

	public void toLog() {
        System.debug('CoverageCheckConfig.toLog : ' + asString());
    }    
}