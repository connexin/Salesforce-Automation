public class ThingParkInvoiceConfig implements ConfigurationInterface {
    public class ConfigurationNotFoundException extends Exception {}
    private ThingPark_Invoice_Configuration__mdt config;

	private ThingParkInvoiceConfig() {
        this.config = getRow('Current');
    }

    private ThingParkInvoiceConfig(final String scope) {
        this.config = getRow(scope);
    }
    
    private ThingPark_Invoice_Configuration__mdt getRow(final String scope) {
        List<ThingPark_Invoice_Configuration__mdt> configRows = [
            SELECT label, Version__c 
            FROM ThingPark_Invoice_Configuration__mdt 
            WHERE label = :scope LIMIT 1];

        if (configRows.size() == 0) {
            throw new ConfigurationNotFoundException('Configuration not found with label : ' + scope);
        } else  {
            return configRows.get(0);
        }
    }

    public static ThingParkInvoiceConfig selectCurrent() {
        return new ThingParkInvoiceConfig();
    }
    
    public static ThingParkInvoiceConfig selectStable() {
        return new ThingParkInvoiceConfig('Stable');
    }

    public static ThingParkInvoiceConfig selectLatest() {
        return new ThingParkInvoiceConfig('Latest');
    }

	public String asString() {
        return JSON.serialize(config);
    }

	public void toLog() {
        System.debug('toLog : ' + asString());
    }

}