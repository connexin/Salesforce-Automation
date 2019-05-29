public class GammaMobile {
    public Boolean serviceCeaseEnabled {get; set;}
    public GammaMobile_ReferenceData refData {get; set;}
    public GammaMobile_Service service {get; set;}
    public GammaMobile_Provision provision {get; set;}
    public GammaMobile_Company company {get; set;}
    public Contact sfContact {get; set;}
    public String iccid {get; set;}
    public GammaMobile_Msisdn msisdn {get; set;}
    public GammaMobile_Response gammaResponse {get; set;}
    //public String imei;
    
    private static String companyNamespace { 
        get {
            return 'http://www.gamma.co.uk/mobile/api/domain';
        }
    }
    
    private static String serviceNamespace {
        get {
            return 'http://www.gamma.co.uk/mobile/api';
        }
    }
    
    
    public GammaMobile () {
        this.serviceCeaseEnabled = false;
        this.msisdn = new GammaMobile_Msisdn();
        this.provision = new GammaMobile_Provision();
        this.service = new GammaMobile_Service();
        this.company = new GammaMobile_Company();
        this.msisdn = new GammaMobile_Msisdn();
        this.gammaResponse = new GammaMobile_Response();
        this.iccid = '';
        
    }
    
    public GammaMobile_Response addCompany () {
        this.gammaResponse = new GammaMobile_Response();
        if(this.company == null || this.company.name == '' || this.company.contact.name == '') {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Missing required Data';
            return gammaResponse;
        }
        
        String xmlString = this.createCompanyXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        this.sendHttpRequest(xmlString, 'POST', GammaMobileAPI__c.getValues('default').CompanyURL__c + '/' + GammaMobileAPI__c.getValues('default').ClientId__c);
        
        return this.gammaResponse;
    }
    
    /*public String updateCompany () {
        if(this.company == null || this.company.name == '' || this.company.contact.name == '') {
            return null;
        }
        
        String xmlString = this.createCompanyXml();
        
        if (xmlString == null) {
            return null;
        }
        
        //TODO
        //Verify Company XML definition
        
        HttpResponse res = this.sendHttpRequest(xmlString, 'PUT', GammaMobileAPI__c.getValues('default').CompanyURL__c + GammaMobileAPI__c.getValues('default').ClientId__c + '/' + this.company.name);
        
        if (res == null) {
            return null;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return null;
        }
        
        return collection.getAttribute('id', null);
    }
    
    public String deleteCompany () {
        if (this.companyName == null || this.companyContact.name == '' || this.companyAddress == null) {
            return null;
        }
        
        HttpResponse res = this.sendHttpRequest(null, 'DELETE', GammaMobileAPI__c.getValues('default').CompanyURL__c + GammaMobileAPI__c.getValues('default').ClientId__c + '/' + this.companyName);
        
        if (res == null) {
            return null;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return null;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return null;
        }
        
        return collection.getAttribute('id', null);
    }*/
    
    public GammaMobile_Response mobileProvisionNew () {
        this.gammaResponse = new GammaMobile_Response();
        /*if(this.provision.tariff.tarifftype.selectedTariffType == '' || this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Invalid Data';
            this.gammaResponse.errorMessage = 'Missing Required Data';
            return this.gammaResponse;
        }*/
        
        String xmlString = this.createProvisionXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Invalid Data';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return gammaResponse;
        }
        
        this.sendHttpRequest(xmlString, 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/provision?iccid=' + this.iccid);
        
        return this.gammaResponse;
    }
    
    public GammaMobile_Response mobileProvisionCancel () {
        this.gammaResponse = new GammaMobile_Response();
        /*if(this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Invalid Data';
            this.gammaResponse.errorMessage = 'Missing Required Data';
            return this.gammaResponse;
        }*/
        
        this.sendHttpRequest(null, 'DELETE', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' +this.msisdn.value + '/provision?iccid=' + this.iccid);
        
        if(this.gammaResponse.httpResponseCode == this.gammaResponse.provisionCancelSuccessResponseCode) {
            this.gammaResponse.errorStatus = false;
        }
        
        return gammaResponse;
    }
    
    public GammaMobile_Response mobileServiceActivate () {
        this.gammaResponse = new GammaMobile_Response();
        /*if(this.msisdn.value == null || this.iccid == '') {
            this.gammaResponse.errorCode = 'Invalid Data';
            this.gammaResponse.errorMessage = 'Missing Required Data';
			return this.gammaResponse;
        }*/
        
        this.mobileServiceSearchService();
        
        if(this.gammaResponse.errorStatus) {
            return this.gammaResponse;
        }

        if(this.service.status.selectedServiceStatus == 'ACTIVE') {
            this.gammaResponse.errorStatus = false;
            return this.gammaResponse;
        }
        
        this.gammaResponse = new GammaMobile_Response();
        String xmlString = this.createServiceActivationXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        this.sendHttpRequest(xmlString, 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/activate?iccid=' + this.iccid);
        
        return gammaResponse;
    }
    
    /*public Boolean mobileServiceCease () {
        if(this.msisdn.value == null || this.iccid == '' || this.serviceCeaseEnabled == false) {
            return false;
        }
        
        HttpResponse res = this.sendHttpRequest(null , 'DELETE', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceChangeImei () {
        if(this.imei == '' | this.iccid == '') {
            return false;
        }
        String xmlString = createServiceChangeImeiXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/handset?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceChangeMsisdn () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
        String xmlString = createServiceChangeMsisdnXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/msisdn?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceChangeUsim () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
        String xmlString = createServiceChangeUsimXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/usim?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceResetPin () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
     
        
        HttpResponse res = this.sendHttpRequest(null , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/voicemail/resetpin?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceSuspend () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
     
        String xmlString = createServiceSuspendXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/suspend?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceResume () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
     
        String xmlString = createServiceResumeXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/resume?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }
    
    public Boolean mobileServiceUnBlacklistHandset () {
        if(this.msisdn.value == null || this.iccid == null) {
            return false;
        }
        
        HttpResponse res = this.sendHttpRequest(null , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/handset/unblacklist?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }*/
    
    public GammaMobile_Response mobileServiceChangeTariff () {
        this.gammaResponse = new GammaMobile_Response();
        
        if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }
        
        String xmlString = createServiceChangeTariffTypeXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/tariff?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    /*public Boolean mobileServiceRenewFunding () {
        if(this.advancedFundingType.selectedAdvancedFundingType == '') {
            return false;
        }
        
        String xmlString = createServiceRenewFundingXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/tariff?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }*/
    
    public GammaMobile_Response mobileServiceUpdateNetworkServices () {
        this.gammaResponse = new GammaMobile_Response();
        
        /*if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }*/
        
        String xmlString = this.createServiceUpdateNetworkServicesXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/services?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    public GammaMobile_Response mobileServiceUpdateNetworkBars () {
        this.gammaResponse = new GammaMobile_Response();
        
        /*if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }*/
        
        String xmlString = createServiceUpdateNetworkBarsXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/barring?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    /*public Boolean mobileServiceUpdateCallForwarding () {
        if(this.callforwards.size() == 0) {
            return false;
        }
        
        String xmlString = createServiceUpdateCallForwardingXml();
        
        HttpResponse res = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + this.msisdn.value + '/callforwarding?iccid=' + this.iccid);
        
        if (res == null) {
            return false;
        } 
        
        DOM.Document resDoc = res.getBodyDocument();
        DOM.XmlNode collection = resDoc.getRootElement();
        
        if (collection.getChildElement('validationError', companyNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
            return false;
        } else if (collection.getChildElement('validationError', serviceNamespace) != null) {
            DOM.XmlNode errors = collection.getChildElement('validationError', serviceNamespace);
            return false;
        }
        
        return true;
    }*/
    
    public GammaMobile_Response mobileServiceUpdateBoltOns () {
        this.gammaResponse = new GammaMobile_Response();
        
        /*if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }*/
        
        String xmlString = createServiceUpdateBoltOnsXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/bolton?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    public GammaMobile_Response mobileServiceUpdateRoamingConfig () {
        this.gammaResponse = new GammaMobile_Response();
        
        /*if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }*/
        
        String xmlString = createServiceUpdateRoamingConfigXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'POST', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/roaming?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    /*public GammaMobile_Response mobileServiceUpdateConfiguration () {
        this.gammaResponse = new GammaMobile_Response();
        
        if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }
        
        String xmlString = createServiceUpdateConfigurationXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/configure?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }*/
    
    /*public GammaMobile_Response mobileServiceUpdateNotificationOptions () {
        this.gammaResponse = new GammaMobile_Response();
        
        if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }
                
        String xmlString = createServiceUpdateNotificationOptionsXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/roaming/notifications?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    public GammaMobile_Response mobileServiceUpdateEuMaxCharge () {
        this.gammaResponse = new GammaMobile_Response();
        
        if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }
        
        String xmlString = createServiceUpdateEuMaxChargeXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/roaming/maxCharge/eu?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }
    
    public GammaMobile_Response mobileServiceUpdateRowMaxCharge () {
        this.gammaResponse = new GammaMobile_Response();
        
        if (this.msisdn.value == '' || this.iccid == '') {
            this.gammaResponse.errorCode = 'Bad Request';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }
        
        String xmlString = createServiceUpdateRowMaxChargeXml();
        
        if (xmlString == null) {
            this.gammaResponse.errorCode = 'Request Failed';
            this.gammaResponse.errorMessage = 'Failed to create XML Document';
            return this.gammaResponse;
        }
        
        DOM.XmlNode collection = this.sendHttpRequest(xmlString , 'PUT', GammaMobileAPI__c.getValues('default').ServiceURL__c + '/' + this.msisdn.value + '/roaming/maxCharge/row?iccid=' + this.iccid);
        
        if (gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection)) {
            this.gammaResponse.errorStatus = false;
        }
        
        return this.gammaResponse;
    }*/
    
    public GammaMobile_Response mobileServiceSearchService () {
        this.gammaResponse = new GammaMobile_Response();
        
        /*if (this.msisdn.value == '') {
            this.gammaResponse.errorCode = '404';
            this.gammaResponse.errorMessage = 'Missing required data';
            return this.gammaResponse;
        }*/
        
        DOM.XmlNode collection;
        if(msisdn != null) {
        	collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').ServiceURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&msisdn=' + this.msisdn.value);
        } else {
            collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').ServiceURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&maxResults=100');
        }
        
        if (this.gammaResponse.errorStatus) {
            return this.gammaResponse;
        }
        
        
        if(collection != null && collection.getChildren().size() > 0 && this.service.loadXml(collection.getChildElement('service', GammaMobileAPI__c.getValues('default').DomainURL__c)) ) {
            this.gammaResponse.errorStatus = false;
        } else {
            this.gammaResponse.errorCode = '404';
            this.gammaResponse.errorMessage = 'Not found';
            this.gammaResponse.errorStatus = true;
        }
        return this.gammaResponse;
    }
    
    public List<GammaMobile_Msisdn> mobileServiceSearchMsisdn (String msisdn) {
        this.gammaResponse = new GammaMobile_Response();
        
        List<GammaMobile_Msisdn> msisdnList = new List<GammaMobile_Msisdn>();
        
        DOM.XmlNode collection;
        if(msisdn != null) {
        	collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').MsisdnURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&status=AVAILABLE&maxResults=100&msisdn=' + msisdn);
        } else {
            collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').MsisdnURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&status=AVAILABLE&maxResults=100');
        }
        
        if(collection != null && collection.getChildren().size() > 0) {
            this.gammaResponse.errorStatus = false;
        }
        
        if (gammaResponse.errorStatus) {
            return null;
        }
        
        for(DOM.XmlNode node: collection.getChildren()) {
            GammaMobile_Msisdn tmpMsisdn = new GammaMobile_Msisdn();
            tmpMsisdn.loadXml(node);
            msisdnList.add(tmpMsisdn);
        }
        
        if(msisdnList.isEmpty()) {
            return null;
        }
        return msisdnList;
    }
    
    public List<GammaMobile_Usim> mobileServiceSearchUsim (String iccid) {
        this.gammaResponse = new GammaMobile_Response();
        
        List<GammaMobile_Usim> usims = new List<GammaMobile_Usim>();
        DOM.XmlNode collection;
        if(iccid != null) {
        	collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').UsimURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&status=AVAILABLE&maxResults=100&iccid=' + iccid);
        } else {
            collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').UsimURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&status=AVAILABLE');
        }
        
        if(collection != null && collection.getChildren().size() > 0) {
            this.gammaResponse.errorStatus = false;
        }
        
        if (gammaResponse.errorStatus) {
            return null;
        }
        
        for(DOM.XmlNode node: collection.getChildren()) {
            GammaMobile_Usim tmpUsim = new GammaMobile_Usim();
            tmpUsim.loadXml(node);
            usims.add(tmpUsim);
        }
        if(usims.isEmpty()) {
            return null;
        }
        return usims;
    }
    
    public List<GammaMobile_Company> mobileServiceSearchCompany (String cmp) {
        this.gammaResponse = new GammaMobile_Response();
        List<GammaMobile_Company> companies = new List<GammaMobile_Company>();
        DOM.XmlNode collection;
        if(cmp != null) {
        	collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').CompanyURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&maxResults=100&name=' + cmp);
        } else {
            collection = this.sendHttpRequest(null , 'GET', GammaMobileAPI__c.getValues('default').CompanyURL__c + '?clientId=' + GammaMobileAPI__c.getValues('default').ClientId__c + '&maxResults=100');
        }
        
        if(collection != null && collection.getChildren().size() > 0) {
            this.gammaResponse.errorStatus = false;
        }
        
        if (gammaResponse.errorStatus) {
            return null;
        }
        
        for(DOM.XmlNode node: collection.getChildren()) {
            GammaMobile_Company company = new GammaMobile_Company();
            company.loadXml(node);
            companies.add(company);
        }
        return companies;
    }
    
    /*private String createServiceUpdateRowMaxChargeXml () {
        DOM.Document doc = new Dom.Document();
        if (this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != null && this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != '') {
        	DOM.XmlNode root =  doc.createRootElement('rowRoamingMaxCharge', companyNamespace, 'domain').addTextNode(this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge);
        } else {
            DOM.XmlNode root =  doc.createRootElement('rowRoamingMaxCharge', companyNamespace, 'domain');
        }
        return doc.toXmlString();
    }
    
    private String createServiceUpdateEuMaxChargeXml () {
        DOM.Document doc = new Dom.Document();
        if(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != null && this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != '') {
        	DOM.XmlNode root =  doc.createRootElement('euRoamingMaxCharge', companyNamespace, 'domain').addTextNode(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge);
        } else {
            DOM.XmlNode root =  doc.createRootElement('euRoamingMaxCharge', companyNamespace, 'domain');
        }
        return doc.toXmlString();
    }
    
    private String createServiceUpdateNotificationOptionsXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('collection', serviceNamespace, 'ns2');
        root.setAttribute('xmlns', companyNamespace);
        for(GammaMobile_NotificationOption no: this.service.config.roamingConfig.notificationOptions.notificationOptions) {
            if(no.selectedNotificationOption != null && no.selectedNotificationOption != '') {
            	DOM.XmlNode notificationOptionXml = root.addChildElement('notificationOption', null, null).addTextNode(no.selectedNotificationOption);
            }
        }
        
        return doc.toXmlString();
    }*/
    
    private String createServiceUpdateRoamingConfigXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('roamingConfiguration', companyNamespace, 'domain');
        
        DOM.XmlNode notifOptionsXml = root.addChildElement('notificationOptions', null, null);
        for(GammaMobile_NotificationOption no: this.service.config.roamingConfig.notificationOptions.notificationOptions) {
            if(no.selectedNotificationOption != null && no.selectedNotificationOption != '') {
            	DOM.XmlNode notificationOptionXml = notifOptionsXml.addChildElement('notificationOption', null, null).addTextNode(no.selectedNotificationOption);
            }
        }
        
        if(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != '' && this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != null) {
            DOM.XmlNode euRMC = root.addChildElement('euRoamingMaxCharge', null, null).addTextNode(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge);
        } else {
            DOM.XmlNode euRMC = root.addChildElement('euRoamingMaxCharge', null, null).addTextNode('MC_017_5');
        }
        
        if(this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != '' && this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != null) {
            DOM.XmlNode rowRMC = root.addChildElement('rowRoamingMaxCharge', null, null).addTextNode(this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge);
        } else {
            DOM.XmlNode rowRMC = root.addChildElement('rowRoamingMaxCharge', null, null).addTextNode('MC_750_0');
        }
        return doc.toXmlString();
    }
    
    /*private String createServiceUpdateConfigurationXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('configuration', companyNamespace, 'ns2');
        
        if(this.service.config.networkServices.networkServices.size() > 0) {
            DOM.XmlNode networkServicesXml = root.addChildElement('networkServices', null, null);
            for(GammaMobile_NetworkService ns: this.service.config.networkServices.networkServices) {
                if (ns.selectedNetworkService != null && ns.selectedNetworkService != '') {
                    DOM.XmlNode networkServiceXml = networkServicesXml.addChildElement('networkService', null, null).addTextNode(ns.selectedNetworkService);
                }
            }
        }
        
        if(this.service.config.networkBars.networkBars.size() > 0) {
            DOM.XmlNode networkBarsXml = root.addChildElement('networkBars', null, null);
            for(GammaMobile_NetworkBar nb: this.service.config.networkBars.networkBars) {
                if(nb.selectedNetworkBar != null && nb.selectedNetworkBar != '') {
                    DOM.XmlNode networkBarXml = networkBarsXml.addChildElement('networkBar', null, null).addTextNode(nb.selectedNetworkBar);
                }
            }
        }
        
        if (this.service.config.boltOns.boltOns.size() > 0) {
            DOM.XmlNode boltOnsXml = root.addChildElement('boltOns', null, null);
            for(GammaMobile_BoltOn bo: this.service.config.boltOns.boltOns) {
                if (bo.selectedBoltOn != null && bo.selectedBoltOn != '') {
                    DOM.XmlNode boltOnXml = boltOnsXml.addChildElement('boltOn', null, null).addTextNode(bo.selectedBoltOn);
                }
            }
        }
        
        if (this.service.config.roamingConfig.notificationOptions.notificationOptions.size() > 0 || this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != '' || this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != '') {
            DOM.XmlNode roamingConfigXml =  root.addChildElement('roamingConfiguration', null, null);
            
            if (this.service.config.roamingConfig.notificationOptions.notificationOptions.size() > 0) {
                DOM.XmlNode notifOptionsXml = roamingConfigXml.addChildElement('notificationOptions', null, null);
                for(GammaMobile_NotificationOption no: this.service.config.roamingConfig.notificationOptions.notificationOptions) {
                    if(no.selectedNotificationOption != null && no.selectedNotificationOption != '') {
                        DOM.XmlNode notificationOptionXml = notifOptionsXml.addChildElement('notificationOption', null, null).addTextNode(no.selectedNotificationOption);
                    }
                }
            }
            
            if(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != '' && this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != null) {
                DOM.XmlNode euRMC = roamingConfigXml.addChildElement('euRoamingMaxCharge', null, null).addTextNode(this.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge);
            } else {
                DOM.XmlNode euRMC = roamingConfigXml.addChildElement('euRoamingMaxCharge', null, null).addTextNode('MC_017_5');
            }
            
            if(this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != '' && this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != null) {
                DOM.XmlNode rowRMC = roamingConfigXml.addChildElement('rowRoamingMaxCharge', null, null).addTextNode(this.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge);
            } else {
                DOM.XmlNode rowRMC = roamingConfigXml.addChildElement('rowRoamingMaxCharge', null, null).addTextNode('MC_750_0');
            }
        }
        return doc.toXmlString();
    }*/
    
    private String createServiceUpdateBoltOnsXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('collection', serviceNamespace, 'ns2');
        root.setAttribute('xmlns', companyNamespace);
        if (this.service.config.boltOns.boltOns.size() > 0) {
            for(GammaMobile_BoltOn bo: this.service.config.boltOns.boltOns) {
                if (bo.selectedBoltOn != null && bo.selectedBoltOn != '') {
                	DOM.XmlNode boltOnsXml = root.addChildElement('boltOn', null, null).addTextNode(bo.selectedBoltOn);
                }
            }
        } else {
            DOM.XmlNode boltOnsXml = root.addChildElement('boltOns', null, null);
        }
        return doc.toXmlString();
    }
    
    /*private String createServiceUpdateCallForwardingXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('callForwardConfiguration', serviceNamespace, 'api');
        
        for(GammaMobile_CallForward cf: this.callforwards) {
            DOM.XmlNode forward = root.addChildElement('forward', null, null);
            if(cf.voicemail) {
                forward.setAttribute('xsi:type', 'api:forwardToVoicemail');
            } else {
            	forward.setAttribute('xsi:type', 'api:forwardToNumber');
            }
            forward.setNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
            DOM.XmlNode conditions = forward.addChildElement('conditions', null, null);
            DOM.XmlNode condition = conditions.addChildElement('condition', null, null).addTextNode(cf.type);
            if (!cf.voicemail) {
                DOM.XmlNode numberTo = forward.addChildElement('number', null, null).addTextNode(cf.forwardToNumber);
            }
        }
        return doc.toXmlString();
    }*/
    
    private String createServiceUpdateNetworkBarsXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('collection', serviceNamespace, 'ns2');
        root.setAttribute('xmlns', companyNamespace);	
        for(GammaMobile_NetworkBar nb: this.service.config.networkBars.networkBars) {
            if(nb.selectedNetworkBar != null && nb.selectedNetworkBar != '') {
            	DOM.XmlNode networkBarXml = root.addChildElement('networkBar', null, null).addTextNode(nb.selectedNetworkBar);
            }
        }
        return doc.toXmlString();
    }
    
    private String createServiceUpdateNetworkServicesXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('collection', serviceNamespace, 'ns2');
        root.setAttribute('xmlns', companyNamespace);	
        for(GammaMobile_NetworkService ns: this.service.config.networkServices.networkServices) {
            if (ns.selectedNetworkService != null && ns.selectedNetworkService != '') {
            	DOM.XmlNode networkServiceXml = root.addChildElement('networkService', null, null).addTextNode(ns.selectedNetworkService);
            }
        }
        return doc.toXmlString();
    }
    
    /*private String createServiceRenewFundingXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('fundingRenewal', serviceNamespace, 'ns3');
        root.setNamespace('ns2', companyNamespace);	
        DOM.XmlNode xmlType = root.addChildElement('type', null, null).addTextNode(this.advancedFundingType.selectedAdvancedFundingType);
        DOM.XmlNode repaymentPeriodXml = root.addChildElement('repaymentPeriod', null, null).addTextNode(this.repaymentPeriod.selectedRepaymentPeriod);
        return doc.toXmlString();
    }*/
    
    private String createServiceChangeTariffTypeXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode root =  doc.createRootElement('tariffType', companyNamespace, 'ns2');
        root.setNamespace('ns3', serviceNamespace);
        root.addtextNode(this.service.tariff.tariffType.selectedTariffType);
        return doc.toXmlString();
    }
    
    /*private String createServiceResumeXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode activation =  doc.createRootElement('unblacklist', serviceNamespace, 'api').addTextNode('true');
        return doc.toXmlString();
    }
    
    private String createServiceSuspendXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode activation =  doc.createRootElement('blacklist', serviceNamespace, 'api').addTextNode('true');
        return doc.toXmlString();
    }
    
    private String createServiceChangeUsimXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode activation =  doc.createRootElement('iccid', serviceNamespace, 'api').addTextNode(this.iccid);
        return doc.toXmlString();
    }
    
    private String createServiceChangeMsisdnXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode activation =  doc.createRootElement('msisdn', serviceNamespace, 'api').addTextNode(this.msisdn.value);
        return doc.toXmlString();
    }*/
    
    private String createServiceActivationXml () {
        DOM.Document doc = new Dom.Document();
        //return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><api:serviceActivationDetails xmlns:api="http://www.gamma.co.uk/mobile/api"><imei>000000000000000</imei></api:serviceActivationDetails>';
        
        DOM.XmlNode activation =  doc.createRootElement('serviceActivationDetails', serviceNamespace, 'api');
        if(this.provision.imei != '') {
            DOM.XmlNode xmlImei = activation.addChildElement('imei', null, null).addTextNode(this.provision.imei);
        } else {
        	DOM.XmlNode xmlImei = activation.addChildElement('imei', null, null).addTextNode('000000000000000');
        }
        return doc.toXmlString();
    }
    
    /*private String createServiceChangeImeiXml () {
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode imeiXml =  doc.createRootElement('imei', 'http://www.gamma.co.uk/mobile/api', 'api').addTextNode(this.imei);
        return doc.toXmlString();
    }*/
    
    private String createProvisionXml () {
        
        String xmlString = '';
        
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode provision =  doc.createRootElement('provision', serviceNamespace, 'ns2');
        
        /*if(this.provision.imei != '') {
        	DOM.XmlNode reqImei = provision.addChildElement('imei', null, null).addTextNode(this.provision.imei);
        }*/

        if(this.provision.imei == '') {
            DOM.XmlNode imeiXml = provision.addChildElement('imei', null, null).addTextNode('000000000000000');
        } else {
            DOM.XmlNode imeiXml = provision.addChildElement('imei', null, null).addTextNode(this.provision.imei);
        }
        
        DOM.XmlNode tariff = provision.addChildElement('tariff', null, null);
        DOM.XmlNode tariffType = tariff.addChildElement('type', null, null).addTextNode(this.provision.tariff.tariffType.selectedTariffType);
        
        DOM.XmlNode configuration = provision.addChildElement('configuration', null, null);
        if(this.provision.config.networkServices.networkServices.size() > 0) {
            DOM.XmlNode xmlNetworkServices = configuration.addChildElement('networkServices', null, null);
            for (GammaMobile_NetworkService ns: this.provision.config.networkServices.networkServices) {
                DOM.XmlNode xmlNetworkService = xmlNetworkServices.addChildElement('networkService', null, null).addTextNode(ns.selectedNetworkService);
            }
        }
        
        /*if(this.provision.config.networkBars.networkBars.size() > 0) {	
            DOM.XmlNode xmlNetworkBars = configuration.addChildElement('networkBars', null, null);
            for(GammaMobile_NetworkBar nb: this.provision.config.networkBars.networkBars) {
                DOM.XmlNode xmlNetworkBar = xmlNetworkBars.addChildElement('networkBar', null, null).addTextNode(nb.selectedNetworkBar);
            }
        }*/
        
        if (this.provision.config.boltOns.boltOns.size() > 0) {
            DOM.XmlNode xmlBoltOns = configuration.addChildElement('boltOns', null, null);
            for(GammaMobile_BoltOn bo: this.provision.config.boltOns.boltOns) {
                if(bo == null) {
                    continue;
                }
                DOM.XmlNode xmlBolton = xmlBoltOns.addChildElement('boltOn', null, null).addTextNode(bo.selectedBolton);
            }
        } 
        
        DOM.XmlNode xmlRoamingConfiguration = configuration.addChildElement('roamingConfiguration', null, null);
        /*if(this.provision.config.roamingConfig.notificationOptions.notificationOptions.size() > 0) {
            DOM.XmlNode xmlNotificationOptions = xmlRoamingConfiguration.addChildElement('notificationOptions', null, null);
            for(GammaMobile_NotificationOption no: this.provision.config.roamingConfig.notificationOptions.notificationOptions) {
                DOM.XmlNode xmlnotificationOption = xmlNotificationOptions.addChildElement('notificationOption', null, null).addTextNode(no.selectedNotificationOption);
            }
        }*/
        
        if(this.provision.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge != null) {
            DOM.XmlNode xmlEuRoamingMaxCharge = xmlRoamingConfiguration.addChildElement('euRoamingMaxCharge', null, null).addTextNode(this.provision.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge);
        }
        
        if(this.provision.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge != null) {
            DOM.XmlNode xmlRowRoamingMaxCharge = xmlRoamingConfiguration.addChildElement('rowRoamingMaxCharge', null, null).addTextNode(this.provision.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge);
        }
        
        DOM.XmlNode contact = provision.addChildElement('contact', null, null);
        DOM.XmlNode xmlContactCompanyName = contact.addChildElement('companyName', null, null).addTextNode(this.provision.contact.companyName);
        DOM.XmlNode xmlContactName = contact.addChildElement('name', null, null).addTextNode(this.provision.contact.name);

		/*if(this.provision.advFunding.advFundingType.selectedAdvancedFundingType != '') {
            DOM.XmlNode xmlAdvancedFunding = provision.addChildElement('advancedFunding', null, null);        
            DOM.XmlNode xmlAdvancedFundingType = xmlAdvancedFunding.addChildElement('type', null, null).addTextNode(this.provision.advFunding.advFundingType.selectedAdvancedFundingType);
            DOM.XmlNode xmlRepaymentPeriod = xmlAdvancedFunding.addChildElement('repaymentPeriod', null, null).addTextNode(this.provision.advFunding.repaymentPeriod.selectedRepaymentPeriod);
            DOM.XmlNode xmlafStartDate = xmlAdvancedFunding.addChildElement('startDate', null, null).addTextNode(json.serialize(datetime.now()));
        }

        if(this.provision.portDetail != null && this.provision.portDetail.pacDetail.pac != '') {
            DOM.XmlNode portDetail = provision.addChildElement('portDetail', null, null);
            DOM.XmlNode xmlMsisdn = portDetail.addChildElement('msisdn', null, null).addTextNode(this.provision.portDetail.msisdn);
            DOM.XmlNode xmlPortDate = portDetail.addChildElement('portDate', null, null).addTextNode(json.serialize(this.provision.portDetail.portDate));
            DOM.XmlNode xmlPacDetail = portDetail.addChildElement('pacDetail', null, null);
            DOM.XmlNode xmlPacCode = xmlPacDetail.addChildElement('pac', null, null).addTextNode(this.provision.portDetail.pacDetail.pac);
        }*/
        return doc.toXmlString();
    }
    
    private String createCompanyXml () {
        String xmlString = '';
        
        DOM.Document doc = new Dom.Document();
        DOM.XmlNode company =  doc.createRootElement('company', companyNamespace, 'domain');
        DOM.XmlNode company_name = company.addChildElement('name', null, null).addTextNode(this.company.name);
        
        if(this.sfContact != null) {
        	DOM.XmlNode externalReference = company.addChildElement('externalReference', null, null).addTextNode((String)this.sfContact.Account.Id);
        }
        
        if(this.company.contact.name != '') {
            DOM.XmlNode contact = company.addChildElement('contact', null, null);
            DOM.XmlNode contactName = contact.addChildElement('name', null, null).addTextNode(this.company.contact.name);
            DOM.XmlNode contactEmail = contact.addChildElement('emailAddress', null, null).addTextNode(this.company.contact.emailAddress);
            DOM.XmlNode contactPhone = contact.addChildElement('phoneNumber', null, null).addTextNode(this.company.contact.phoneNumber);
        }
        
        if(this.company.address != null) {
            DOM.XmlNode address = company.addChildElement('address', null, null);
            DOM.XmlNode addressLine1 = address.addChildElement('thoroughfareNumber', null, null).addTextNode(this.company.address.thoroughfareNumber);
            DOM.XmlNode addressLine2 = address.addChildElement('thoroughfareName', null, null).addTextNode(this.company.address.thoroughfareName);
            DOM.XmlNode town = address.addChildElement('town', null, null).addTextNode(this.company.address.town);
            DOM.XmlNode county = address.addChildElement('county', null, null).addTextNode(this.company.address.county);
            DOM.XmlNode postCode = address.addChildElement('postcode', null, null).addTextNode(this.company.address.postcode);
        }
        return doc.toXmlString();
    }
    
    public DOM.XmlNode sendHttpRequest (String reqBody, String apiMethod, String apiExtension) {
        if (apiExtension == null || apiMethod == null) {
            return null;
        }
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
                
        req.setMethod(apiMethod);
        req.setEndpoint(GammaMobileAPI__c.getValues('default').BaseURL__c + apiExtension);
        req.setHeader('authorization', 'Basic ' + GammaMobileAPI__c.getValues('default').PasswordHash__c);
        req.setHeader('clientid', GammaMobileAPI__c.getValues('default').ClientId__c);
        req.setHeader('content-type', 'application/xml');
        
        if(reqBody != null) {
            //system.debug('REQUEST BODY: ' + reqBody);
        	req.setBody(reqBody);
        }
        
        //system.debug('REQUEST: ' + req);
        
        HttpResponse res = new HttpResponse();
        try {
        	res = http.send(req);
        } catch (CalloutException e) { 
            try {
                //system.debug('REQUEST FAILED TRYING AGAIN: ' + res.getStatusCode() + ' - ' + res.getStatus());
            	res = http.send(req);
            } catch (CalloutException e2) {
                //system.debug('HTTP Request Attempt failed twice');
            }
        } finally {
            //system.debug('In finally block. Nothing to do here.');
        }
        
        //system.debug('HTTP RESPONSE WE GOT WAS: ' + res);
        
        if (res == null) {
            this.gammaResponse.errorCode = 'Http Request Failed';
            this.gammaResponse.errorMessage = 'Timed out';
            this.gammaResponse.httpResponseCode = 400;
            return null;
        } else if (res.getStatusCode() != 200) {
            this.gammaResponse.errorCode = res.getStatusCode() + ' - ' + res.getStatus();
            this.gammaResponse.httpResponseCode = res.getStatusCode();
        }
        
        DOM.Document resDoc = new DOM.Document();
        DOM.XmlNode collection = null;
        
        if(res.getBody() != null && res.getBody() != '') {
            resDoc = res.getBodyDocument();
            //system.debug('RESPONSE BODY XML: ' + resDoc.toXmlString());
            collection = resDoc.getRootElement();
            if (collection != null && (collection.getChildElement('validationError', companyNamespace) != null || collection.getChildElement('validationError', serviceNamespace) != null)) {
                DOM.XmlNode errors = collection.getChildElement('validationError', companyNamespace);
                this.gammaResponse.errorMessage = errors.getChildElement('errorCode', null).getText() + ' - ' + errors.getChildElement('message', null).getText();
                return null;
            }
        } else {
            //system.debug('RESPONSE XML BODY EMPTY');
        }
        
        if(res.getStatusCode() == this.gammaResponse.defaultSuccessResponseCode) {
            this.gammaResponse.errorStatus = false;
        }
        return collection;
    }
}