@isTest public class ThingParkTest {

	@isTest static void testAddTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.addTenancy(new LoRaWAN_Tenancy__c());
		System.assertEquals(201, result.getStatusCode(), 'Expected 201 status code.');

		Test.stopTest();
    }

    @isTest static void testGetTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.getTenancy(new LoRaWAN_Tenancy__c());
        System.assertEquals(200, result.getStatusCode(), 'Expected 200 status code.');

		Test.stopTest();
    }

    @isTest static void testUpdateTenancy() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.updateTenancy(new LoRaWAN_Tenancy__c());
        System.assertEquals(200, result.getStatusCode(), 'Expected 200 status code.');

		Test.stopTest();
    }

	@isTest static void testAddOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.addOrder(new LoRaWAN_Package__c());
		System.assertEquals(201, result.getStatusCode(), 'Expected 201 status code.');

		Test.stopTest();
    }

    @isTest static void testGetOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.getOrder(new LoRaWAN_Package__c());
        System.assertEquals(200, result.getStatusCode(), 'Expected 200 status code.');

		Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
		Test.startTest();
		ThingParkDxRestMock mock = createMock();

        HttpResponse result = ThingParkREST.updateOrder(new LoRaWAN_Package__c());
        System.assertEquals(200, result.getStatusCode(), 'Expected 200 status code.');

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