public class GammaMobileController {
    public ApexPages.StandardController stdController;
    public Gamma_Mobile__c mobileObj;
    public GammaMobile mobileClass {get; set;}
    public List<GammaMobile_Msisdn> availMsisdn {get; set;}
    public Id accountId {get; set;}
    public Contact mobileUser {get; set;}
    public List<SelectOption> msisdnNumbersOptionList;
    public List<String> iccidList;
    public List<String> msisdnList;
    public List<String> iccidUsedList;
    public List<String> msisdnUsedList;
    public List<SelectOption> tariffList {get; set;}
    public List<SelectOption> dataBoltonList {get; set;}
    public List<Gamma_Mobile__c> provisionedList {get; set;}
    public List<Gamma_Mobile__c> activatedList {get; set;}
    public String searchMobile {get; set;}
    public String searchIccid {get; set;}
    
    public String ukDataBolton {get; set;}
    
    public Boolean multinet {get; set;}
    public Boolean sms250 {get; set;}    
    public Boolean dataSharer {get; set;}
    
    public Boolean mobileData {get; set;}
    public Boolean intlCallingService {get; set;}
    public Boolean intlRoamingService {get; set;}
    public Boolean dataRoamingService {get; set;}
    public Boolean premiumService {get; set;}
    
    public Boolean smartBusinessPack {get;set;}
    public Boolean rowRoaming {get; set;}
    public Boolean intlVoiceEuNa {get; set;}
    public Boolean intlVoiceRow {get; set;}
    public Boolean worldWideData {get; set;}
    
    public String delProvisionIccidVal {get; 
                                        set{
                                            delProvisionIccidVal = value;
                                        }
                                      }
    public String activateProvisionIccidVal {get; 
                                             set{
                                                 activateProvisionIccidVal = value;
                                             }
                                            }
    public String delProvisionMsisdnVal {get; 
                                         set {
                                             delProvisionMsisdnVal = value;
                                         }
                                        }
    public String activateProvisionMsisdnVal {get; 
                                              set {
                                                  activateProvisionMsisdnVal = value;
                                              }
                                             }
    public String acctId {get; set;}
    public Integer ajaxTimeout {
                                get{
                                    return 30000;
                                }
                               }

    public GammaMobileController (ApexPages.StandardController controller) {
        this.stdController = controller;
        this.mobileObj = (Gamma_Mobile__c)stdController.getRecord();
        this.msisdnNumbersOptionList = new List<SelectOption>();
        this.availMsisdn = new List<GammaMobile_Msisdn>();
        this.mobileClass = new GammaMobile();
        this.mobileUser = new Contact();
        this.tariffList = new List<SelectOption>();
        this.dataBoltonList = new List<SelectOption>();
        this.ukDataBolton = '';
        this.mobileData = true;
        this.searchMobile = '';
        this.searchIccid = '';
        this.delProvisionIccidVal = '';
		this.activateProvisionIccidVal = '';
    	this.delProvisionMsisdnVal = '';
    	this.activateProvisionMsisdnVal = '';
        this.acctId = '';
        this.iccidList = new List<String>();
        this.msisdnList = new List<String>();
        this.iccidUsedList = new List<String>();
        this.msisdnUsedList = new List<String>();
        this.provisionedList = new List<Gamma_Mobile__c>();
        this.activatedList = new List<Gamma_Mobile__c>();
        
        this.intlCallingService = false;
        this.intlRoamingService = false;
        this.dataRoamingService = false;
        this.premiumService = false;
        this.rowRoaming = false;
        this.smartBusinessPack = false;
        this.intlVoiceEuNa = false;
        this.intlVoiceRow = false;
        this.worldWideData = false;
        this.multinet = false;
        
        this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Active'];
        
        for(String tariffName: GammaMobile_ReferenceData.refTariffType.keySet()) {
            SelectOption tmpOpt = new SelectOption(GammaMobile_ReferenceData.refTariffType.get(tariffName), tariffName);
            tariffList.add(tmpOpt);
        }
        
        SelectOption empty = new SelectOption('', '');
        dataBoltonList.add(empty);
        for(String bolton: GammaMobile_ReferenceData.refBoltOn_Data.keySet()) {
            SelectOption tmpOpt = new SelectOption(bolton, bolton);
            dataBoltonList.add(tmpOpt);
        }
    }
    
