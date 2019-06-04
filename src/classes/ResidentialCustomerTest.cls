@isTest public class ResidentialCustomerTest extends AbstractTestCase {

    @isTest static void testResidentialCustomer() {
		Test.startTest();

        ResidentialCustomer customer = new ResidentialCustomer();
        assertNotNull(customer);
        customer.toLog();

        customer.failedCoverage();
        customer.passedCoverage();
        customer.failedCredit();
        customer.passedCredit();
        customer.depositTaken();
        customer.installationBooked();
        customer.passedSurvey();
        customer.installationInProgress();
        customer.installationComplete();
        customer.installationCommissioned();

		Test.stopTest();
    }

}