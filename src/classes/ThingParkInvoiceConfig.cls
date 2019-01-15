public class ThingParkInvoiceConfig {

    private ThingPark_Invoice_Configuration__mdt config;

	private ThingParkInvoiceConfig() {
        config = [SELECT label, Version__c FROM ThingPark_Invoice_Configuration__mdt WHERE label = 'Current'];
    }

    private ThingParkInvoiceConfig(final String scope) {
        config = [SELECT label, Version__c FROM ThingPark_Invoice_Configuration__mdt WHERE label = :scope];
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