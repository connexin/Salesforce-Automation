public class ThingParkInvoice {
    private static ThingParkInvoiceConfig invoiceConfig = ThingParkInvoiceConfig.selectCurrent();
	private static List<LoRaWAN_Package__c> lorawanPackages = [
        SELECT ID, Name, Quantity_Of_Devices__c, Device_Rate__c, End_Date__c, Device_Rate_after_commitment_end__c 
        FROM LoRaWAN_Package__c];
        // WHERE IsActive = true LIMIT 1];
    private static List<Product2> lorawanProducts = [
        SELECT Id, Name, Description, Family, ProductCode, IsActive 
        FROM Product2 
        WHERE Family = 'LORAWAN' AND IsActive = true];
    private static RecordType recordType = [
        SELECT Id 
        FROM RecordType 
        WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice' 
    	LIMIT 1];
    private static Tax__c vatRate = [SELECT Id, Name, Rate__c FROM Tax__c LIMIT 1];
    private Fiscal_Document__c invoice = null;

    public static ThingParkInvoice create(final String accountId, final String description) {
        System.assert(accountId != null, 'Account must be specified for all invoices');
        return new ThingParkInvoice(accountId, description);
    }

    private ThingParkInvoice(final String accountId, final String description) {
        // When we create an invoice for the service usage
        this.invoice = new Fiscal_Document__c(
            Account__c = accountId,
            Description__c = description,
            Original_Source__c = 'ThingPark',
            RecordTypeId = recordType.Id,
            Draft__c = true,
            Dispute__c = false);
        insert invoice;
        System.debug('ThingParkInvoice.accountId : ' + accountId);
        System.debug('ThingParkInvoice.invoice : ' + invoice);
    }

	// @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addServiceCharges(final String productId, final Decimal qty) {
        final String description = 'Service';
        Decimal unitCost = 0.00;
        return addServiceCharges(description, productId, qty, unitCost);
    }

    public ThingParkInvoice addServiceCharges(final String description, 
                                              final String productId, 
                                              final Decimal qty, 
                                              final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }
    
	// @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addDeviceCharges(final String productId, final Decimal qty) {
        final String description = 'Devices';
        final Decimal unitCost = 2.00;
        return addDeviceCharges(description, productId, qty, unitCost);
    }

    public ThingParkInvoice addDeviceCharges(final String description, 
                                             final String productId, 
                                             final Decimal qty, 
                                             final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }

	// @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addOverageCharges(final String productId, final Decimal qty) {
        final String description = 'Overage';
        final Decimal unitCost = 0.40;
        return addOverageCharges(description, productId, qty, unitCost);
    }

    public ThingParkInvoice addOverageCharges(final String description, 
                                              final String productId, 
                                              final Decimal qty, 
                                              final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }
    
	// @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addEndOfLifeCharges(final String productId, final Decimal qty) {
        final String description = 'End of life';
        final Decimal unitCost = 0.80;
        return addEndOfLifeCharges(description, productId, qty, unitCost);
    }

    public ThingParkInvoice addEndOfLifeCharges(final String description, 
                                                final String productId, 
                                                final Decimal qty, 
                                                final Decimal unitCost) {
        return addLine(description, productId, qty, unitCost);
    }

    private ThingParkInvoice addLine(final String description, 
                                     final String productId, 
                                     final Decimal qty, 
                                     final Decimal unitCost) {
        System.assert(productId != null, 'Product must be identified for invoice line');
        System.assert(qty != null, 'qty must be defined, but may be zero.');
        System.assert(unitCost != null, 'unitCost must be defined, but may be zero.');
		System.debug('addLine.invoice' + invoice);
		System.debug('addLine.invoice.id' + invoice.id);

        final Fiscal_Document_Line__c invoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.id,
            Description__c = description,
            Product__c = productId,
            Quantity__c = qty,
            Amount__c = unitCost,
            Tax__c = vatRate.Id);
		insert invoiceLine;

        return this;
    }

    public void toLog() {
		System.debug('ThingParkInvoice.invoice : ' + invoice);
        final List<Fiscal_Document_Line__c> invoiceLines = [
        	SELECT id, Name, Description__c, Amount__c, Amount_Value__c, Fiscal_Document__c
            FROM Fiscal_Document_Line__c
            WHERE Fiscal_Document__c =: invoice.id];
        for(Fiscal_Document_Line__c invoiceLine : invoiceLines) {
        	System.debug('invoiceLine : ' + invoiceLine);
        }
    }
    
    
}