    public List<String> getMsisdnUsedList () {
        List<Gamma_Mobile__c> mobiles = [SELECT Id, Msisdn__c FROM Gamma_Mobile__c];
        
        if (mobiles.size() > 0) {
            List<String> usedMsisdnList = new List<String>();
            for(Gamma_Mobile__c mobile: mobiles) {
                usedMsisdnList.add(mobile.Msisdn__c);
            }
            return usedMsisdnList;
        }
        return null;
    }
    
    public List<String> getIccidUsedList () {
        List<Gamma_Mobile__c> mobiles = [SELECT Id, Iccid__c FROM Gamma_Mobile__c];
        
        if (mobiles.size() > 0) {
            List<String> usedIccidList = new List<String>();
            for(Gamma_Mobile__c mobile: mobiles) {
                usedIccidList.add(mobile.Iccid__c);
            }
            return usedIccidList;
        }
        return null;
    }
    
    public Map<String, String> getMsisdn (String msisdn) {
        //return this.mobileClass.mobileServiceSearchMsisdn(msisdn);
        return null;
    }
    
    public List<String> getMsisdnList () {
        List<GammaMobile_Msisdn> tmpList = new List<GammaMobile_Msisdn>();
        tmpList = this.getAvailMsisdn();
        if(tmpList != null) {
            if (tmpList.size() > 0) {
                for (GammaMobile_Msisdn msisdn: tmpList) {
                    this.msisdnList.add(msisdn.value);
                }
                return this.msisdnList;
            }
        }
        return null;
    }
    
    public List<GammaMobile_Msisdn> getAvailMsisdn () {
        return this.mobileClass.mobileServiceSearchMsisdn(null);
    }
    
    public List<String> getIccidList () {
        List<GammaMobile_Usim> usimList = new List<GammaMobile_Usim>();
        usimList = this.getAvailIccidList();
        if (usimList != null) {
            if (usimList.size() > 0) {
                for (GammaMobile_Usim usim: usimList) {
                    this.iccidList.add(usim.iccid);
                }
                return this.iccidList;
            }
        }
        
        return null;
    }
    
    public List<GammaMobile_Usim> getAvailIccidList () {
        return this.mobileClass.mobileServiceSearchUsim(null);
    }
    
