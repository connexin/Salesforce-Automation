@isTest
private class GoCardlessAPITestClass {

    static testMethod void testApi() {
        Test.setMock(HttpCalloutMock.class, new GoCardlessMockHttpResponseGenerator());
        
    	Go_Cardless__c setting = new Go_Cardless__c(Name = 'default', Api_Url__c = 'url', Api_Token__c = 'token', Api_Version__c = 'version');
    	insert setting;
    	
    	Test.startTest();
    	
    	GoCardlessAPI.getBankAccount('BA0001');
        GoCardlessAPI.getCustomerBankAccounts('CU0001');
        GoCardlessAPI.getCustomerPayments('CU0001');
        GoCardlessAPI.getCustomerRefunds('PM0001');
        GoCardlessAPI.getCustomerBankAccountMandates('BA0001');
        GoCardlessAPI.disableCustomerBankAccount('BA0001');
        GoCardlessAPI.getCustomerMandates('CU0001');
        GoCardlessAPI.isValidGoCardlessID('CU0001');
        GoCardlessAPI.getCustomerBankAccountMandates('BA0001');
        GoCardlessAPI.createCustomerPayment('CU0001', 5, 'test', null);
        GoCardlessAPI.createCustomerRefund('PM0001', 5, 'test');
        
        Test.stopTest();
    }
}