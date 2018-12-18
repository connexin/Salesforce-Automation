@isTest public class ThingParkTest {

    @isTest static void testMakeDxGetRequest() {
		Test.startTest();
        createMock();

        // HttpResponse result = ThingParkREST.makeDxGetRequest();
        // System.assertEquals(200, result.getStatusCode(), 'Expected 200 status code.');

		Test.stopTest();
    }

    @isTest static void makeDxPostRequest() {
		Test.startTest();
		createMock();

        // HttpResponse result = ThingParkREST.makeDxPostRequest();
        // System.assertEquals(201, result.getStatusCode(), 'Expected 201 status code.');
        
		Test.stopTest();
    }
 
    static void createMock() {
		Test.setMock(WebServiceMock.class, new ThingParkDxRestMock());        
        
		// Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ThingParkREST');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    }

}