trigger ManagementIPPortAssignmentValidation on Management_IP_Port_Assignment__c (before insert, before update) {
	Map<Id, List<Id>> portsInUse = new Map<Id, List<Id>>();
    List<Id> managementDeviceTypePortIds = new List<Id>();
    
    for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
        if (!portsInUse.containsKey(portAssignment.Management_IP__c)) {
            portsInUse.put(portAssignment.Management_IP__c, new List<Id>());
        }
        
        managementDeviceTypePortIds.add(portAssignment.Management_Device_Type_Port__c);
    }
    
    Map<Id, Management_Device_Type_Port__c> managementDeviceTypePorts = new Map<Id, Management_Device_Type_Port__c>([SELECT Id, PoE_Input__c, PoE_Output__c, Auto_Negotiation_Support__c, Port_Speed__c FROM Management_Device_Type_Port__c WHERE Id IN :managementDeviceTypePortIds]);
    
    List <Id> ports;
    for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Management_Device_Type_Port__c, Management_IP__c FROM Management_IP_Port_Assignment__c WHERE Management_IP__c IN :portsInUse.keySet()]) {
        if (trigger.isUpdate && trigger.newMap.keySet().contains(portAssignment.Id)) {
        	continue;
        }
        ports = portsInUse.get(portAssignment.Management_IP__c);
        ports.add(portAssignment.Management_Device_Type_Port__c);
        portsInUse.put(portAssignment.Management_IP__c, ports);
    }
    
    for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
        if (portsInUse.get(portAssignment.Management_IP__c).contains(portAssignment.Management_Device_Type_Port__c)) {
            portAssignment.Management_Device_Type_Port__c.addError('Port Assignment Record already Exists');
        } else {
	        ports = portsInUse.get(portAssignment.Management_IP__c);
    	    ports.add(portAssignment.Management_Device_Type_Port__c);
        	portsInUse.put(portAssignment.Management_IP__c, ports);
        }
        
        if (portAssignment.PoE_Input__c != null && managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c != null && !managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c.split(';').contains(portAssignment.PoE_Input__c)) {
        	portAssignment.PoE_Input__c.addError('PoE Input selection is Invalid for selected Management Device Type Port');
        }
        
        if (portAssignment.PoE_Output__c != null && managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Output__c != null && !managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Output__c.split(';').contains(portAssignment.PoE_Output__c)) {
        	portAssignment.PoE_Output__c.addError('PoE Output selection is Invalid for selected Management Device Type Port');
        }
        
        if (trigger.isInsert) {
        	portAssignment.Auto_Negotiate__c = managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).Auto_Negotiation_Support__c;
        }
        
        if (portAssignment.Port_Speed__c != null && portAssignment.Auto_Negotiate__c == false && managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).Port_Speed__c != null && !managementDeviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).Port_Speed__c.split(';').contains(portAssignment.Port_Speed__c)) {
        	portAssignment.Port_Speed__c.addError('Port Speed is Invalid for selected Management Device Type Port');
        }
    }
    
}