trigger SikluRemoteDeviceUpdate on Management_IP__c (after insert, after update) {
	
    Map<Id, Id> remoteDeviceToLocalDeviceIdMap = new Map<Id, Id>();
    List<Management_IP__c> remoteDevices = new List<Management_IP__c>();
    
    for (Management_IP__c managementIP : trigger.new) {
        //Check if Remote_Device__c has been updated
        if ((trigger.isInsert && managementIP.PTP__c == true && managementIP.Remote_Device__c != null) 
            || trigger.isUpdate && 
            (trigger.oldMap.get(managementIP.Id).Remote_Device__c != managementIP.Remote_Device__c
            || trigger.oldMap.get(managementIP.Id).Siklu_Tx_Link_Id__c != managementIP.Siklu_Tx_Link_Id__c
            || trigger.oldMap.get(managementIP.Id).Siklu_Rx_Link_Id__c != managementIP.Siklu_Rx_Link_Id__c
            || trigger.oldMap.get(managementIP.Id).Siklu_Mode__c != managementIP.Siklu_Mode__c)
           ) {
            //If the Remote_Device__c has been updated set the Remote Devices Remote Device to the Local Device
            if (trigger.isInsert || (trigger.isUpdate && managementIP.PTP__c == true && managementIP.Remote_Device__c != null)) {
                String mode = 'master';
                if (managementIP.Siklu_Mode__c == 'master') {
                    mode = 'slave';
                }
                remoteDevices.add(new Management_IP__c(Id=managementIP.Remote_Device__c, Remote_Device__c=managementIP.Id, Siklu_Mode__c=mode, Siklu_Tx_Link_Id__c=managementIP.Siklu_Rx_Link_Id__c, Siklu_Rx_Link_Id__c=managementIP.Siklu_Tx_Link_Id__c));
            }
            
            //If the Remote_Device__c has been removed set the Remote Devices Remote Device to Null
            if (trigger.isUpdate && trigger.oldMap.get(managementIP.Id).Remote_Device__c != null && (managementIP.Remote_Device__c == null || managementIP.PTP__c == false)) {
                remoteDevices.add(new Management_IP__c(Id=trigger.oldMap.get(managementIP.Id).Remote_Device__c, Remote_Device__c=null, Siklu_Mode__c ='master', Siklu_Tx_Link_Id__c=null, Siklu_Rx_Link_Id__c=null));
            }
        }
    }
    
    update remoteDevices;
}