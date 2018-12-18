@isTest
public class ValidateManagementSiteTestClass {
	
    static testMethod void testValidation() {
        Management_Site__c managementSite = new Management_Site__c(Name='Test', Hostname__c='test.com', Subnet__c='10.22.0.192/26', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
        Management_Site__c managementSite2 = new Management_Site__c(Name='Test2', Hostname__c='test.com2', Subnet__c='10.22.0.0/32', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
        Management_Site__c managementSite3 = new Management_Site__c(Name='Test3', Hostname__c='test.com3', Subnet__c='10.22.0.0/35', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
        Management_Site__c managementSite4 = new Management_Site__c(Name='Test3', Hostname__c='test.com3', Subnet__c='10.22.0.129/25', VLAN__c=5, Latitude__c=-1, Longitude__c=-1, Range__c=1);
        
        insert managementSite;
        insert managementSite2;
        
        try {
          	insert managementSite3;
            System.assert(false);
        } catch (DMLException e) {
            
        }
        
        try {
          	insert managementSite4;
            System.assert(false);
        } catch (DMLException e) {
            
        }
    }
    
}