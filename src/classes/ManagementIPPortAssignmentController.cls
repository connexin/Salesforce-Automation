public class ManagementIPPortAssignmentController {
    
    private ApexPages.StandardController stdController;
    private Management_IP_Port_Assignment__c managementIPPortAssignment;
        
    public ManagementIPPortAssignmentController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.managementIPPortAssignment = (Management_IP_Port_Assignment__c)this.stdController.getRecord();
        if (System.currentPageReference().getParameters().get('parentId') != null) {
            this.managementIPPortAssignment.Management_IP__c = System.currentPageReference().getParameters().get('parentId');
        }
        if (this.managementIPPortAssignment.Management_IP__c != null) {
            this.setManagementDeviceType();
        }
    }
    
    public void setManagementDeviceType() {
        Management_IP__c managementIP = [SELECT Id, Device__c FROM Management_IP__c WHERE Id = :this.managementIPPortAssignment.Management_IP__c];
        this.managementIPPortAssignment.Management_Device_Type__c = managementIP.Device__c;
    }
    
    public String getManagementIPPortAssignmentKeyPrefix() {
        return Schema.getGlobalDescribe().get('Management_IP_Port_Assignment__c').getDescribe().getKeyPrefix();
    }
    
}