@isTest
public class ManagementIPControllerTestClass {
	
    static testMethod void testManagementIPController() {
        Management_Site__c managementSite = new Management_Site__c(Name='Test', Hostname__c='test.com', Subnet__c='10.22.0.128/30', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
    	insert managementSite;
        
        Management_Device_Type__c managementDeviceType = new Management_Device_Type__c(Name='test');
        insert managementDeviceType;
        
        Management_IP__c managementIP = new Management_IP__c(Name='10.22.0.129', Site__c=managementSite.Id, Hostname__c='test', Device__c=managementDeviceType.Id);
        insert managementIP;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(managementIP);
        ManagementIPController managementIPController = new ManagementIPController(stdController);
        
        managementIPController.generateIP();
        managementIPController.cloneRecord();
        managementIPController.save();
        managementIPController.saveClone();
    }
    
}