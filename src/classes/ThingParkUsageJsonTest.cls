@IsTest public class ThingParkUsageJsonTest extends AbstractTestCase {
	private static String jsonInput = '{'+
		'  \"accountId\": \"001n000000TylkYAAR\",'+
		'  \"subscriptionId\": \"subscription_id\",'+
		'  \"description\": \"ThingParkUsageJson unit test\",'+
		'  \"referencePeriod\": \"2019-01\",'+
		'  \"actionDate\": \"2019-02-13\",'+
		'  \"package_usage\": {'+
		'    \"productId\": \"LORAWAN01\",'+
		'    \"packageId\": \"packageId\",'+
		'    \"description\": \"ThingParkUsageJson package line\",'+
		'    \"activeDevices\": 200,'+
		'    \"label\": \"lorawan package\"'+
		'  },'+
		'  \"message_usage\": {'+
		'    \"productId\": \"LORAWAN01\",'+
		'    \"packageId\": \"packageId\",'+
		'    \"description\": \"ThingParkUsageJson messages sent\",'+
		'    \"messageCount\": 100,'+
		'    \"label\": \"lorawan package\"'+
		'  },'+
		'  \"eol_usage\": {'+
		'    \"productId\": \"LORAWAN01\",'+
		'    \"packageId\": \"packageId\",'+
		'    \"description\": \"ThingParkUsageJson end of life messages sent\",'+
		'    \"messageCount\": 100,'+
		'    \"label\": \"lorawan package\"'+
		'  }'+
		'}';

	static testMethod void testParse() {
		ThingParkUsageJson jsonData = ThingParkUsageJson.parse(jsonInput);
		System.assert(jsonData != null);
        System.debug('jsonData : ' + jsonData);
        // final String newJsonStr = JSON.serialize(jsonData);
        // System.debug('newJsonStr : ' + newJsonStr);
        // assertEqual(jsonInput, newJsonStr);
	}
}