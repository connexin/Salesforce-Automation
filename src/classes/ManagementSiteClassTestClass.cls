@isTest
public class ManagementSiteClassTestClass {
    
    static testMethod void testGetFreeIPAddress() {
    	Management_Site__c managementSite = new Management_Site__c(Name='Test', Hostname__c='test.com', Subnet__c='10.22.0.128/30', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
    	insert managementSite;
    	
    	System.assertEquals(ManagementSiteClass.getFreeIPAddress(managementSite.Id), '10.22.0.129');
        System.assertEquals(ManagementSiteClass.getFreeIPAddress(managementSite.Id, new Set<String>{'10.22.0.129'}), '10.22.0.130');
        System.assertEquals(ManagementSiteClass.getFreeIPAddress(managementSite.Id, new Set<String>{'10.22.0.129', '10.22.0.130'}), null);
        
        Management_Device_Type__c managementDeviceType = new Management_Device_Type__c(Name='test');
        insert managementDeviceType;
        
        Management_IP__c managementIP = new Management_IP__c(Name='10.22.0.129', Site__c=managementSite.Id, Hostname__c='test', Device__c=managementDeviceType.Id);
        insert managementIP;
        
        System.assertEquals(ManagementSiteClass.getFreeIPAddress(managementSite.Id), '10.22.0.130');
        
        Management_Site__c managementSite2 = new Management_Site__c(Name='Test2', Hostname__c='test2.com', Subnet__c='10.22.0.128/32', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
    	insert managementSite2;
        
        System.assertEquals(ManagementSiteClass.getFreeIPAddress(managementSite2.Id), null);
    }
    
    
}