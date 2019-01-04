@isTest public class QueryMakerTest {

	@isTest static void testQueryMaker() {
		Test.startTest();

        QueryMaker params = new QueryMaker();
		System.assert(params != null);
    
        params.add('key=value');
        System.debug('params : ' + params);
        System.assertEquals('?key=value', params.asString());
        
        params.add('key','value');
        System.debug('params : ' + params);
        System.assertEquals('?key=value&key=value', params.asString());

		Test.stopTest();
    }

	@isTest static void testfluentQueryMaker() {
		Test.startTest();

		String parameters = new QueryMaker()
            .add('grant_type=client_credentials')
            .add('client_id', 'connexin-api')
            .add('client_secret', 'password')
            .asString();

        System.assertEquals('?grant_type=client_credentials&client_id=connexin-api&client_secret=password', parameters, 'actual : ' + parameters);
        
		Test.stopTest();
    }   
}