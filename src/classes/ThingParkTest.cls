@isTest public class ThingParkTest {

	@isTest static void testAddTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.addTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

    @isTest static void testGetTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.getTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

    @isTest static void testUpdateTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.updateTenancy(new LoRaWAN_Tenancy__c()));

		Test.stopTest();
    }

	@isTest static void testAddOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.addOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }

    @isTest static void testGetOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.getOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        System.assert(ThingParkREST.updateOrder(new LoRaWAN_Package__c()));

		Test.stopTest();
    }
    
    private static ThingParkDxRestMock createMock() {        
		// Create the mock response based on a static resource
        // WebServiceMock mock = new ThingParkDxRestMock();
		// Test.setMock(WebServiceMock.class, mock);        
        // mock.setStatusCode(200);
        // mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // return mock;
        return new ThingParkDxRestMock();
    }

}