public class GammaMobileServiceViewController {
    public Id mobileId {get; set;}
    public ApexPages.StandardController stdController;
    public Gamma_Mobile__c mobileObj {get; set;}
    public GammaMobile mobileClass {get; set;}
    
    public List<SelectOption> tariffList {get; set;}
    public List<SelectOption> dataBoltonList {get; set;}
    public String ukDataBolton {get; set;}
    
    public List<SelectOption> rowRMCList {get; set;}
    public List<SelectOption> euRMCList {get; set;}
    
    public Boolean enableUpdate {get; set;}
    public Boolean updateAllConfig {get; set;}
    
    public Boolean mobileData {get; 
                               set {
                                   this.servicesUpdated = false;
                                   if(mobileData != value) {
                                       this.servicesUpdated = true;
                                   }
                                   mobileData = value;
                               }
                              }
    
    public Boolean intlCallingService {get; 
                               set {
                                   this.servicesUpdated = false;
                                   if(intlCallingService != value) {
                                       this.servicesUpdated = true;
                                   }
                                   intlCallingService = value;
                               }
                              }
    
    public Boolean intlRoamingService {get; 
                               set {
                                   this.servicesUpdated = false;
                                   if(intlRoamingService != value) {
                                       this.servicesUpdated = true;
                                   }
                                   intlRoamingService = value;
                               }
                              }
    
    public Boolean dataRoamingService {get; 
                               set {
                                   this.servicesUpdated = false;
                                   if(dataRoamingService != value) {
                                       this.servicesUpdated = true;
                                   }
                                   dataRoamingService = value;
                               }
                              }
    
    public Boolean premiumService {get; 
                               set {
                                   this.servicesUpdated = false;
                                   if(premiumService != value) {
                                       this.servicesUpdated = true;
                                   }
                                   premiumService = value;
                               }
                              }
    
    public Boolean sms250 {get; set;}
    public Boolean smartBusinessPack {get;set;}
    public Boolean euDailyBusinessTraveller {get; set;}
    public Boolean rowBusiness7DayTraveller {get; set;}
    public Boolean intlVoiceEuNa {get; set;}
    public Boolean intlVoiceRow {get; set;}
    public Boolean worldWideData {get; set;}
    public Boolean multiNet {get; set;}
    public Boolean dataSharer {get; set;}
    
    public Boolean barVoicemail {get; set;}
    public Boolean barIncomingCalls {get; set;}
    public Boolean barOutgoingCalls {get; set;}
    public Boolean barSendSms {get; set;}
    public Boolean barReceiveSms {get; set;}
    public Boolean barSendMms {get; set;}
    public Boolean barReceiveMms {get; set;}
    
    public Boolean notifyDataCap {get; set;}
    public Boolean notifyInitialData {get; set;}
    public Boolean notify80PercentDataReached {get;set;}
    
    public String rowRoamingMaxCharge {get; set;}
    public String euRoamingMaxCharge {get; set;}
    
    public Boolean tariffUpdated {get; set;}
    public Boolean servicesUpdated {get; set;}
    public Boolean boltOnsUpdated {get; set;}
    public Boolean barringUpdated {get; set;}
    public Boolean notificationsUpdated {get; set;}
    
    public String updatedtariff {get; 
                                 set {
                                     tariffUpdated = false;
                                     if(updatedtariff != value) {
                                         tariffUpdated = true;
                                     }
                                     updatedtariff = value;
                                 }
                                }
    
    public Boolean pageError {get; set;}
    