    public PageReference configProvisionRequest () {
        Gamma_Mobile__c[] tmpObj = [SELECT Id, Iccid__c, Msisdn__c FROM Gamma_Mobile__c WHERE Iccid__c = :this.mobileObj.Iccid__c OR Msisdn__c = :this.mobileObj.Msisdn__c];
        if(tmpObj.size() > 0) {
            if(tmpObj[0].Msisdn__c == this.mobileObj.Msisdn__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Mobile number already inuse'));
                return null;
            }
            
            if(tmpObj[0].Iccid__c == this.mobileObj.Iccid__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sim number (iccid) already in use'));
                return null;
            }
        }
        
        if(mobileObj.Contact__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a contact'));
            return null;
        }
        
        Pattern p = pattern.compile('.*\\D.*');
        Matcher msisdnMatcher = p.matcher(mobileObj.Msisdn__c);
        Matcher iccidMatcher = p.matcher(mobileObj.Iccid__c);
        
        if(msisdnMatcher.matches()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Mobile Number contains invalid data. Please use numbers only'));
            return null;
        }
        
        if(iccidMatcher.matches()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Iccid (Sim) Number contains invalid data. Please use numbers only'));
            return null;
        }
        
        if(mobileObj.Msisdn__c.length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Mobile Number'));
            return null;
        }
        
        if(mobileObj.Iccid__c.length() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Iccid (Sim) Number'));
            return null;
        }
        
        Contact cnt = [SELECT Id, AccountId, Contact.Account.Name, Name, Email, Phone FROM Contact WHERE Id = :mobileObj.Contact__c];
        mobileClass.company.contact.name = cnt.Name == null ? 'Connexin' : cnt.Name;
        mobileClass.company.contact.emailAddress = cnt.Email == null ? 'support@connexin.co.uk' : cnt.Email;
        mobileClass.company.contact.phoneNumber = cnt.Phone == null ? '01482363738' : cnt.Phone;
        
        mobileClass.company.name = cnt.Account.Id;
        mobileClass.company.externalReference = cnt.Account.Id;
        
        mobileClass.provision.contact.name = cnt.Name == null ? 'Connexin' : cnt.Name;
        mobileClass.provision.contact.companyName = cnt.Account.Id;
        
        //Account acc = [SELECT Id, Name, BillingStreet, BillingState, BillingCity, BillingPostalCode, BillingCountry FROM Account WHERE id = :cnt.AccountId];
        mobileClass.company.address.thoroughfareNumber = 'Unit 1 Bridge View';
        mobileClass.company.address.thoroughfareName = 'Connexin';
        mobileClass.company.address.county = 'East Yorkshire';
        mobileClass.company.address.town = 'Hull';
        mobileClass.company.address.postcode = 'HU4 7DW';
        
        if(mobileObj.Iccid__c == null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Please enter SIM Iccid number'));
            return null;
        }
        
        mobileClass.iccid = mobileObj.Iccid__c;
        mobileClass.msisdn.value = mobileObj.Msisdn__c;
        
        List<GammaMobile_Company> companies = new List<GammaMobile_Company>();
        companies = mobileClass.mobileServiceSearchCompany(mobileClass.provision.contact.companyName);
        if(companies != null && companies.size() == 0) {
            GammaMobile_Response gammaResponse = mobileClass.addCompany();
            if(gammaResponse.errorStatus) {
                return null;
            }
        }
        
        //add network services
        if(this.mobileData) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            GammaMobile_NetworkService ns1 = new GammaMobile_NetworkService();
            if(ns.addNetworkService('Mobile Data') && ns1.addNetworkService('4G')) {
                mobileClass.provision.config.networkServices.networkServices.add(ns);
                mobileClass.provision.config.networkServices.networkServices.add(ns1);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Mobile Data\' service. Please check reference Data'));
                return null;
            }
        }
        
        if(this.intlCallingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(ns.addNetworkService('International Calling')) {
            	mobileClass.provision.config.networkServices.networkServices.add(ns);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'International Calling\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_NetworkService ns: mobileClass.provision.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == GammaMobile_ReferenceData.refNetworkService.get('International Calling')) {
                    mobileClass.provision.config.networkServices.networkServices.remove(mobileClass.provision.config.networkServices.networkServices.indexOf(ns));
                    break;
                }
            }
        } 
        
        if(this.intlRoamingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(ns.addNetworkService('International Roaming')) {
            	mobileClass.provision.config.networkServices.networkServices.add(ns);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'International Roaming\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_NetworkService ns: mobileClass.provision.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == GammaMobile_ReferenceData.refNetworkService.get('International Roaming')) {
                    mobileClass.provision.config.networkServices.networkServices.remove(mobileClass.provision.config.networkServices.networkServices.indexOf(ns));
                    break;
                }
            }
        }
        
        if(this.dataRoamingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(ns.addNetworkService('Data Roaming')) {
            	mobileClass.provision.config.networkServices.networkServices.add(ns);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Data Romaing\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_NetworkService ns: mobileClass.provision.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == GammaMobile_ReferenceData.refNetworkService.get('Data Roaming')) {
                    mobileClass.provision.config.networkServices.networkServices.remove(mobileClass.provision.config.networkServices.networkServices.indexOf(ns));
                    break;
                }
            }
        }
        
        if(this.premiumService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(ns.addNetworkService('Premium Content')) {
            	mobileClass.provision.config.networkServices.networkServices.add(ns);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Premium Content\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_NetworkService ns: mobileClass.provision.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == GammaMobile_ReferenceData.refNetworkService.get('Premium Content')) {
                    mobileClass.provision.config.networkServices.networkServices.remove(mobileClass.provision.config.networkServices.networkServices.indexOf(ns));
                    break;
                }
            }
        }
        
        if (this.rowRoaming) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(ns.addNetworkService('International Roaming')) {
            	mobileClass.provision.config.networkServices.networkServices.add(ns);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'International Roaming\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_NetworkService ns: mobileClass.provision.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == GammaMobile_ReferenceData.refNetworkService.get('International Roaming')) {
                    mobileClass.provision.config.networkServices.networkServices.remove(mobileClass.provision.config.networkServices.networkServices.indexOf(ns));
                    break;
                }
            }
        }
        
        if(this.ukDataBolton != '' && this.ukDataBolton != null) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn(this.ukDataBolton)) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'' + this.ukDataBolton + '\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                Pattern pt = pattern.compile('DATA_.*');
                Matcher dataMatcher = pt.matcher(bo.selectedBoltOn);
                if (dataMatcher.matches()) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        //Add Business Boltons
        if(this.smartBusinessPack) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn('Smart Business Pack (combining: Non-Geographic 250, MMS 50 & International SMS 50)')) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Smart Business Pack (combining: Non-Geographic 250, MMS 50 & International SMS 50)\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == GammaMobile_ReferenceData.refBoltOn.get('Smart Business Pack (combining: Non-Geographic 250, MMS 50 & International SMS 50)')) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        if (this.intlVoiceEuNa) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn('Intl Voice Europe & North America')) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Intl Voice Europe & North America\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == GammaMobile_ReferenceData.refBoltOn.get('Intl Voice Europe & North America')) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        if (this.intlVoiceRow) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn('Intl Voice Rest Of World')) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Intl Voice Rest Of World\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == GammaMobile_ReferenceData.refBoltOn.get('Intl Voice Rest Of World')) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        if (this.worldWideData) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn('Worldwide Data 250MB')) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Worldwide Data 250MB\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == GammaMobile_ReferenceData.refBoltOn.get('Worldwide Data 250MB')) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        if (this.multinet) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(bo.addBoltOn('MultiNet')) {
            	mobileClass.provision.config.boltOns.boltOns.add(bo);
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to add \'Worldwide Data 250MB\' service. Please check reference Data'));
                return null;
            }
        } else {
            for (GammaMobile_BoltOn bo: mobileClass.provision.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == GammaMobile_ReferenceData.refBoltOn.get('MultiNet')) {
                    mobileClass.provision.config.boltOns.boltOns.remove(mobileClass.provision.config.boltOns.boltOns.indexOf(bo));
                    break;
                }
            }
        }
        
        mobileObj.Status__c = 'Provisioned';
        GammaMobile_Response response = this.mobileClass.mobileProvisionNew();
        if(response.errorStatus) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'API ERROR: ' + response.errorCode + ' - ' + response.errorMessage));
            return null;
        }
        insert mobileObj;
        this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'SIM ('+ mobileObj.Iccid__c +') provisioned successfully with mobile number ' + mobileObj.Msisdn__c));
        PageReference pg = new PageReference('/apex/GammaMobile_ProvisionList');
        pg.setRedirect(true);
        return pg;
    }
    
    public void loadMsisdnList () {
        this.availMsisdn = this.getAvailMsisdn();
    }
    
    public PageReference activateSim () {
        if(this.activateProvisionIccidVal == '' || this.activateProvisionMsisdnVal == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to activate SIM'));
            return null;
        }
        
        Gamma_Mobile__c[] mobObj = [SELECT Id, Status__c FROM Gamma_Mobile__c WHERE Iccid__c =:this.activateProvisionIccidVal OR Msisdn__c =:this.activateProvisionMsisdnVal];
        if (mobObj.size() == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to activate provision. Iccid/Mobile Number not valid'));
            return null;
        }
        
        GammaMobile mobCls = new GammaMobile();
        mobCls.iccid = this.activateProvisionIccidVal;
        mobCls.msisdn.value = this.activateProvisionMsisdnVal;
        
        GammaMobile_Response response = new GammaMobile_Response();        
        response = mobCls.mobileServiceActivate();
        
        if(response.errorStatus) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, response.errorCode + ' - ' + response.errorMessage));
            return null;
        }
        
        mobObj[0].Status__c = 'Active';
        update mobObj;
        this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Active'];
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'SIM Activated Successfully'));
        PageReference pg = new PageReference('/apex/GammaMobile_ProvisionList');
        pg.setRedirect(true);
        return null;
    }
    
    public PageReference newProvision () {
        PageReference pg = new PageReference('/apex/GammaMobile_NewOrder');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference cancelNewProvision () {
        PageReference pg = new PageReference('/apex/GammaMobile_ProvisionList');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference cancelProvision () {
        if(this.delProvisionIccidVal == '' || this.delProvisionMsisdnVal == '') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to delete provision'));
            return null;
        }
        
        Gamma_Mobile__c[] mobObj = [SELECT Id FROM Gamma_Mobile__c WHERE Iccid__c =:this.delProvisionIccidVal OR Msisdn__c =:this.delProvisionMsisdnVal];
        if (mobObj.size() == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Failed to delete provision. Iccid/Mobile Number not valid'));
            return null;
        }
        
        GammaMobile mobCls = new GammaMobile();
        mobCls.iccid = this.delProvisionIccidVal;
        mobCls.msisdn.value = this.delProvisionMsisdnVal;
        GammaMobile_Response response = mobCls.mobileProvisionCancel();
        
        if(response.errorStatus && response.httpResponseCode != 404) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, response.errorCode + ' - ' + response.errorMessage));
            return null;
        }
        
        delete mobObj;
        this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Sim provisioning order cancelled successfully'));
        return null;
    }
    
    public PageReference searchSims () {
        if (searchMobile == '' & searchIccid == '' & this.mobileObj.Contact__c == null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        } else if (searchMobile == '' & searchIccid == '' & this.mobileObj.Contact__c != null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Provisioned'];
        } else if (searchMobile == '' & searchIccid != '' & this.mobileObj.Contact__c == null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid) AND Status__c = 'Provisioned'];
        } else if (searchMobile == '' & searchIccid != '' & this.mobileObj.Contact__c != null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Provisioned'];
        } else if (searchMobile != '' & searchIccid == '' & this.mobileObj.Contact__c == null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Msisdn__c = :this.searchMobile) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Msisdn__c = :this.searchMobile) AND Status__c = 'Provisioned'];
        } else if (searchMobile != '' & searchIccid == '' & this.mobileObj.Contact__c != null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Msisdn__c = :this.searchMobile AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Msisdn__c = :this.searchMobile AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Provisioned'];
        } else if (searchMobile != '' & searchIccid != '' & this.mobileObj.Contact__c != null) {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Msisdn__c = :this.searchMobile) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Msisdn__c = :this.searchMobile) AND Status__c = 'Provisioned'];
    	} else {
            this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Msisdn__c = :this.searchMobile AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Active'];
            this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE (Iccid__c = :this.searchIccid AND Msisdn__c = :this.searchMobile AND Contact__c = :this.mobileObj.Contact__c) AND Status__c = 'Provisioned'];
        }
        
        return null;
    }
    
    public PageReference clearSearch () {
        this.searchMobile = '';
        this.searchIccid = '';
        this.mobileObj.Contact__c = null;
        this.activatedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Active'];
        this.provisionedList = [SELECT Id, Iccid__c, Msisdn__c, Status__c, Contact__r.Name FROM Gamma_Mobile__c WHERE Status__c = 'Provisioned'];
        return null;
    }
    
    public PageReference updateSim () {
        PageReference pg = new PageReference('/apex/GammaMobile_ServiceView?id=' + this.acctId);
        pg.setRedirect(true);
        return pg;
    }
    
}