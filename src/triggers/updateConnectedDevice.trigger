trigger updateConnectedDevice on Management_IP_Port_Assignment__c (after insert, after update, after delete) {
    Map<Id, Management_IP_Port_Assignment__c> portAssignmentsToUpdate = new Map<Id, Management_IP_Port_Assignment__c>();
    Map<Id, Management_Device_Type_Port__c> deviceTypePorts;
    Map<Id, Management_IP_Port_Assignment__c> remotePortAssignments;
    Management_IP_Port_Assignment__c curPortAssignment;
    
    if (trigger.isInsert || trigger.isUpdate) {
        for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
        	if (trigger.isUpdate && trigger.oldMap.get(portAssignment.Id).Skip_Update_Remote__c == true && portAssignment.Skip_Update_Remote__c == false) {
        		continue;
        	}
            
            //Update the old remote device to point to null
            if (trigger.isUpdate && portAssignment.Connected_Device__c != trigger.oldMap.get(portAssignment.Id).Connected_Device__c && trigger.oldMap.get(portAssignment.Id).Connected_Device__c != null && portAssignment.Skip_Update_Remote__c == false) {
                portAssignmentsToUpdate.put(trigger.oldMap.get(portAssignment.Id).Connected_Device__c, new Management_IP_Port_Assignment__c(Id = trigger.oldMap.get(portAssignment.Id).Connected_Device__c, Connected_Device__c = null, Skip_Update_Remote__c = true));
            }
            
            if (portAssignment.Skip_Update_Remote__c == true) {
                portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, Skip_Update_Remote__c = false));
                continue;
            }
            
            //Update the remote device to point at the local device
            if (portAssignment.Connected_Device__c != null && (trigger.isInsert || portAssignment.Connected_Device__c != trigger.oldMap.get(portAssignment.Id).Connected_Device__c || portAssignment.Auto_Set_PoE__c != trigger.oldMap.get(portAssignment.Id).Auto_Set_PoE__c)) {
            	portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, new Management_IP_Port_Assignment__c(Id = portAssignment.Connected_Device__c, Connected_Device__c = portAssignment.Id, Auto_Set_PoE__c = portAssignment.Auto_Set_PoE__c));
            }
        }
        
        List<Id> remotePortAssignmentIds = new List<Id>();
        
        for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
            if (portAssignment.Connected_Device__c == null) {
                continue;
            }
            
            remotePortAssignmentIds.add(portAssignment.Connected_Device__c);
        }
        
        remotePortAssignments = new Map<Id, Management_IP_Port_Assignment__c>([SELECT Id, Management_Device_Type_Port__c, PoE_Input__c, PoE_Output__c, Auto_Negotiate__c, Port_Speed__c FROM Management_IP_Port_Assignment__c WHERE Id IN :remotePortAssignmentIds]);
        
        List<Id> deviceTypePortIds = new List<Id>();
        
        for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
            if (portAssignment.Connected_Device__c == null) {
                continue;
            }
            
            deviceTypePortIds.add(portAssignment.Management_Device_Type_Port__c);
            deviceTypePortIds.add(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c);
        }
        
        deviceTypePorts = new Map<Id, Management_Device_Type_Port__c>([SELECT Id, PoE_Input__c, PoE_Output__c, Port_Speed__c FROM Management_Device_Type_Port__c WHERE Id IN :deviceTypePortIds]);
        
    } else if (trigger.isDelete) {
        for (Management_IP_Port_Assignment__c portAssignment : trigger.old) {
            //Update the old remote device to point to null
            if (trigger.oldMap.get(portAssignment.Id).Connected_Device__c != null) {
            	portAssignmentsToUpdate.put(trigger.oldMap.get(portAssignment.Id).Connected_Device__c, new Management_IP_Port_Assignment__c(Id = trigger.oldMap.get(portAssignment.Id).Connected_Device__c, Connected_Device__c = null, Auto_Set_PoE__c = false));
            }
        }
    }
    
    List<Id> portAssignmentIds = new List<Id>();
    for (Management_IP_Port_Assignment__c portAssignment : [SELECT Id, Connected_Device__c, Auto_Set_PoE__c FROM Management_IP_Port_Assignment__c WHERE Id IN :portAssignmentsToUpdate.keySet()]) {
        if (portAssignmentsToUpdate.get(portAssignment.Id).Connected_Device__c != null && portAssignmentsToUpdate.get(portAssignment.Id).Connected_Device__c == portAssignment.Connected_Device__c && portAssignmentsToUpdate.get(portAssignment.Id).Auto_Set_PoE__c == portAssignment.Auto_Set_PoE__c) {
            portAssignmentsToUpdate.remove(portAssignment.Id);
        }
    }
    
    if (trigger.isInsert || trigger.isUpdate) {
    	//Auto Negotiation Code
    	for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
    		system.debug(portAssignment);
    		
            if (portAssignment.Connected_Device__c == null || portAssignment.Auto_Negotiate__c == true && remotePortAssignments.get(portAssignment.Connected_Device__c).Auto_Negotiate__c == false) {
            	if (portAssignment.Port_Speed__c != null) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Id)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Id);
	            		curPortAssignment.Port_Speed__c = null;
            			portAssignmentsToUpdate.put(portAssignment.Id, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, Port_Speed__c = null));
            		}
            	}
                continue;
            }
            
        	if (portAssignment.Auto_Negotiate__c == false && remotePortAssignments.get(portAssignment.Connected_Device__c).Auto_Negotiate__c == true && remotePortAssignments.get(portAssignment.Connected_Device__c).Port_Speed__c != null) {
    	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Connected_Device__c)) {
	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Connected_Device__c);
            		curPortAssignment.Port_Speed__c = null;
        			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, curPortAssignment);
        		} else {
        			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, new Management_IP_Port_Assignment__c(Id = portAssignment.Connected_Device__c, Port_Speed__c = null));
        		}
        		continue;
        	}
        	
        	if (remotePortAssignments.get(portAssignment.Connected_Device__c).Auto_Negotiate__c == false || portAssignment.Port_Speed__c != null && portAssignment.Port_Speed__c == remotePortAssignments.get(portAssignment.Connected_Device__c).Port_Speed__c) {
        		continue;
        	}
        	
        	if (deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).Port_Speed__c != null) {
	        	for (String curSpeed : deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).Port_Speed__c.split(';')) {
	        		if (deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).Port_Speed__c != null && deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).Port_Speed__c.split(';').contains(curSpeed)) {
	        			//Update the Local Device
	        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Id)) {
	    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Id);
		            		curPortAssignment.Port_Speed__c = curSpeed;
	            			portAssignmentsToUpdate.put(portAssignment.Id, curPortAssignment);
	            		} else {
	            			portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, Port_Speed__c = curSpeed));
	            		}
	            		
	            		//Update the Remote Device
	        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Connected_Device__c)) {
	    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Connected_Device__c);
	            			curPortAssignment.Port_Speed__c = curSpeed;
	            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, curPortAssignment);
	            		} else {
	            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, new Management_IP_Port_Assignment__c(Id = portAssignment.Connected_Device__c, Port_Speed__c = curSpeed));
	            		}
	        			break;
	        		}
	        	}
        	}
    	}
    	
    	//PoE Negotiation Code
        Boolean localOutput;
        Boolean remoteOutput;
        String poe;
        
        for (Management_IP_Port_Assignment__c portAssignment : trigger.new) {
            if (portAssignment.Connected_Device__c == null) {
            	if (portAssignment.PoE_Input__c != null || portAssignment.PoE_Output__c != null) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Id)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Id);
	            		curPortAssignment.PoE_Input__c = null;
            			curPortAssignment.PoE_Output__c = null;
            			portAssignmentsToUpdate.put(portAssignment.Id, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, PoE_Input__c = null, PoE_Output__c = null));
            		}
            	}
                continue;
            }
            
        	if (portAssignment.Auto_Set_PoE__c == false) {
        		continue;
        	}
            
            if ((deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c == null && deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Output__c == null) || (deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c != null && deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Output__c != null)) {
                continue;
            }
            
            if ((deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Input__c == null && deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Output__c == null) || (deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Input__c != null && deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Output__c != null)) {
                continue;
            }
            
            localOutput = false;
            if (deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c == null) {
                localOutput = true;
            }
            
            remoteOutput = false;
            if (deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Input__c == null) {
                remoteOutput = true;
            }
            
            if (localOutput == remoteOutput) {
                continue;
            }
            
            if (localOutput) {
                for (String output : deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Output__c.split(';')) {
                    for (String input : deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Input__c.split(';')) {
                        if (input == output) {
                            poe = input;
                        }
                        if (poe != null) {
                            break;
                        }
                    }
                    if (poe != null) {
                        break;
                    }
                }
            } else {
                for (String input : deviceTypePorts.get(portAssignment.Management_Device_Type_Port__c).PoE_Input__c.split(';')) {
                    for (String output : deviceTypePorts.get(remotePortAssignments.get(portAssignment.Connected_Device__c).Management_Device_Type_Port__c).PoE_Output__c.split(';')) {
                        if (input == output) {
                            poe = input;
                        }
                        if (poe != null) {
                            break;
                        }
                    }
                    if (poe != null) {
                        break;
                    }
                }
            }
            
            if (poe == null) {
                continue;
            }
            
            if (localOutput) {
                if (portAssignment.PoE_Input__c != null || portAssignment.PoE_Output__c != poe) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Id)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Id);
	            		curPortAssignment.PoE_Input__c = null;
            			curPortAssignment.PoE_Output__c = poe;
            			portAssignmentsToUpdate.put(portAssignment.Id, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, PoE_Input__c = null, PoE_Output__c = poe));
            		}
                }
                if (remotePortAssignments.get(portAssignment.Connected_Device__c).PoE_Input__c != poe || remotePortAssignments.get(portAssignment.Connected_Device__c).PoE_Output__c != null) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Connected_Device__c)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Connected_Device__c);
	            		curPortAssignment.PoE_Input__c = poe;
            			curPortAssignment.PoE_Output__c = null;
            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, new Management_IP_Port_Assignment__c(Id = portAssignment.Connected_Device__c, PoE_Input__c = poe, PoE_Output__c = null));
            		}
                }
            } else {
                if (portAssignment.PoE_Input__c != poe || portAssignment.PoE_Output__c != null) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Id)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Id);
	            		curPortAssignment.PoE_Input__c = poe;
            			curPortAssignment.PoE_Output__c = null;
            			portAssignmentsToUpdate.put(portAssignment.Id, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Id, new Management_IP_Port_Assignment__c(Id = portAssignment.Id, PoE_Input__c = poe, PoE_Output__c = null));
            		} 
                }
                if (remotePortAssignments.get(portAssignment.Connected_Device__c).PoE_Input__c != null || remotePortAssignments.get(portAssignment.Connected_Device__c).PoE_Output__c != poe) {
        	    	if (portAssignmentsToUpdate.containsKey(portAssignment.Connected_Device__c)) {
    	        		curPortAssignment = portAssignmentsToUpdate.get(portAssignment.Connected_Device__c);
	            		curPortAssignment.PoE_Input__c = null;
            			curPortAssignment.PoE_Output__c = poe;
            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, curPortAssignment);
            		} else {
            			portAssignmentsToUpdate.put(portAssignment.Connected_Device__c, new Management_IP_Port_Assignment__c(Id = portAssignment.Connected_Device__c, PoE_Input__c = null, PoE_Output__c = poe));
            		}
                }
            }
        }
    }
    
    if (portAssignmentsToUpdate.size() > 0) {
        update portAssignmentsToUpdate.values();
    }
}