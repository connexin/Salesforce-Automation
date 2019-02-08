@isTest public class ThingParkInvoiceTest extends AbstractTestCase {
    
    @isTest static void testThingParkInvoice() {
        assertNotNull(ThingParkInvoice.create('accountId', 'description'));
    }    
}