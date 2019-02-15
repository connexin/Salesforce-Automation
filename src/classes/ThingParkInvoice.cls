public class ThingParkInvoice {

	private Fiscal_Document__c fiscalDoc = null;
    private static String recordTypeId;
    private static String vatRateId;

    public static ThingParkInvoice create(final String accountId, 
                                          final String description,
                                          final Date actionDate) {
        System.assert(accountId != null, 'Account must be specified for all invoices');

		recordTypeId = [
        	SELECT Id FROM RecordType 
            WHERE SobjectType = 'Fiscal_Document__c' 
            AND Name = 'Sales Invoice' 
            AND IsActive = true
            LIMIT 1].id;

        vatRateId = [
        	SELECT Id FROM Tax__c 
        	WHERE Name LIKE '%VAT%'
            LIMIT 1].id;

        return new ThingParkInvoice(accountId, description, actionDate);
    }

    private ThingParkInvoice(final String accountId, 
                             final String description,
                             final Date actionDate) {
        // When we create an invoice for the service usage
        this.fiscalDoc = new Fiscal_Document__c(
            Account__c = accountId,
            Description__c = description,
            Date__c = actionDate,
            Original_Source__c = 'ThingPark',
            RecordTypeId = recordTypeId,
            Draft__c = true,
            Dispute__c = false);
        insert fiscalDoc;
    }

    public ThingParkInvoice addServiceCharges(final String description, 
                                              final String productId, 
                                              final Decimal qty, 
                                              final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }
    

    public ThingParkInvoice addDeviceCharges(final String description, 
                                             final String productId, 
                                             final Decimal qty, 
                                             final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }


    public ThingParkInvoice addOverageCharges(final String description, 
                                              final String productId, 
                                              final Decimal qty, 
                                              final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }
    

    public ThingParkInvoice addEndOfLifeCharges(final String description, 
                                                final String productId, 
                                                final Decimal qty, 
                                                final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }

    public ThingParkInvoice addLine(final String description, 
                                     final String productId, 
                                     final Decimal qty, 
                                     final Decimal unitCost) {
        System.assert(productId != null, 'Product must be identified for invoice line');
        System.assert(qty != null, 'qty must be defined, but may be zero.');
        System.assert(unitCost != null, 'unitCost must be defined, but may be zero.');
		System.debug('addLine.fiscalDoc' + fiscalDoc);
		System.debug('addLine.fiscalDoc.id' + fiscalDoc.id);

        final Fiscal_Document_Line__c fiscalDocLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = fiscalDoc.id, 
            Description__c = description, 
            // Product__c = productId,
            Quantity__c = qty, 
            Amount__c = unitCost, 
            Tax__c = vatRateId);
		insert fiscalDocLine; 

        return this;
    }

	public String asJson() {
    	return JSON.serialize(fiscalDoc);
    }

    public void toLog() {
		System.debug('ThingParkInvoice.Fiscal_Document__c : ' + asJson());
    }
}