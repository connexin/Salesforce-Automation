@isTest public class ConsumerTest extends AbstractTestCase {

    @isTest static void testConsumer() {
		Test.startTest();

        assertNotNull(new Consumer());

		Test.stopTest();
    }
    
	@isTest static void testParse() {
		String json = '{'+
		'  \"Name\": \"\",'+
		'  \"Coverage_Check_Result__c\": \"\",'+
		'  \"Credit_Check_Result__c\": \"\",'+
		'  \"Customer_Name__c\": \"\",'+
		'  \"Customer_State__c\": \"\",'+
		'  \"Installation_Booking__c\": \"\",'+
		'  \"Lead__c\": \"\",'+
		'  \"Opportunity__c\": \"\",'+
		'  \"Postcode__c\": \"\",'+
		'  \"Product__c\": \"\",'+
		'  \"Special_Instructions__c\": \"\",'+
		'  \"Contract_Term__c\": \"\"'+
		'}';

		Consumer consumer = Consumer.parse(json);
		System.assert(consumer != null);
	}
    
}