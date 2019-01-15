public class ThingParkInvoice {

    private static ThingParkInvoiceConfig config;
	private Fiscal_Document__c fd;

	private ThingParkInvoice() {
    }

    public static ThingParkInvoice create() {
        // fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        // insert fd;        
        return new ThingParkInvoice();
    }

    public ThingParkInvoice addLine() {
        // Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        // insert fdl;
        return this;
    }
}