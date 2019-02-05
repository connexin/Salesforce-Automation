@isTest public class ThingParkRestTest extends AbstractThingParkTestCase {

    @isTest static void testAddTenancy() {
        Test.startTest();

        assumeNotNull(createMock());

        // Given the expected data to create tenancy        
        ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());

        System.debug('lorawanTenancy.primaryContact.FirstName : ' + expectedDataManager.primaryContact.FirstName);
        System.debug('lorawanTenancy.primaryContact.LastName : ' + expectedDataManager.primaryContact.LastName);
        System.debug('lorawanTenancy.primaryContact.Email : ' + expectedDataManager.primaryContact.Email);
        System.debug('lorawanTenancy.account.Name : ' + expectedDataManager.account.Name);
        System.debug('lorawanTenancy.account.Id : ' + expectedDataManager.account.Id);

        // And Given the required json from the expected data
        final ThingParkSubscriberJson thingParkSubscriber = new ThingParkSubscriberJson(expectedDataManager.primaryContact.FirstName,
                                                                                  expectedDataManager.primaryContact.LastName,
                                                                                  expectedDataManager.primaryContact.Email,
                                                                                  expectedDataManager.account.Name,
                                                                                  expectedDataManager.account.Id,
                                                                                  RandomData.actiltyPolicyPassword());
        
        System.debug('thingParkSubscriber : ' + thingParkSubscriber);
        Final String subscriberJson = thingParkSubscriber.toJson();
        System.debug('testAddTenancy.subscriberJson : ' + subscriberJson);
        
        // When we add the tenancy
        final String tenancyId = expectedDataManager.lorawanTenancy.id;
        ThingParkRest.addSubscriber(tenancyId, subscriberJson);

        Test.stopTest();
    }
    
    @isTest static void testGetTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        ThingParkRest.getSubscriber('8888','88888');
        
        Test.stopTest();
    }
    
    @isTest static void testUpdateTenancy() {
        Test.startTest();
        
        assumeNotNull(createMock());
        
        // Given the expected data to create tenancy        
        final ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());

        System.debug('lorawanTenancy.primaryContact.FirstName : ' + expectedDataManager.primaryContact.FirstName);
        System.debug('lorawanTenancy.primaryContact.LastName : ' + expectedDataManager.primaryContact.LastName);
        System.debug('lorawanTenancy.primaryContact.Email : ' + expectedDataManager.primaryContact.Email);
        System.debug('lorawanTenancy.account.Name : ' + expectedDataManager.account.Name);
        System.debug('lorawanTenancy.account.Id : ' + expectedDataManager.account.Id);

        // And Given the required json from the expected data
        final ThingParkSubscriberJson thingParkSubscriber = new ThingParkSubscriberJson(expectedDataManager.primaryContact.FirstName,
                                                                                  expectedDataManager.primaryContact.LastName,
                                                                                  expectedDataManager.primaryContact.Email,
                                                                                  expectedDataManager.account.Name,
                                                                                  expectedDataManager.account.Id,
                                                                                  RandomData.actiltyPolicyPassword());

        ThingParkRest.updateSubscriber('88888', thingParkSubscriber.toJson());

        Test.stopTest();
    }
    
    @isTest static void testAddOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        // Given the expected data to create tenancy        
        final ExpectedDataManager expectedDataManager = new ExpectedDataManager();
        assumeNotNull(expectedDataManager.givenThingParkCustomer());
        assumeNotNull(expectedDataManager.givenThingParkTenancy());
        assumeNotNull(expectedDataManager.givenThingParkPackage());

        System.debug('lorawanPackage : ' + expectedDataManager.lorawanPackage);
        final String subscriberId = expectedDataManager.lorawanTenancy.Actility_Subscriber_ID__c;
        System.debug('lorawanPackage.subscriberId : ' + subscriberId);

        final ThingParkOrderJson thingParkOrder = new ThingParkOrderJson('connexin-vdr/test-offer', subscriberId); 
        System.debug('thingParkOrder : ' + thingParkOrder);

        final String orderJson = thingParkOrder.toJson();
        System.debug('testAddOrder.orderJson : ' + orderJson);

        final String orderId = expectedDataManager.lorawanPackage.id;
        ThingParkRest.addOrder(orderId, orderJson);

        Test.stopTest();
    }

    @isTest static void testGetOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        ThingParkRest.getOrder('8888', 'connexin-vdr/test-offer');

        Test.stopTest();
    }

    @isTest static void testUpdateOrder() {
        Test.startTest();

        assumeNotNull(createMock());

        ThingParkRest.updateOrder('8888', 'connexin-vdr/test-starter-kit');

        Test.stopTest();
    }
    
}