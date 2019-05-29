@isTest
public class GammaMobileControllerTestClass {

    static testMethod void testProvisioning () {
        
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
        
        Gamma_Mobile__c currentMobile = new Gamma_Mobile__c();
        currentMobile.Iccid__c = '2222222222222222222';
        currentMobile.Msisdn__c = '333333333333';
        currentMobile.Status__c = 'Provisioned';
        currentMobile.Contact__c = c.Id;
        insert currentMobile;
        
        Test.startTest();
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        
        //Test duplicate iccid value
        controller.mobileObj.Iccid__c = currentMobile.Iccid__c;
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        PageReference pg;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg);
        
        //Test duplicate msisdn value
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = currentMobile.Msisdn__c;
		controller.mobileObj.Contact__c = c.Id;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg);  
        
        //Test iccid alpha numeric test contact
        controller.mobileObj.Iccid__c = '1111111111111a1111Aa';
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg); 
        
        //Test msisdn alpha numeric test contact
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = '000000000a00Aa';
		controller.mobileObj.Contact__c = c.Id;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg); 
        
        //Test iccid length test contact
        controller.mobileObj.Iccid__c = '';
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg); 
        
        //Test msisdn length test contact
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = '';
		controller.mobileObj.Contact__c = c.Id;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg); 
        
        //Test provision correctly
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        controller.mobileClass.provision.tariff.tariffType.selectedTariffType = 'BUSINESS_EXTRA';
        controller.mobileData = true;
        controller.intlCallingService = true;
        controller.intlRoamingService = true;
        controller.dataRoamingService = true;
        controller.premiumService = true;
        controller.rowRoaming = true;
        controller.smartBusinessPack = true;
        controller.intlVoiceEuNa = true;
        controller.intlVoiceRow = true;
        controller.worldWideData = true;
        controller.multinet = true;
        
        MultiStaticResourceCalloutMock mockProvisionMulti = new MultiStaticResourceCalloutMock();
        mockProvisionMulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/company?clientId=2469&maxResults=100&name=' + a.Id, 'staticSearchCompany');
        mockProvisionMulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/provision?iccid=1111111111111111111', 'staticProvision');
        mockProvisionMulti.setHeader('content-type', 'application/xml');
        mockProvisionMulti.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockProvisionMulti);
        pg = controller.configProvisionRequest();
        system.assertEquals('/apex/GammaMobile_ProvisionList', pg.getUrl());
        Test.stopTest();
    }
    
    static testMethod void testProvisioning2 () {
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
        
        Test.startTest();
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        controller.mobileClass.provision.tariff.tariffType.selectedTariffType = 'MOBILE_BROADBAND';
        controller.ukDataBolton = '3 GB Data PCM';
        controller.mobileData = true;
        controller.intlCallingService = true;
        controller.intlRoamingService = true;
        controller.dataRoamingService = true;
        controller.premiumService = true;
        controller.rowRoaming = true;
        controller.smartBusinessPack = true;
        controller.intlVoiceEuNa = true;
        controller.intlVoiceRow = true;
        controller.worldWideData = true;
        controller.multinet = true;
        
        MultiStaticResourceCalloutMock mockProvisionMulti = new MultiStaticResourceCalloutMock();
        mockProvisionMulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/company?clientId=2469&maxResults=100&name=' + a.Id, 'staticSearchCompany');
        mockProvisionMulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/provision?iccid=1111111111111111111', 'staticProvisionFailed');
        mockProvisionMulti.setStatusCode(200);
        mockProvisionMulti.setHeader('content-type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mockProvisionMulti);
        PageReference pg;
        pg = controller.configProvisionRequest();
        system.assertEquals(null, pg);
        
        controller.mobileObj.Iccid__c = '1111111111111111111';
        controller.mobileObj.Msisdn__c = '000000000000';
		controller.mobileObj.Contact__c = c.Id;
        controller.mobileClass.provision.tariff.tariffType.selectedTariffType = 'MOBILE_BROADBAND';
        controller.ukDataBolton = '3 GB Data PCM';
        controller.mobileData = true;
        controller.intlCallingService = false;
        controller.intlRoamingService = false;
        controller.dataRoamingService = false;
        controller.premiumService = false;
        controller.rowRoaming = false;
        controller.smartBusinessPack = false;
        controller.intlVoiceEuNa = false;
        controller.intlVoiceRow = false;
        controller.worldWideData = false;
        controller.multinet = false;
        
        MultiStaticResourceCalloutMock mockProvisionMultiSuccess = new MultiStaticResourceCalloutMock();
        mockProvisionMultiSuccess.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/company?clientId=2469&maxResults=100&name=' + a.Id, 'staticSearchCompany');
        mockProvisionMultiSuccess.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/000000000000/provision?iccid=1111111111111111111', 'staticProvision');
        mockProvisionMultiSuccess.setStatusCode(200);
        mockProvisionMultiSuccess.setHeader('content-type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mockProvisionMultiSuccess);
        
        pg = controller.configProvisionRequest();
        system.assertEquals('/apex/GammaMobile_ProvisionList', pg.getUrl());
        Test.stopTest();
    }
    
    static testMethod void testActivateSim () {
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
        mobile.Status__c = 'Provisioned';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        PageReference pg;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        controller.activateProvisionIccidVal = mobile.Iccid__c;
        controller.activateProvisionMsisdnVal = mobile.Msisdn__c;
        
        MultiStaticResourceCalloutMock mockActivateMulti = new MultiStaticResourceCalloutMock();
        mockActivateMulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services?clientId=2469&msisdn=' + mobile.Msisdn__c, 'staticSearviceSearchPendingSim');
        mockActivatemulti.setStaticResource('https://ws-test.gammaoperations.com/mobile/v3/rest/services/' + mobile.Msisdn__c + '/activate?iccid=' + mobile.Iccid__c, 'staticServiceActivatePending');
        mockActivateMulti.setHeader('content-type', 'application/xml');
        mockActivateMulti.setStatusCode(200);
        Test.setMock(HttpCalloutMock.class, mockActivateMulti);
        
        pg = controller.activateSim();
        system.assertEquals(null, pg);
        Test.stopTest();
    }
    
    static testMethod void testCancelProvision () {
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
        mobile.Status__c = 'Provisioned';
        mobile.Contact__c = c.Id;
        insert mobile;
        
        Test.startTest();
        PageReference pg;
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        pg = controller.cancelProvision();
        system.assertEquals(null, pg);
        
        controller.delProvisionIccidVal = '1234567890';
        controller.delProvisionMsisdnVal = '1234567890';
        
        pg = controller.cancelProvision();
        system.assertEquals(null, pg);
        
        controller.delProvisionIccidVal = mobile.Iccid__c;
        controller.delProvisionMsisdnVal = mobile.Msisdn__c;
        
        StaticResourceCalloutMock mockDelSimResp = new StaticResourceCalloutMock();
        mockDelSimResp.setStaticResource('staticProvisionDel');
        mockDelSimResp.setStatusCode(204);
        mockDelSimResp.setHeader('content-type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mockDelSimResp);
        
        pg = controller.cancelProvision();
        system.assertEquals(null, pg);
        Test.stopTest();
        
    }
    
    static testMethod void testSearchSim ()  {
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
        
        Test.startTest();
        Gamma_Mobile__c mobile = new Gamma_Mobile__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        
        controller.searchMobile = ''; controller.searchIccid = ''; controller.mobileObj.Contact__c = null;
        controller.searchSims();
        controller.searchMobile = ''; controller.searchIccid = ''; controller.mobileObj.Contact__c = c.Id;
        controller.searchSims();
        controller.searchMobile = ''; controller.searchIccid = '123456789'; controller.mobileObj.Contact__c = null;
        controller.searchSims();
        controller.searchMobile = ''; controller.searchIccid = '123456789'; controller.mobileObj.Contact__c = c.Id;
        controller.searchSims();
        controller.searchMobile = '123456789'; controller.searchIccid = ''; controller.mobileObj.Contact__c = null;
        controller.searchSims();
        controller.searchMobile = '123456789'; controller.searchIccid = ''; controller.mobileObj.Contact__c = c.Id;
        controller.searchSims();
        controller.searchMobile = '123456789'; controller.searchIccid = '123456789'; controller.mobileObj.Contact__c = null;
        controller.searchSims();
        controller.searchMobile = '123456789'; controller.searchIccid = '123456789'; controller.mobileObj.Contact__c = c.Id;
        controller.searchSims();
        controller.clearSearch();
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
        ApexPages.StandardController stdController = new ApexPages.StandardController(mobile);
        GammaMobileController controller = new GammaMobileController(stdController);
        PageReference pg;
        
        //Test Update SIM
        controller.acctId = mobile.Id;   
        pg = controller.updateSim();
        system.assertEquals('/apex/GammaMobile_ServiceView?id=' + mobile.Id, pg.getUrl());
        
        //Test cancel provision in the middle
        pg = controller.cancelNewProvision();
        system.assertEquals('/apex/GammaMobile_ProvisionList', pg.getUrl());
        
        //Test new Provision
        pg = controller.newProvision();
        system.assertEquals('/apex/GammaMobile_NewOrder', pg.getUrl());
        
        //Test to get used msisdn list
        List<String> usedMsisdns = controller.getMsisdnUsedList();
        List<String> usedIccids = controller.getIccidUsedList(); 
        
        StaticResourceCalloutMock mockMsisdnListResp = new StaticResourceCalloutMock();
        mockMsisdnListResp.setStaticResource('staticMsisdnList');
        mockMsisdnListResp.setStatusCode(200);
        mockMsisdnListResp.setHeader('content-type', 'application/xml');
        
        StaticResourceCalloutMock mockIccidListResp = new StaticResourceCalloutMock();
        mockIccidListResp.setStaticResource('staticIccidList');
        mockIccidListResp.setStatusCode(200);
        mockIccidListResp.setHeader('content-type', 'application/xml');
        
        Test.setMock(HttpCalloutMock.class, mockMsisdnListResp);
        List<String> msisdnList = controller.getMsisdnList();
        
        Test.setMock(HttpCalloutMock.class, mockIccidListResp);
        List<String> iccidList = controller.getIccidList();
        
        Test.stopTest();
    }
}