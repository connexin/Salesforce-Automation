@IsTest public class ThingParkInvoiceJsonTest extends AbstractTestCase {
	private static String jsonInput = '{ ' +
        '"accountId": "001n000000TylkYAAR", ' +
		'"description": "ThingPark Invoice Json Unit Test", ' +
		'"referencePeriod": "2019-02", ' +
		'"actionDate": "2019-03-31", ' +
	    '"lines":[' +
		'	{ "productId": "lorawan-01", "description": "service","qty": "1","unit_price": "2.00"},' +
		'	{ "productId": "lorawan-01", "description": "devices","qty": "2","unit_price": "2.00"},' +
		'	{ "productId": "lorawan-01", "description": "overage","qty": "3","unit_price": "2.00"}]} ';

	static testMethod void testParse() {
		ThingParkInvoiceJson jsonData = ThingParkInvoiceJson.parse(jsonInput);
		System.assert(jsonData != null);
        System.debug('jsonData : ' + jsonData);
        // final String newJsonStr = JSON.serialize(jsonData);
        // System.debug('newJsonStr : ' + newJsonStr);
        // assertEqual(jsonInput, newJsonStr);
	}
}