    public GammaMobileServiceViewController (ApexPages.StandardController controller) {
        this.stdController = controller;
        this.mobileObj = (Gamma_Mobile__c)stdController.getRecord();
        this.mobileClass = new GammaMobile();
        this.tariffList = new List<SelectOption>();
        this.dataBoltonList = new List<SelectOption>();
        this.rowRMCList = new List<SelectOption>();
        this.euRMCList = new List<SelectOption>();
        this.barVoicemail = false;
        this.barOutgoingCalls = false;
        this.barIncomingCalls = false;
        this.barSendSms = false;
        this.barReceiveSms = false;
        this.barSendMms = false;
        this.barReceiveMms = false;
        this.notifyDataCap = false;
        this.notifyInitialData = false;
        this.notify80PercentDataReached = false;
        this.rowRoamingMaxCharge = '';
        this.euRoamingMaxCharge = '';
        this.pageError = false;
        this.tariffUpdated = false;
        this.servicesUpdated = false;
        this.boltOnsUpdated = false;
        this.barringUpdated = false;
        this.notificationsUpdated = false;
        this.enableUpdate = false;
        this.updateAllConfig = false;
        this.mobileData = false;
        this.intlCallingService = false;
        this.intlRoamingService = false;
        this.premiumService = false;
        this.dataRoamingService = false;
        
        this.ukDataBolton = '';
        this.sms250 = false;
        this.smartBusinessPack = false;
        this.euDailyBusinessTraveller = false;
        this.rowBusiness7DayTraveller = false;
        this.intlVoiceEuNa = false;
        this.intlVoiceRow = false;
        this.worldWideData = false;
        this.multiNet = false;
        this.dataSharer = false;
        
        if(this.mobileObj.Id != null) {
            this.mobileObj = [SELECT Id, Iccid__c, Msisdn__c, Imei__c, Contact__c, Pac_Code__c, Port_Date__c FROM Gamma_Mobile__c WHERE Id =:this.mobileObj.Id];
            
            if(this.mobileObj != null && this.mobileObj.Msisdn__c != null) {
                this.mobileClass.iccid = mobileObj.Iccid__c;
                this.mobileClass.msisdn.value = mobileObj.Msisdn__c;
                GammaMobile_Response response = this.mobileClass.mobileServiceSearchService();
                if(response.errorStatus || this.mobileClass.service.status.selectedServiceStatus != 'ACTIVE') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Mobile Number ' + this.mobileObj.Msisdn__c + ' not found.'));
                    this.enableUpdate = false;
                } else {
                    this.enableUpdate = true;
                }
            }
            
            this.updatedTariff = this.mobileClass.service.tariff.tariffType.selectedTariffType;
            
            for(String tariffName: GammaMobile_ReferenceData.refTariffType.keySet()) {
                SelectOption tmpOpt = new SelectOption(GammaMobile_ReferenceData.refTariffType.get(tariffName), tariffName);
                tariffList.add(tmpOpt);
            }
            
            SelectOption empty = new SelectOption('', '');
            this.dataBoltonList.add(empty);
            for(String bolton: GammaMobile_ReferenceData.refBoltOn_Data.keySet()) {
                SelectOption tmpOpt = new SelectOption(GammaMobile_ReferenceData.refBoltOn_Data.get(bolton), bolton);
                this.dataBoltonList.add(tmpOpt);
            }
            
            this.rowRMCList.add(empty);
            for(String mcName: GammaMobile_ReferenceData.refRowRoamingMaxCharge.keySet()) {
                SelectOption tmpOpt = new SelectOption(GammaMobile_ReferenceData.refRowRoamingMaxCharge.get(mcName), mcName);
                this.rowRMCList.add(tmpOpt);
            }
            
            this.euRMCList.add(empty);
            for(String mcName: GammaMobile_ReferenceData.refEuRoamingMaxCharge.keySet()) {
                SelectOption tmpOpt = new SelectOption(GammaMobile_ReferenceData.refEuRoamingMaxCharge.get(mcName), mcName);
                this.euRMCList.add(tmpOpt);
            }
            
            for(GammaMobile_NetworkService ns: this.mobileClass.service.config.networkServices.networkServices) {
                if (ns.selectedNetworkService == 'DATA' || ns.selectedNetworkService == 'FOURTH_GENERATION') {
                    this.mobileData = true;
                } else if (ns.selectedNetworkService == 'INTERNATIONAL_CALLING') {
                    this.intlCallingService = true;
                } else if (ns.selectedNetworkService == 'INTERNATIONAL_ROAMING') {
                    this.intlRoamingService = true;
                } else if (ns.selectedNetworkService == 'DATA_WHEN_ROAMING') {
                    this.dataRoamingService = true;
                } else if (ns.selectedNetworkService == 'PREMIUM_CONTENT') {
                    this.premiumService =  true;
                } 
            }
            
            for(GammaMobile_BoltOn bo: this.mobileClass.service.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == 'DATA_2GB' || bo.selectedBoltOn == 'DATA_3GB' || bo.selectedBoltOn == 'DATA_5GB' || bo.selectedBoltOn == 'DATA_10GB' || bo.selectedBoltOn == 'DATA_20GB') {
                    this.ukDataBoltOn = bo.selectedBoltOn;
                } 
            }
            
