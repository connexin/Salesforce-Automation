@isTest public class StatusTest extends AbstractTestCase {
    @isTest static void testStatus() {
		Test.startTest();
        Status invoiceStatus = Status.PENDING;
        System.debug('invoiceStatus : ' + invoiceStatus);
		Test.stopTest();
    }
}