@isTest public class ThingParkRestTest extends AbstractThingParkTestCase {
    
    @isTest static void testAddTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());
        
        System.debug('lorawanTenancy.primaryContact.FirstName : ' + expectedDataManager.primaryContact.FirstName);
        System.debug('lorawanTenancy.primaryContact.LastName : ' + expectedDataManager.primaryContact.LastName);
        System.debug('lorawanTenancy.primaryContact.Email : ' + expectedDataManager.primaryContact.Email);
        System.debug('lorawanTenancy.account.Name : ' + expectedDataManager.account.Name);
        System.debug('lorawanTenancy.account.Id : ' + expectedDataManager.account.Id);
        
        ThingParkSubscriberJson thingParkSubscriber = new ThingParkSubscriberJson(expectedDataManager.primaryContact.FirstName,
                                                                                  expectedDataManager.primaryContact.LastName,
                                                                                  expectedDataManager.primaryContact.Email,
                                                                                  expectedDataManager.account.Name,
                                                                                  expectedDataManager.account.Id,
                                                                                  RandomData.actiltyPolicyPassword());
        
        System.debug('thingParkSubscriber : ' + thingParkSubscriber);
        Final String subscriberJson = thingParkSubscriber.toJson();
        System.debug('testAddTenancy.subscriberJson : ' + subscriberJson);
        ThingParkRest.addTenancy(subscriberJson);
        
        Test.stopTest();
    }
    
    @isTest static void testGetTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.getTenancy('88888');
        
        Test.stopTest();
    }
    
    @isTest static void testUpdateTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.updateTenancy('88888');

        Test.stopTest();
    }
    
    @isTest static void testAddOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());
        assumeNotNull(expectedDataManager.givenThingParkPackage());

        System.debug('lorawanPackage : ' + expectedDataManager.lorawanPackage);
        System.debug('lorawanPackage.Actility_Subscription_ID__c : ' + expectedDataManager.lorawanPackage.Actility_Subscription_ID__c);

        ThingParkOrderJson thingParkOrder = new ThingParkOrderJson('connexin-vdr/test-offer', 
                                                                   expectedDataManager.lorawanPackage.Actility_Subscription_ID__c);

        System.debug('thingParkOrder : ' + thingParkOrder);
        String orderJson = new ThingParkOrderJson().toJson();
        System.debug('testAddOrder.orderJson : ' + orderJson);

        ThingParkRest.addOrder(orderJson);

        Test.stopTest();
    }

    @isTest static void testGetOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        ThingParkRest.getOrder('connexin-vdr/test-offer');

        Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        ThingParkRest.updateOrder('connexin-vdr/tpw-starter-kit');

        Test.stopTest();
    }
}