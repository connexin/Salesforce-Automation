@isTest public class ResidentialBroadbandControllerTest extends AbstractTestCase {

    public static testMethod void testResidentialBroadbandController() {
        ResidentialBroadbandController controller = new ResidentialBroadbandController();
        assumeNotNull(controller);

        PageReference pageRef = controller.step1();
        Test.setCurrentPage(pageRef);

        controller.consumerPostcode = 'HU4 7DW';
        controller.step2();

        controller.consumerName = 'Alice Test';
        controller.step3();

        controller.consumerAddress = 'Address';
        controller.step4();
    }

}