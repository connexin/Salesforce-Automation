@isTest
public class ManagementIPPortAssignmentTestCode {
	
    static testMethod void testUpdateConnectedDeviceTrigger() {
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name = 'test device');
        insert managementDevice;
        
        Management_Device_Type_Port__c managementDeviceTypePort1 = new Management_Device_Type_Port__c(Name = '0/1', Management_Device_Type__c = managementDevice.Id, PoE_Input__c = '24V', Auto_Negotiation_Support__c = true, Port_Speed__c = '1000M;100M-Full');
        Management_Device_Type_Port__c managementDeviceTypePort2 = new Management_Device_Type_Port__c(Name = '0/2', Management_Device_Type__c = managementDevice.Id, PoE_Output__c = '24V', Auto_Negotiation_Support__c = true, Port_Speed__c = '1000M;100M-Full');
        insert managementDeviceTypePort1;
        insert managementDeviceTypePort2;
        
        Management_Site__c managementSite = new Management_Site__c(Name = 'test site', Subnet__c = '10.22.1.0/25');
        insert managementSite;
        
        Management_IP__c managementIP1 = new Management_IP__c(Name = '10.22.1.1', Hostname__c = 'test', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        Management_IP__c managementIP2 = new Management_IP__c(Name = '10.22.1.2', Hostname__c = 'test2', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        insert managementIP1;
        insert managementIP2;
        
        Management_IP_Port_Assignment__c portAssignment11 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        Management_IP_Port_Assignment__c portAssignment12 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort2.Id);
        Management_IP_Port_Assignment__c portAssignment21 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP2.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        
        insert portAssignment11;
        insert portAssignment12;
        insert portAssignment21;
        
        portAssignment11.Connected_Device__c = portAssignment21.Id;
        update portAssignment11;
        
        for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Connected_Device__c, Auto_Negotiate__c, Port_Speed__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment11.Id OR Id = :portAssignment21.Id]) {
        	if (portAssignment.Id == portAssignment11.Id) {
        		portAssignment11 = portAssignment;
        	} else if (portAssignment.Id == portAssignment21.Id) {
        		portAssignment21 = portAssignment;
        	}
        }
        
        System.assertEquals(portAssignment11.Id, portAssignment21.Connected_Device__c);
        System.assertEquals(portAssignment21.Id, portAssignment11.Connected_Device__c);
        
        System.assertEquals(portAssignment11.Auto_Negotiate__c, true);
        System.assertEquals(portAssignment11.Port_Speed__c, '1000M');
        System.assertEquals(portAssignment21.Auto_Negotiate__c, true);
        System.assertEquals(portAssignment21.Port_Speed__c, '1000M');
        
        portAssignment12.Connected_Device__c = portAssignment21.Id;
        portAssignment12.Auto_Negotiate__c = false;
        update portAssignment12;
        
        for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Connected_Device__c, Auto_Negotiate__c, Port_Speed__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment11.Id OR Id = :portAssignment12.Id OR Id = :portAssignment21.Id]) {
        	if (portAssignment.Id == portAssignment11.Id) {
        		portAssignment11 = portAssignment;
        	} else if (portAssignment.Id == portAssignment12.Id) {
        		portAssignment12 = portAssignment;
        	} else if (portAssignment.Id == portAssignment21.Id) {
        		portAssignment21 = portAssignment;
        	}
        }
        
        System.assertEquals(null, portAssignment11.Connected_Device__c);
        System.assertEquals(portAssignment12.Connected_Device__c, portAssignment21.Id);
        System.assertEquals(portAssignment21.Connected_Device__c, portAssignment12.Id);
        
        System.assertEquals(portAssignment12.Auto_Negotiate__c, false);
        System.assertEquals(portAssignment12.Port_Speed__c, '1000M');
        System.assertEquals(portAssignment21.Auto_Negotiate__c, true);
        System.assertEquals(portAssignment21.Port_Speed__c, null);
       	
        portAssignment21.Connected_Device__c = null;
        update portAssignment21;
        
        for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Connected_Device__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment12.Id OR Id = :portAssignment21.Id]) {
        	if (portAssignment.Id == portAssignment12.Id) {
        		portAssignment12 = portAssignment;
        	} else if (portAssignment.Id == portAssignment21.Id) {
        		portAssignment21 = portAssignment;
        	}
        }
        
        System.assertEquals(null, portAssignment12.Connected_Device__c);
        System.assertEquals(null, portAssignment21.Connected_Device__c);
        
        portAssignment11.Connected_Device__c = portAssignment21.Id;
        update portAssignment11;
        
        for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Connected_Device__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment11.Id OR Id = :portAssignment21.Id]) {
        	if (portAssignment.Id == portAssignment11.Id) {
        		portAssignment11 = portAssignment;
        	} else if (portAssignment.Id == portAssignment21.Id) {
        		portAssignment21 = portAssignment;
        	}
        }
        
        System.assertEquals(portAssignment11.Id, portAssignment21.Connected_Device__c);
        System.assertEquals(portAssignment21.Id, portAssignment11.Connected_Device__c);
    }
    
    static testMethod void testUpdateConnectedDeviceTriggerMethod2() {
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name = 'test device');
        insert managementDevice;
        
        Management_Device_Type_Port__c managementDeviceTypePort1 = new Management_Device_Type_Port__c(Name = '0/1', Management_Device_Type__c = managementDevice.Id, PoE_Input__c = '24V');
        Management_Device_Type_Port__c managementDeviceTypePort2 = new Management_Device_Type_Port__c(Name = '0/2', Management_Device_Type__c = managementDevice.Id, PoE_Output__c = '24V');
        insert managementDeviceTypePort1;
        insert managementDeviceTypePort2;
        
        Management_Site__c managementSite = new Management_Site__c(Name = 'test site', Subnet__c = '10.22.1.0/25');
        insert managementSite;
        
        Management_IP__c managementIP1 = new Management_IP__c(Name = '10.22.1.1', Hostname__c = 'test', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        Management_IP__c managementIP2 = new Management_IP__c(Name = '10.22.1.2', Hostname__c = 'test2', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        insert managementIP1;
        insert managementIP2;
        
        Management_IP_Port_Assignment__c portAssignment11 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        Management_IP_Port_Assignment__c portAssignment21 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP2.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        
        insert portAssignment11;
        insert portAssignment21;
        
        portAssignment11.Connected_Device__c = portAssignment21.Id;
        update portAssignment11;
        
        portAssignment21 = [SELECT Id, Connected_Device__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment21.Id];
        System.assertEquals(portAssignment11.Id, portAssignment21.Connected_Device__c);
        
        delete portAssignment11;
        
        portAssignment21 = [SELECT Id, Connected_Device__c FROM Management_IP_Port_Assignment__c WHERE Id = :portAssignment21.Id];
        
        System.assertEquals(null, portAssignment21.Connected_Device__c);
    }
    
    static testMethod void testManagementIPPortAssignmentValidation() {
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name = 'test device');
        insert managementDevice;
        
        Management_Device_Type_Port__c managementDeviceTypePort1 = new Management_Device_Type_Port__c(Name = '0/1', Management_Device_Type__c = managementDevice.Id);
        insert managementDeviceTypePort1;
        
        Management_Site__c managementSite = new Management_Site__c(Name = 'test site', Subnet__c = '10.22.1.0/25');
        insert managementSite;
        
        Management_IP__c managementIP1 = new Management_IP__c(Name = '10.22.1.1', Hostname__c = 'test', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        insert managementIP1;
        
        Management_IP_Port_Assignment__c portAssignment11 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        Management_IP_Port_Assignment__c portAssignment12 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        
        insert portAssignment11;
        
        try {
            insert portAssignment12;
            System.assert(false);
        } catch (DMLException e) {
            
        }
    }
    
    static testMethod void testManagementIPPortAssignmentController() {
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name = 'test device');
        insert managementDevice;
        
        Management_Device_Type_Port__c managementDeviceTypePort1 = new Management_Device_Type_Port__c(Name = '0/1', Management_Device_Type__c = managementDevice.Id);
        insert managementDeviceTypePort1;
        
        Management_Site__c managementSite = new Management_Site__c(Name = 'test site', Subnet__c = '10.22.1.0/25');
        insert managementSite;
        
        Management_IP__c managementIP1 = new Management_IP__c(Name = '10.22.1.1', Hostname__c = 'test', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        insert managementIP1;
        
        Management_IP_Port_Assignment__c portAssignment1 = new Management_IP_Port_Assignment__c(Management_IP__c = managementIP1.Id, Management_Device_Type__c = managementDevice.Id, Management_Device_Type_Port__c = managementDeviceTypePort1.Id);
        
        insert portAssignment1;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(portAssignment1);
        ManagementIPPortAssignmentController controller = new ManagementIPPortAssignmentController(stdController);
        
        System.assertEquals(Schema.getGlobalDescribe().get('Management_IP_Port_Assignment__c').getDescribe().getKeyPrefix(), controller.getManagementIPPortAssignmentKeyPrefix());
    }
    
    static testMethod void testConnectedDeviceLookupController() {
        Management_Device_Type__c managementDevice = new Management_Device_Type__c(Name = 'test device');
        insert managementDevice;
        
        Management_Device_Type_Port__c managementDeviceTypePort1 = new Management_Device_Type_Port__c(Name = '0/1', Management_Device_Type__c = managementDevice.Id);
        insert managementDeviceTypePort1;
        
        Management_Site__c managementSite = new Management_Site__c(Name = 'test site', Subnet__c = '10.22.1.0/25');
        insert managementSite;
        
        Management_IP__c managementIP1 = new Management_IP__c(Name = '10.22.1.1', Hostname__c = 'test', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        Management_IP__c managementIP2 = new Management_IP__c(Name = '10.22.1.2', Hostname__c = 'test2', Device__c = managementDevice.Id, Site__c = managementSite.Id);
        insert managementIP1;
        insert managementIP2;
        
        System.currentPageReference().getParameters().put('currentDeviceId', managementIP1.Id);
        System.currentPageReference().getParameters().put('frm', 'frm');
        System.currentPageReference().getParameters().put('txt', 'txt');
        ConnectedDeviceLookupController controller = new ConnectedDeviceLookupController();
        controller.searchString = 'test';
        controller.search();
        
        controller.managementIPId = managementIP2.Id;
		controller.setManagementIP();
        
        System.assertEquals('frm', controller.getFormTag());
        System.assertEquals('txt', controller.getTextBox());
        
        controller.unsetManagementIP();
        controller.managementIPId = managementIP2.Id;
		controller.setManagementIP();
        
        System.currentPageReference().getParameters().put('curIP', managementIP2.Id);
        System.currentPageReference().getParameters().put('curDeviceType', managementDevice.Id);
        System.currentPageReference().getParameters().put('curDevicePort', managementDeviceTypePort1.Id);
        
        controller.createManagementIPPortAssignment();
    }
    
}