@isTest public class LoggingRestMockTest extends AbstractTestCase {

    static final String baseUrl = 'http://test.example.com';
    static private List<String> resources = new List<String> {
        '/admin/latest/api/oauth/token',
        '/admin/latest/api/oauth/revoke_token',
        '/admin/latest/api/oauth/tokeninfo',
        '/admin/latest/api/oauth/token',
        '/admin/latest/api//profiles',
        '/core/latest/api/subscribers/',
        '/core/latest/api/offers/',
        '/core/latest/api/orders/',
        '/core/latest/api/users'
		};

	@isTest static void testLoggingMockWithGet() {
        Test.startTest();

        LoggingRestMock mock = createMock();

        for(String endpoint : resources) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + endpoint);
            request.setMethod('GET');
            Http http = new Http();
            HttpResponse response = http.send(request);
            String jsonData = response.getBody();
            System.debug(response.toString());
            System.debug(response.getBody());
        }

		System.debug('mock : ' + mock);

		Test.stopTest();
    }

	@isTest static void testLoggingMockWithPost() {
        Test.startTest();

        LoggingRestMock mock = createMock();

        for(String endpoint : resources) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(baseUrl + endpoint);
            request.setMethod('POST');
            Http http = new Http();
            HttpResponse response = http.send(request);
            String jsonData = response.getBody();
            System.debug(response.toString());
            System.debug(response.getBody());
        }

		System.debug('mock : ' + mock);

		Test.stopTest();
    }

	@isTest static void testThingParkWithCallout() {

        Test.startTest();

         LoggingRestMock mock = createMock();
       
        for(String path : resources) {
            System.debug('path : ' + path);
            String endpoint = 'callout:thingpark' + path;
            System.debug('endpoint : ' + endpoint);

			HttpRequest request = new HttpRequest();
			// 'callout:thingpark/some_path'
			request.setEndpoint(endpoint);
			request.setMethod('GET');

            Http http = new Http();
            HTTPResponse response = http.send(request);
            System.debug(response.toString());
            System.debug(response.getBody());
        }

		System.debug('mock : ' + mock);

		Test.stopTest();
    }

    private static LoggingRestMock createMock() {
        LoggingRestMock mock = new LoggingRestMock();
		Test.setMock(HttpCalloutMock.class, mock);
        return mock;
    }
    
}