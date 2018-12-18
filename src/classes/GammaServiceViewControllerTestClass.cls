@isTest
public class GammaServiceViewControllerTestClass {

    static testMethod void testUpdateMain () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateMainResp = new MultiStaticResourceCalloutMock();
        mockUpdateMainResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateMainResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/tariff?iccid=1111111111111111111', 'staticSimActivation');
        mockUpdateMainResp.setHeader('content-type', 'application/xml');
        mockUpdateMainResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateMainResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        controller.tariffUpdated = true;
        controller.updatedtariff = 'BUSINESS_EXTRA';
        controller.mobileClass.msisdn.value = mobile.Msisdn__c;
        controller.mobileClass.iccid = mobile.Iccid__c;
        controller.updateMain();
        Test.stopTest();
    }
    
    static testMethod void testUpdateServices () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateServicesResp = new MultiStaticResourceCalloutMock();
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/services?iccid=1111111111111111111', 'staticUpdateServices');
        mockUpdateServicesResp.setHeader('content-type', 'application/xml');
        mockUpdateServicesResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateServicesResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        controller.mobileData = true;
        controller.intlCallingService = true;
        controller.intlRoamingService = true;
        controller.premiumService = true;
        controller.dataRoamingService = true;
        controller.updateServices();
        
        Test.stopTest();
    }
    
    static testMethod void testUpdateBoltons () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateServicesResp = new MultiStaticResourceCalloutMock();
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/bolton?iccid=1111111111111111111', 'staticUpdateBoltons');
        mockUpdateServicesResp.setHeader('content-type', 'application/xml');
        mockUpdateServicesResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateServicesResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        controller.sms250 = true;
        controller.smartBusinessPack = true;
        controller.euDailyBusinessTraveller = true;
        controller.rowBusiness7DayTraveller = true;
        controller.intlVoiceEuNa = true;
        controller.intlVoiceRow = true;
        controller.worldWideData = true;
        controller.multiNet = true;
        controller.dataSharer = true;
        controller.updateBoltOns();
        
        Test.stopTest();
    }
    
    static testMethod void testUpdateBarring () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateServicesResp = new MultiStaticResourceCalloutMock();
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/barring?iccid=1111111111111111111', 'staticUpdateBarring');
        mockUpdateServicesResp.setHeader('content-type', 'application/xml');
        mockUpdateServicesResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateServicesResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        controller.barVoicemail = true;
        controller.barIncomingCalls = true;
        controller.barOutgoingCalls = true;
        controller.barSendSms = true;
        controller.barReceiveSms = true;
        controller.barSendMms = true;
        controller.barReceiveMms = true;
        controller.updateBarring();
        
        Test.stopTest();
    }
    
    static testMethod void testUpdateRoamingConfig () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateServicesResp = new MultiStaticResourceCalloutMock();
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/roaming?iccid=1111111111111111111', 'staticUpdateRoamingConfig');
        mockUpdateServicesResp.setHeader('content-type', 'application/xml');
        mockUpdateServicesResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateServicesResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        controller.euRoamingMaxCharge = 'MC_004_4';
        controller.rowRoamingMaxCharge = 'MC_550_0';
        controller.notifyDataCap = true;
        controller.notifyInitialData = true;
        controller.notify80PercentDataReached = true;
        controller.updateRoamingConfig();
        
        Test.stopTest();
    }
    
    static testMethod void testMisc () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.AccountId = a.Id;
        insert c;
        
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        mobile.Iccid__c = '1111111111111111111';
        mobile.Msisdn__c = '000000000000';
        mobile.Status__c = 'Active';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        MultiStaticResourceCalloutMock mockUpdateServicesResp = new MultiStaticResourceCalloutMock();
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=000000000000', 'staticSearchSim');
        mockUpdateServicesResp.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/roaming?iccid=1111111111111111111', 'staticUpdateRoamingConfig');
        mockUpdateServicesResp.setHeader('content-type', 'application/xml');
        mockUpdateServicesResp.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockUpdateServicesResp);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileServiceViewController controller = new GammaMobileServiceViewController(stdController);
        PageReference pg;
        pg = controller.cancelUpdate();
        system.assertEquals('/apex/GammaMobile_ProvisionList', pg.getUrl());
        
        pg = controller.reload();
        system.assertEquals('/apex/GammaMobile_ServiceView?id=' + controller.mobileObj.Id, pg.getUrl());
        
        Test.stopTest();
    }
    
}