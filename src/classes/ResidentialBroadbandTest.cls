@isTest public class ResidentialBroadbandTest extends AbstractTestCase {

    @isTest static void testCreateResidentialBroadband() {
		Test.startTest();

        ResidentialBroadband customer = ResidentialBroadband.create('HU4 7DW','Unit Test Customer');
        assumeNotNull(customer);
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
    
    @isTest static void testFindResidentialBroadband() {
		Test.startTest();

        ResidentialBroadband customer = ResidentialBroadband.find('HU4 7DW','Unit Test Customer');
        assumeNotNull(customer);
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