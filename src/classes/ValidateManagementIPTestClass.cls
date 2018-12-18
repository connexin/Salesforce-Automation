@isTest
public class ValidateManagementIPTestClass {
	
    static testMethod void testValidation() {
        Management_Site__c managementSite = new Management_Site__c(Name='Test', Hostname__c='test.com', Subnet__c='10.22.0.128/25', VLAN__c=5, Latitude__c=1, Longitude__c=1, Range__c=1);
        
        insert managementSite;
        
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name='Test Device');
        Management_Device_Type__c managementDevice2 = new Management_Device_Type__c(Name='Test Siklu Device', PTP__c=true, Siklu_PTP__c=true);
        
        insert managementDevice;
        insert managementDevice2;
        
        Management_IP__c managementIP = new Management_IP__c(Name='10.22.0.159', Hostname__c='device1', Site__c=managementSite.Id, Device__c=managementDevice.Id);
        Management_IP__c managementIP2 = new Management_IP__c(Name='10.22.0.160', Hostname__c='device1', Site__c=managementSite.Id, Device__c=managementDevice.Id);
        Management_IP__c managementIP3 = new Management_IP__c(Name='10.22.0.159', Hostname__c='device2', Site__c=managementSite.Id, Device__c=managementDevice.Id);
        Management_IP__c managementIP4 = new Management_IP__c(Name='10.22.1.159', Hostname__c='device2', Site__c=managementSite.Id, Device__c=managementDevice.Id);
        Management_IP__c managementIP5 = new Management_IP__c(Name='10.22.1159', Hostname__c='device2', Site__c=managementSite.Id, Device__c=managementDevice.Id);
        
        Management_IP__c managementIP6 = new Management_IP__c(Name='10.22.0.130', Hostname__c='siklu', Site__c=managementSite.Id, Device__c=managementDevice2.Id, Siklu_Mode__c='master', Siklu_Channel_Bandwidth__c='500', Siklu_Tx_Frequency__c='71875');
        
        insert managementIP;
        
        try {
          	insert managementIP2;
            System.assert(false);
        } catch (DMLException e) {
            
        }
        
        try {
          	insert managementIP3;
            System.assert(false);
        } catch (DMLException e) {
            
        }
        
        try {
          	insert managementIP4;
            System.assert(false);
        } catch (DMLException e) {
            
        }
        
        try {
          	insert managementIP5;
            System.assert(false);
        } catch (DMLException e) {
            
        }
        
        insert managementIP6;
        
        Management_IP__c managementIP7 = new Management_IP__c(Name='10.22.0.131', Hostname__c='siklu2', Site__c=managementSite.Id, Device__c=managementDevice2.Id, Remote_Device__c=managementIP6.Id);
        
        insert managementIP7;
        
        managementIP7.Remote_Device__c = null;
        
        update managementIP7;
        
    }
    
}