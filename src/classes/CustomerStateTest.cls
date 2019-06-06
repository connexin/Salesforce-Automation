@isTest public class CustomerStateTest extends AbstractTestCase {

    @isTest static void testCustomerState() {
        Test.startTest();

        final CustomerState customerState = CustomerState.initialise();
        assumeNotNull(customerState);
        customerState.toLog();

        customerState.isLead();
        customerState.isOpportunity();
        customerState.failedCoverage();
        customerState.passedCoverage();
        customerState.failedCredit();
        customerState.passedCredit();
        customerState.failedDeposit();
        customerState.depositTaken();
        customerState.installationBooked();
        customerState.installationDispatched();
        customerState.surveyPending();
        customerState.passedSurvey();
        customerState.failedSurvey();
        customerState.failedInstall();
        customerState.installationInProgress();
        customerState.installationComplete();
        customerState.installationCommissioned();
        customerState.suspendedBilling();
        customerState.suspendedOverage();
        customerState.onPaymentPlan();
        customerState.onTransientPackage();
        customerState.cancelled();
        customerState.lost();

        Test.stopTest();
    }
    
}