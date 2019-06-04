@isTest public class CustomerStateTest extends AbstractTestCase {

    @isTest static void testCustomerState() {
        Test.startTest();

        final CustomerState customerState = CustomerState.initialise();
        assertNotNull(customerState);
        customerState.toLog();

        customerState.failedCoverage();
        System.debug('customerState : ' + customerState);

        customerState.passedCoverage();
        System.debug('customerState : ' + customerState);

        customerState.failedCredit();
        System.debug('customerState : ' + customerState);

        customerState.passedCredit();
        System.debug('customerCredit : ' + customerState);

        customerState.depositTaken();
        System.debug('customerCredit : ' + customerState);

        customerState.installationBooked();
        System.debug('customerCredit : ' + customerState);

        customerState.passedSurvey();
        System.debug('customerCredit : ' + customerState);

        customerState.installationComplete();
        System.debug('customerCredit : ' + customerState);
        
        Test.stopTest();
    }
    
}