            for(GammaMobile_BoltOn bo: this.mobileClass.service.config.boltOns.boltOns) {
                if (bo.selectedBoltOn == 'SMS') {
                    this.sms250 = true;
                } else if (bo.selectedBoltOn == 'SMART_BUSINESS_PACK') {
                    this.smartBusinessPack = true;
                } else if (bo.selectedBoltOn == 'EU_DAILY_BUSINESS_TRAVELLER') {
                    this.euDailyBusinessTraveller = true;
                } else if (bo.selectedBoltOn == 'ROW_BUSINESS_TRAVELLER') {
                    this.rowBusiness7DayTraveller = true;
                } else if (bo.selectedBoltOn == 'INTERNATIONAL_VOICE_EUROPE_NORTH_AMERICA') {
                    this.intlVoiceEuNa = true;
                } else if (bo.selectedBoltOn == 'INTERNATIONAL_VOICE_ROW') {
                    this.intlVoiceRow = true;
                } else if (bo.selectedBoltOn == 'WORLDWIDE_DATA') {
                    this.worldWideData = true;
                } else if (bo.selectedBoltOn == 'MULTINET') {
                    this.multiNet = true;
                } else if (bo.selectedBoltOn == 'DATA_SHARER_ENABLER') {
                    this.dataSharer = true;
                }
            }
            
            for (GammaMobile_NetworkBar nb: this.mobileClass.service.config.networkBars.networkBars) {
                if (nb.selectedNetworkBar == 'VOICEMAIL') {
                    this.barVoicemail = true;
                } else if (nb.selectedNetworkBar == 'INCOMING_CALLS') {
                    this.barIncomingCalls = true;
                } else if (nb.selectedNetworkBar == 'OUTGOING_CALLS') {
                    this.barOutgoingCalls = true;
                } else if (nb.selectedNetworkBar == 'INCOMING_SMS') {
                    this.barReceiveSms = true;
                } else if (nb.selectedNetworkBar == 'OUTGOING_SMS') {
                    this.barSendSms = true;
                } else if (nb.selectedNetworkBar == 'INCOMING_MMS') {
                    this.barReceiveMms = true;
                } else if (nb.selectedNetworkBar == 'OUTGOING_MMS') {
                    this.barSendMms = true;
                }
            }
            
            for(GammaMobile_NotificationOption no: this.mobileClass.service.config.roamingConfig.notificationOptions.notificationOptions) {
                if (no.selectedNotificationOption == 'DATA_CAP') {
                    this.notifyDataCap = true;
                } else if (no.selectedNotificationOption == 'INITIAL_DATA') {
                    this.notifyInitialData = true;
                } else if (no.selectedNotificationOption == 'PERCENTAGE_LIMIT_REACHED') {
                    this.notify80PercentDataReached = true;
                }
            }
            
