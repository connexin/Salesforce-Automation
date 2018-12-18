public class ManagementIPController {
        
    private Management_IP__c managementIP;
    public Management_IP__c clonedManagementIP {get;set;}
    public String freeIP {get;set;}
    public Decimal sikluTxLinkId {get;set;}
    public Decimal sikluRxLinkId {get;set;}
    private ApexPages.StandardController stdController;
    private Set<String> usedIPs = new Set<String>();
    private Set<Decimal> usedSikluLinkIds = new Set<Decimal>();
    
    public ManagementIPController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.managementIP = (Management_IP__c)this.stdController.getRecord();
        if (this.managementIP.Id != null) {
            for (Management_IP__c temp : [SELECT Name FROM Management_IP__c WHERE Id = :this.managementIP.Id]) {
                this.managementIP.Name = temp.Name;
                break;
            }
            this.freeIP = this.managementIP.Name;
        }
        remoteDeviceChanged();
    }
    
    public PageReference cloneRecord() {
        this.clonedManagementIP = this.managementIP.clone(false, true, false, false);
        this.freeIP = ManagementSiteClass.getFreeIPAddress(this.managementIP.Site__c);
        
        return new PageReference('/apex/ManagementIPClone');
    }
    
    public void generateIP() {
        if (this.managementIP.Site__c != null) {
                usedIPs.add(this.freeIP);
                this.freeIP = ManagementSiteClass.getFreeIPAddress(this.managementIP.Site__c, usedIPs);
        }
    }
    
    public void generateSikluLinkIds() {
        if (this.managementIP.Site__c != null) {
            usedSikluLinkIds.add(this.managementIP.Siklu_Tx_Link_Id__c);
            usedSikluLinkIds.add(this.managementIP.Siklu_Rx_Link_Id__c);
            this.managementIP.Siklu_Tx_Link_Id__c = ManagementSiteClass.getFreeSikluLinkId(this.managementIP.Site__c, usedSikluLinkIds);
            usedSikluLinkIds.add(this.managementIP.Siklu_Tx_Link_Id__c);
            this.managementIP.Siklu_Rx_Link_Id__c = ManagementSiteClass.getFreeSikluLinkId(this.managementIP.Site__c, usedSikluLinkIds);
        }
    }
    
    public boolean getPTP() {
        if (this.managementIP.Device__c != null) {
            Management_Device_Type__c device = [SELECT PTP__c FROM Management_Device_Type__c WHERE Id = :this.managementIP.Device__c];
            return device.PTP__c;
        }
        return false;
    }
    
    public boolean getSikluPTP() {
        if (this.managementIP.Device__c != null) {
            Management_Device_Type__c device = [SELECT Siklu_PTP__c FROM Management_Device_Type__c WHERE Id = :this.managementIP.Device__c];
            return device.Siklu_PTP__c;
        }
        return false;
    }
    
    public void remoteDeviceChanged() {
        if (this.managementIP.Remote_Device__c != null) {
            Management_IP__c remoteDevice = [SELECT Siklu_Tx_Link_Id__c, Siklu_Rx_Link_Id__c FROM Management_IP__c WHERE Id = :this.managementIP.Remote_Device__c];
            this.sikluTxLinkId = remoteDevice.Siklu_Rx_Link_Id__c;
            this.sikluRxLinkId = remoteDevice.Siklu_Tx_Link_Id__c;
        }
    }
    
    public PageReference save() {
        this.managementIP.Name = this.freeIP;
        return this.stdController.save();
    }
    
    public PageReference saveClone() {
        this.clonedManagementIP.Name = this.freeIP;
        try {
                insert this.clonedManagementIP;
        } catch (Exception e) {
                ApexPages.addMessages(e);
                        return null;
        }
        
        return new PageReference('/' + this.clonedManagementIP.Id);
    }
        
}