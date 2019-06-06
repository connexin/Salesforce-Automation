@isTest public class SelectAllColumnsTest extends AbstractTestCase {

    @isTest static void testCustomerState() {
        Test.startTest();

        String queryString = new SelectAllColumns('Consumer__c').soql;
        assertNotNull(queryString);
        System.debug('queryString : ' + queryString);
        
		Consumer__c consumer = Database.query(queryString);
        assertNotNull(consumer);
        System.debug('consumer : ' + consumer);

        Test.stopTest();
    }
}