            this.euRoamingMaxCharge = this.mobileClass.service.config.roamingConfig.euRoamingMaxCharge.selectedEuRoamingMaxCharge;
            this.rowRoamingMaxCharge = this.mobileClass.service.config.roamingConfig.rowRoamingMaxCharge.selectedRowRoamingMaxCharge;
        }
    }
    
    public void updateMain () {
        GammaMobile_Response gammaResponse = new GammaMobile_Response();
        if(this.tariffUpdated) {
            this.mobileClass.service.tariff.tariffType.selectedtariffType = updatedTariff;
            gammaResponse = this.mobileClass.mobileServiceChangeTariff();
            if (gammaResponse.errorStatus) {
                this.pageError = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update Tariff: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
                return;
            } else {
                if (!this.updateAllConfig) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Tariff Updated successfully. Changes will take effect in a few minutes'));
                    this.mobileClass.mobileServiceSearchService();
                }
            }
        }
        update this.mobileObj;
        this.mobileObj = [SELECT Id, Iccid__c, Msisdn__c, Imei__c, Contact__c, Pac_Code__c, Port_Date__c FROM Gamma_Mobile__c WHERE Id =:this.mobileObj.Id];
    }
    
    public void updateServices () {
        GammaMobile_NetworkServices networkServices = new GammaMobile_NetworkServices();
        if (this.mobileData) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            ns.selectedNetworkService = 'DATA';
            GammaMobile_NetworkService ns1 = new GammaMobile_NetworkService();
            ns1.selectedNetworkService = 'FOURTH_GENERATION';
            networkServices.networkServices.add(ns);
            networkServices.networkServices.add(ns1);
        }
        
        if (this.intlCallingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            ns.selectedNetworkService = 'INTERNATIONAL_CALLING';
            networkServices.networkServices.add(ns);
        }
        
        if (this.intlRoamingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            ns.selectedNetworkService = 'INTERNATIONAL_ROAMING';
            networkServices.networkServices.add(ns);
        }
        
        if (this.premiumService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            ns.selectedNetworkService = 'PREMIUM_CONTENT';
            networkServices.networkServices.add(ns);
        }
        
        if (this.dataRoamingService) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            ns.selectedNetworkService = 'DATA_WHEN_ROAMING';
            networkServices.networkServices.add(ns);
        }
        
        this.mobileClass.service.config.networkServices = networkServices;
        if (this.updateAllConfig) {
            return;
        }
        GammaMobile_Response gammaResponse = this.mobileClass.mobileServiceUpdateNetworkServices();
        if(gammaResponse.errorStatus) {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update NetworkServices: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
            return;
        } else {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Services updated successfully. Changes will take effect in a few minutes'));
            PageReference pg = new PageReference('/apex/GammaMobile_ServiceView?id=' + this.mobileObj.Id);
            pg.setRedirect(true);
            return;
        }
    }
    
    public void updateBoltOns () {
        GammaMobile_BoltOns boltOns = new GammaMobile_BoltOns();
        
        GammaMobile_BoltOn dataBoltOn = new GammaMobile_BoltOn();
        dataBoltOn.selectedBoltOn = this.ukDataBoltOn;
        boltOns.boltOns.add(dataBoltOn);
        
        if(this.sms250) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'SMS';
            boltOns.boltOns.add(bo);
        }
        
        if(this.smartBusinessPack) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'SMART_BUSINESS_PACK';
            boltOns.boltOns.add(bo);
        }
        
        if(this.euDailyBusinessTraveller) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'EU_DAILY_BUSINESS_TRAVELLER';
            boltOns.boltOns.add(bo);
        }
        
        if (this.rowBusiness7DayTraveller) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'ROW_BUSINESS_TRAVELLER';
            boltOns.boltOns.add(bo);
        }
        
        if (this.intlVoiceEuNa) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'INTERNATIONAL_VOICE_EUROPE_NORTH_AMERICA';
            boltOns.boltOns.add(bo);
        }
        
        if (this.intlVoiceRow) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'INTERNATIONAL_VOICE_ROW';
            boltOns.boltOns.add(bo);
        }
        
        if (this.worldWideData) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'WORLDWIDE_DATA';
            boltOns.boltOns.add(bo);
        }
        
        if(this.multiNet) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'MULTINET';
            boltOns.boltOns.add(bo);
        }

        if (this.dataSharer) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            bo.selectedBoltOn = 'DATA_SHARER_ENABLER';
            boltOns.boltOns.add(bo);
        }
        
        this.mobileClass.service.config.boltons = boltOns;
        if (this.updateAllConfig) {
            return;
        }
        GammaMobile_Response gammaResponse = this.mobileClass.mobileServiceUpdateBoltOns();
        if(gammaResponse.errorStatus) {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update BoltOns: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
            return;
        } else {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'BoltOns updated successfully. Changes will take effect in a few minutes'));
            return;
        }
    }
    
    public void updateBarring () {
        GammaMobile_NetworkBars networkBars = new GammaMobile_NetworkBars();
        
        if (this.barVoicemail) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'VOICEMAIL';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barIncomingCalls) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'INCOMING_CALLS';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barOutgoingCalls) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'OUTGOING_CALLS';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barSendSms) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'OUTGOING_SMS';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barReceiveSms) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'INCOMING_SMS';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barSendMms) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'OUTGOING_MMS';
            networkBars.networkBars.add(nb);
        }
        
        if (this.barReceiveMms) {
            GammaMobile_NetworkBar nb = new GammaMobile_NetworkBar();
            nb.selectedNetworkBar = 'INCOMING_MMS';
            networkBars.networkBars.add(nb);
        }
        
        this.mobileClass.service.config.networkBars = networkBars;
        if (this.updateAllConfig) {
            return;
        }
        GammaMobile_Response gammaResponse = this.mobileClass.mobileServiceUpdateNetworkBars();
        if(gammaResponse.errorStatus) {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update Network Bars: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
            return;
        } else {
            this.pageError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Network Bars updated successfully. Changes will take effect in a few minutes'));
            return;
        }
    }
    
    public void updateRoamingConfig () {
        GammaMobile_RoamingConfiguration roamingConfig = new GammaMobile_RoamingConfiguration();
        GammaMobile_EuRoamingMaxCharge euRMC = new GammaMobile_EuRoamingMaxCharge();
        GammaMobile_RowRoamingMaxCharge rowRMC = new GammaMobile_RowRoamingMaxCharge();
        
        euRMC.selectedEuRoamingMaxCharge = this.euRoamingMaxCharge;
        rowRMC.selectedRowRoamingMaxCharge = this.rowRoamingMaxCharge;
        
        GammaMobile_NotificationOptions notificationOptions = new GammaMobile_NotificationOptions();
        
        if (this.notifyDataCap) {
            GammaMobile_NotificationOption no = new GammaMobile_NotificationOption();
            no.selectedNotificationOption = 'DATA_CAP';
            notificationOptions.notificationOptions.add(no);
        }
        
        if (this.notifyInitialData) {
            GammaMobile_NotificationOption no = new GammaMobile_NotificationOption();
            no.selectedNotificationOption = 'INITIAL_DATA';
            notificationOptions.notificationOptions.add(no);
        }
        
        if (this.notify80PercentDataReached) {
            GammaMobile_NotificationOption no = new GammaMobile_NotificationOption();
            no.selectedNotificationOption = 'PERCENTAGE_LIMIT_REACHED';
            notificationOptions.notificationOptions.add(no);
        }
        
        
        roamingConfig.euRoamingMaxCharge = euRMC;
        roamingConfig.rowRoamingMaxCharge = rowRMC;
        roamingConfig.notificationOptions = notificationOptions;
        
        this.mobileClass.service.config.roamingConfig = roamingConfig;
        if (this.updateAllConfig) {
            return;
        }
        GammaMobile_Response gammaResponse = this.mobileClass.mobileServiceUpdateRoamingConfig();
        if(gammaResponse.errorStatus) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update Notifications: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Notifications updated successfully. Changes will take effect in a few minutes'));
        }
    }
    
    /*public void updateAll () {
        this.updateAllConfig = true;
        this.updateRoamingConfig();
        this.updateBarring();
        this.updateBoltOns();
        this.updateServices();
        //this.updateMain();
        this.updateAllConfig = false;
        
        GammaMobile_Response gammaResponse = this.mobileClass.mobileServiceUpdateConfiguration();
        if(gammaResponse.errorStatus) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Failed to update Configuration: ' + gammaResponse.errorCode + ' - ' + gammaResponse.errorMessage));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Configuration updated successfully. Changes will take effect in a few minutes'));
        }
        
    }*/
    
    public PageReference cancelUpdate () {
        PageReference pg = new PageReference('/apex/GammaMobile_ProvisionList');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference reload () {
        PageReference pg = new PageReference('/apex/GammaMobile_ServiceView?id=' + this.mobileObj.Id);
        pg.setRedirect(true);
        return pg;
    }
}