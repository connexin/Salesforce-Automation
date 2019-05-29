@isTest public class InvoiceStatusTest extends AbstractTestCase {

    @isTest static void testStatus() {
		Test.startTest();
        InvoiceStatus invoiceStatus = InvoiceStatus.PENDING;
        System.debug('invoiceStatus : ' + invoiceStatus);
		Test.stopTest();
    }

}