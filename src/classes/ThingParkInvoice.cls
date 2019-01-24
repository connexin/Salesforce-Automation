public class ThingParkInvoice {
    private static ThingParkInvoiceConfig config = ThingParkInvoiceConfig.selectCurrent();
    private static List<Product2> lorawanProducts = [SELECT Id, Name, Description, Family, ProductCode, IsActive FROM Product2 WHERE Family = 'LORAWAN' AND IsActive = true];
    private static RecordType recordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    private static Tax__c vatRate = [SELECT Id, Name, Rate__c FROM Tax__c LIMIT 1];
    private Fiscal_Document__c invoice = null;

    private ThingParkInvoice(final Fiscal_Document__c invoice) {
        this.invoice = invoice;
    }

    public static ThingParkInvoice create(final String accountId, final String description, final String priceBookId) {
        if (accountId != null) {
            // When we create an invoice for the service usage
            Fiscal_Document__c invoice = new Fiscal_Document__c(
                Account__c = accountId,
                Description__c = description,
                // Price_Book__c. = priceBookId,
                RecordTypeId = recordType.Id,
                Draft__c = true,
                Dispute__c = false);
            insert invoice;
            
            return new ThingParkInvoice(invoice);            
        }
        return null;
    }
    
    public ThingParkInvoice addDeviceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        final String description = 'Devices';
        // @todo: look up product charges
        return addLine(accountId, description, productId, qty, amount);
    }
    
    public ThingParkInvoice addServiceCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        final String description = 'Service';
        // @todo: look up product charges
        return addLine(accountId, description, productId, qty, amount);
    }
    
    public ThingParkInvoice addOverageCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        final String description = 'Overage';
        // @todo: look up product charges
        return addLine(accountId, description, productId, qty, amount);
    }
    
    public ThingParkInvoice addEndOfLineCharges(final String accountId, final String productId, final Decimal qty, final Decimal amount) {
        final String description = 'Overage';
        // @todo: look up product charges
        return addLine(accountId, description, productId, qty, amount);
    }
    
    private ThingParkInvoice addLine(final String accountId, final String description, final String productId, final Decimal qty, final Decimal amount) {
        Fiscal_Document_Line__c invoiceLine = new Fiscal_Document_Line__c(
            Fiscal_Document__c = invoice.Id,
            Description__c = description,
            Product__c = productId,
            Quantity__c = qty,
            Amount__c = amount,
            Tax__c = vatRate.Id);
        return this;
    }
}