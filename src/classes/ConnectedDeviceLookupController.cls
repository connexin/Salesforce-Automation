public class ConnectedDeviceLookupController {

    public List<Management_IP__c> managementIPResults {get;set;}
    public Management_IP__c managementIP {get;set;}
    public Id managementIPId {
        get;
        set {
            managementIPId = value;
            if (value != null) {
                this.managementIP = [SELECT Id, Name, Domain__c, Device__c, Site__r.Name, Hostname__c FROM Management_IP__c WHERE Id = :value];
            }
        }
    }
    public List<ConnectedDevice> managementIPPortAssignmentResults {get;set;}
    public string searchString {get;set;}
    public Id currentDeviceId {get;set;}
    public Management_IP_Port_Assignment__c currentPortAssignment {get;set;}
    
    public ConnectedDeviceLookupController() {
        this.searchString = '';
        this.currentDeviceId = System.currentPageReference().getParameters().get('currentDeviceId');
        this.managementIPResults = this.performManagementIPSearch(this.searchString);
    }
    
    public PageReference search() {
        this.managementIPResults = this.performManagementIPSearch(searchString);
        return null;
    }
    
    public void unsetManagementIP() {
        this.managementIPId = null;
    }
    
    public PageReference setManagementIP() {
        this.managementIPPortAssignmentResults = this.performManagementIPPortAssignmentSearch('');
        return null;
    }
    
    public void createManagementIPPortAssignment () {
        Management_IP_Port_Assignment__c portAssignment = new Management_IP_Port_Assignment__c(Management_IP__c = Apexpages.currentPage().getParameters().get('curIP'), Management_Device_Type__c = Apexpages.currentPage().getParameters().get('curDeviceType'), Management_Device_Type_Port__c = Apexpages.currentPage().getParameters().get('curDevicePort'));
        insert portAssignment;
        this.currentPortAssignment = [SELECT Id, Name__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment.Id];
    }
    
    private List<Management_IP__c> performManagementIPSearch(String searchString) {
        String soql = 'SELECT Id, Name, Domain__c FROM Management_IP__c WHERE Active__c = true AND Id != \'' + this.currentDeviceId  + '\'';
        if (searchString != '' && searchString != null) {
            soql = soql + ' AND (Name LIKE \'%' + searchString +'%\' OR Domain__c LIKE \'%' + searchString +'%\')';
        }
        soql = soql + ' LIMIT 25';
        return database.query(soql); 
    }
    
    public List<ConnectedDevice> performManagementIPPortAssignmentSearch(String searchString) {
        
        List<ConnectedDevice> portAssignments = new List<ConnectedDevice>();
        for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Name__c, Management_Device_Type_Port__r.Name, Description__c, Connected_Device_Name__c FROM Management_IP_Port_Assignment__c WHERE Management_IP__c = :this.managementIPId]) {
            portAssignments.add(new ConnectedDevice(portAssignment.Id, portAssignment.Name__c, portAssignment.Description__c, portAssignment.Connected_Device_Name__c));
        }
        
        String name;
        for (Management_Device_Type_Port__c port : [SELECT Id, Name FROM Management_Device_Type_Port__c WHERE Management_Device_Type__c = :this.managementIP.Device__c AND Id NOT IN (SELECT Management_Device_Type_Port__c FROM Management_IP_Port_Assignment__c WHERE Management_IP__c = :this.managementIPId)]) {
            name = this.managementIP.Site__r.Name + ' ' + this.ManagementIP.Hostname__c + ' - Port ' + port.Name;
            portAssignments.add(new ConnectedDevice(this.managementIPId, this.managementIP.Device__c, port.Id, name));
        }
        
        //portAssignments.sort();
        
        /*String soql = 'SELECT Id, Management_Device_Type_Port__r.Name, Name__c FROM Management_IP_Port_Assignment__c WHERE Management_IP__c = \'' + this.managementIPId + '\'';
        if (searchString != '' && searchString != null) {
            soql = soql + ' AND Name LIKE \'%' + searchString +'%\'';
        }
        soql = soql + ' LIMIT 25';
        System.debug(soql);
        return database.query(soql);*/
        
        return portAssignments;
    }
    
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
    
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}