@isTest
public class GammaMobileTestClass {

    static testMethod void testCreateCompany () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        
        GammaMobile mobile = new GammaMobile();
        mobile.addCompany();
        GammaMobile_Company company = new GammaMobile_Company();
        company.name = 'Test';
        company.externalReference = '123';
        company.address.thoroughfareNumber = '123';
        company.address.thoroughfareName = '123';
        company.address.town = '123';
        company.address.county = '123';
        company.address.postcode = '123';
        
        company.contact.name = 'test';
        company.contact.emailAddress = 'riz@connexin.co.uk';
        company.contact.phoneNumber = '123456789';
        
        company.channelPartner.name = 'channel partner';
        mobile.company = company;
        
        Test.startTest();
        StaticResourceCalloutMock mockAddCompanyResp = new StaticResourceCalloutMock();
        mockAddCompanyResp.setStaticResource('staticAddCompany');
        mockAddCompanyResp.setStatusCode(200);
        mockAddCompanyResp.setHeader('content-type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mockAddCompanyResp);
        mobile.addCompany();
        Test.stopTest();
        
    }
    
    static testMethod void testChangeTariff () {
        GammaMobileAPI__c settings = new GammaMobileAPI__c(Name = 'default', BaseURL__c = 'https://ws-test.gammaoperations.com', Username__c = 'connexinTRWSUser', Password__c = 'GjcWn00rxk', ClientId__c = '2469', ServiceURL__c = '/mobile/v3/rest/services', CompanyURL__c = '/mobile/v3/rest/company', PasswordHash__c = 'Y29ubmV4aW5UUldTVXNlcjpHamNXbjAwcnhr', MsisdnUrl__c = '/mobile/v3/rest/msisdn', UsimURL__c = '/mobile/v3/rest/usim', DomainURL__c = 'http://www.gamma.co.uk/mobile/api/domain');
        insert settings;
        
        GammaMobile mobile = new GammaMobile();
        mobile.mobileServiceChangeTariff();
        mobile.iccid = '1111111111111111111';
        mobile.msisdn.value = '000000000000';
        mobile.service.tariff.tariffType.selectedTariffType = 'BUSINESS_EXTRA';
        
        Test.startTest();
        
        StaticResourceCalloutMock mockAddCompanyResp = new StaticResourceCalloutMock();
        mockAddCompanyResp.setStaticResource('staticChangeTariff');
        mockAddCompanyResp.setStatusCode(200);
        mockAddCompanyResp.setHeader('content-type', 'application/xml');
        Test.setMock(HttpCalloutMock.class, mockAddCompanyResp);
        mobile.mobileServiceChangeTariff();
        
        Test.stopTest();
    }
    
    static testMethod void testRefData () {
        Map<String, String> testMap = new Map<String, String>();
        testMap = GammaMobile_ReferenceData.refAdvancedFundingType;
        testMap = GammaMobile_ReferenceData.refBoltOn;
        testMap = GammaMobile_ReferenceData.refBoltOn_Business;
        testMap = GammaMobile_ReferenceData.refBoltOn_Data;
        testMap = GammaMobile_ReferenceData.refCallForward;
        testMap = GammaMobile_ReferenceData.refEuRoamingMaxCharge;
        testMap = GammaMobile_ReferenceData.refMsisdnStatus;
        testMap = GammaMobile_ReferenceData.refNetworkBar;
        testMap = GammaMobile_ReferenceData.refNetworkService;
        testMap = GammaMobile_ReferenceData.refNotificationOption;
        testMap = GammaMobile_ReferenceData.refNotificationOption;
        testMap = GammaMobile_ReferenceData.refOperator;
        testMap = GammaMobile_ReferenceData.refPortingStatus;
        testMap = GammaMobile_ReferenceData.refRepaymentPeriod;
        testMap = GammaMobile_ReferenceData.refRequestStatus;
        testMap = GammaMobile_ReferenceData.refRowRoamingMaxCharge;
        testMap = GammaMobile_ReferenceData.refServiceStatus;
        testMap = GammaMobile_ReferenceData.refTariffStatus;
        testMap = GammaMobile_ReferenceData.refTariffType;
        testMap = GammaMobile_ReferenceData.refUsimStatus;
        testMap = GammaMobile_ReferenceData.refUsimType;
        String tmp = GammaMobile_ReferenceData.xsd_url;
    }
    
    static testMethod void testMisc () {
        GammaMobile_RequestStatus rs = new GammaMobile_RequestStatus();
        rs.addRequestStatuses('Currently being processed');
        rs.addRequestStatuses('Currently being processed 123');
        
        GammaMobile_RepaymentPeriod rp = new GammaMobile_RepaymentPeriod();
        rp.addRepaymentPeriod('12 months');
        
        GammaMobile_CallForward cf = new GammaMobile_CallForward();
        cf.type = 'Busy';
        cf.setCallForward('Busy', '012345678900', true);
        cf.setCallForward('Busy', '012345678900', false);
        
        GammaMobile_TariffStatus ts = new GammaMobile_TariffStatus();
        ts.addTariffStatus('Tariff is active');
        
        GammaMobile_EuRoamingMaxCharge eurmc = new GammaMobile_EuRoamingMaxCharge();
        eurmc.addEuRoamingMaxCharge('0.044p charged per MB roamed in EU');
        
        GammaMobile_Operator opr = new GammaMobile_Operator();
        opr.addOperator('Assigned to the Gamma Network Operator');
        
        GammaMobile_NotificationOption no = new GammaMobile_NotificationOption();
        no.addNotificationOption('Initial Data Notification message');
        
        GammaMobile_RowRoamingMaxCharge rowrmc = new GammaMobile_RowRoamingMaxCharge();
        rowrmc.addRoamingMaxCharge('£6.50 charged per MB roamed when outside EU (ROW)');
        
        GammaMobile_UsimType ut = new GammaMobile_UsimType();
        ut.addUsimType('Smaller version of a micro SIM card');
        
        GammaMobile_TariffType tt = new GammaMobile_TariffType();
        tt.addTariffType('The Mobile Broadband (data only) tariff');
        
        GammaMobile_ServiceStatus ss = new GammaMobile_ServiceStatus();
        ss.addServiceStatus('A request for this service is currently being processed');
        
        GammaMobile_MsisdnStatus ms = new GammaMobile_MsisdnStatus();
        ms.addMsisdnStatus('MSISDN has been quarantined on the Gamma network');
        
        GammaMobile_PortingStatus ps = new GammaMobile_PortingStatus();
        ps.addPortingStatus('Port Out has been locked automatically on MNP');
        
        GammaMobile_UsimStatus us = new GammaMobile_UsimStatus();
        us.addUsimStatus('Assigned to a live Gamma service');
        
        GammaMobile_AdvancedFundingType aft = new GammaMobile_AdvancedFundingType();
        aft.addAdvancedFundingType('Level 2 hardware funding credit');
        
        GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
        nb.addNetworkBar('Send outgoing MMS messages');
        
    }
}