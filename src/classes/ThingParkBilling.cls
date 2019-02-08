public class ThingParkBilling {
    
    public void process(final ThingParkInvoiceJson jsonData) {
        ThingParkInvoice invoice = ThingParkInvoice.create(jsonData.accountId, jsonData.description);
        
        for(ThingParkInvoiceJson.Line invoiceLine : jsonData.lines) {
            System.debug('invoiceLine : ' + invoiceLine);
            try {
                invoice.addLine(invoiceLine.description,
                                invoiceLine.productId,
                                Decimal.valueOf(invoiceLine.qty),
                                Decimal.valueOf(invoiceLine.unitPrice));
            } catch(Exception e) {
                system.debug('skipping : ' + e);
            }
        }
    }
}