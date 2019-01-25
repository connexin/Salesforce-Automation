@isTest public class ThingParkRestTest extends AbstractThingParkTestCase {
    
    @isTest static void testAddTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());
        System.debug('@@@lorawanTenancy : ' + expectedDataManager.primaryContact.FirstName);
        System.debug('@@@lorawanTenancy : ' + expectedDataManager.primaryContact.LastName);
        System.debug('@@@lorawanTenancy : ' + expectedDataManager.primaryContact.Email);
        System.debug('@@@lorawanTenancy : ' + expectedDataManager.account.Name);

        ThingParkSubscriberJson foo = new ThingParkSubscriberJson(expectedDataManager.primaryContact.FirstName,
                                                                  expectedDataManager.primaryContact.LastName,
                                                                  expectedDataManager.primaryContact.Email,
                                                                  expectedDataManager.account.Name,
                                                                  RandomData.actiltyPolicyPassword());
        String subscriberJson = foo.toJson();
        System.debug('testAddTenancy.subscriberJson : ' + subscriberJson);
        ThingParkRest.addTenancy(subscriberJson);
        
        Test.stopTest();
    }
    
    @isTest static void testGetTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.getTenancy('subscriberId');
        
        Test.stopTest();
    }
    
    @isTest static void testUpdateTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.updateTenancy('subscriberId');
        
        Test.stopTest();
    }
    
    @isTest static void testAddOrder() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        LoRaWAN_Package__c lorawanPackage = expectedDataManager.givenThingParkPackage();
        assertNotNull(lorawanPackage);
        System.debug('@@@lorawanPackage : ' + lorawanPackage);

        String orderJson = new ThingParkOrderJson('offerId','subscriberId').toJson();
        System.debug('testAddOrder.orderJson : ' + orderJson);
        
        ThingParkRest.addOrder(orderJson);
        
        Test.stopTest();
    }
    
    @isTest static void testGetOrder() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.getOrder('orderId');
        
        Test.stopTest();
    }
    
    @isTest static void testUpdateOrder() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.updateOrder('orderId');
        
        Test.stopTest();
    }
}