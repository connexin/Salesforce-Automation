trigger ValidateManagementIP on Management_IP__c (before insert, before update) {
    Integer decimalNumber1;
    Integer decimalNumber2;
    String[] subnetParts;
    Integer mask;
    Integer i;
    Integer j;
    Boolean breakLoop;
    Integer zeroCnt;
    
    Set<Id> ipIds = new Set<Id>();
    Set<Id> siteIds = new Set<Id>();
    Set<String> domains = new Set<String>();
    Set<String> ips = new Set<String>();
    Set<String> pppoeVLANs = new Set<String>();
    Set<String> sikluLinkIds = new Set<String>();
    Map<Id, Management_Site__c> managementSites = new Map<Id, Management_Site__c>();
    
    for (Management_IP__c managementIP : trigger.new) {
        ipIds.add(managementIP.Id);
        siteIds.add(managementIP.Site__c);
        
        if (managementIP.MAC_Address__c == '') {
        	managementIP.MAC_Address__c.addError('MAC Address is a required field');
        }
        
        if (domains.contains(managementIP.Domain__c)) {
        	managementIP.Hostname__c.addError('Domain must be unique');
        } else {
        	domains.add(managementIP.Domain__c);
        }
        
        if (ips.contains(managementIP.Name)) {
        	managementIP.Name.addError('IP Address must be unique');
        } else {
        	ips.add(managementIP.Name);
        }
        
        if (managementIP.Sector__c) {
	        if (pppoeVLANs.contains(managementIP.Subnet_PPPoE_VLAN__c)) {
	        	managementIP.PPPoE_VLAN__c.addError('PPPoE VLAN must be unique');
	        } else {
	        	pppoeVLANs.add(managementIP.Subnet_PPPoE_VLAN__c);
	        }
        }
        
        if (managementIP.Siklu_PTP__c) {
            if (managementIP.Siklu_Tx_Link_Id__c == null && managementIP.Siklu_Rx_Link_Id__c != null) {
                managementIP.Siklu_Tx_Link_Id__c.addError('Tx Link Id must be set if Rx Link Id is set');
            } else if (managementIP.Siklu_Tx_Link_Id__c != null && managementIP.Siklu_Rx_Link_Id__c == null) {
                managementIP.Siklu_Rx_Link_Id__c.addError('Rx Link Id must be set if Tx Link Id is set');
            } else if (managementIP.Siklu_Tx_Link_Id__c == managementIP.Siklu_Rx_Link_Id__c && managementIP.Siklu_Tx_Link_Id__c != null) {
                managementIP.Siklu_Tx_Link_Id__c.addError('Tx Link Id cannot equal Rx Link Id');
                managementIP.Siklu_Rx_Link_Id__c.addError('Rx Link Id cannot equal Tx Link Id');
            } else if (managementIP.Siklu_Tx_Link_Id__c != null && managementIP.Siklu_Rx_Link_Id__c != null) {
                sikluLinkIds.add(managementIP.Subnet_Siklu_Tx_Link_Id__c);
                sikluLinkIds.add(managementIP.Subnet_Siklu_Rx_Link_Id__c);
            }
        }
    }
    
    for (Management_Site__c managementSite : [SELECT Id, Name, Parent_Subnet__c FROM Management_Site__c WHERE Id IN :siteIds]) {
        managementSites.put(managementSite.Id, managementSite);
    }
    
    for (Management_IP__c managementIP : [SELECT Id, Domain__c FROM Management_IP__c WHERE Domain__c IN :domains AND Id NOT IN :ipIds]) {
        domains.remove(managementIP.Domain__c);
    }
    
    for (Management_IP__c managementIP : [SELECT Id, Name FROM Management_IP__c WHERE Name IN :ips AND Id NOT IN :ipIds]) {
        ips.remove(managementIP.Name);
    }
    
    for (Management_IP__c managementIP : [SELECT Id, Subnet_PPPoE_VLAN__c FROM Management_IP__c WHERE Subnet_PPPoE_VLAN__c IN :pppoeVLANs AND Id NOT IN :ipIds]) {
    	pppoeVLANs.remove(managementIP.Subnet_PPPoE_VLAN__c);
    }
    
    for (Management_IP__c managementIP : [SELECT Id, Subnet_Siklu_Tx_Link_Id__c, Subnet_Siklu_Rx_Link_Id__c FROM Management_IP__c WHERE (Subnet_Siklu_Tx_Link_Id__c IN :sikluLinkIds OR Subnet_Siklu_Rx_Link_Id__c IN :sikluLinkIds) AND Id NOT IN :ipIds AND Remote_Device__c NOT IN :ipIds]) {
        if (sikluLinkIds.contains(managementIP.Subnet_Siklu_Tx_Link_Id__c)) {
            sikluLinkIds.remove(managementIP.Subnet_Siklu_Tx_Link_Id__c);
        }
        if (sikluLinkIds.contains(managementIP.Subnet_Siklu_Rx_Link_Id__c)) {
            sikluLinkIds.remove(managementIP.Subnet_Siklu_Rx_Link_Id__c);
        }
    }
    
    for (Management_IP__c managementIP : trigger.new) {
        if (!domains.contains(managementIP.Domain__c)) {
            managementIP.Hostname__c.addError('Domain must be unique');
        }
        
        if (!ips.contains(managementIP.Name)) {
            managementIP.Name.addError('IP Address must be unique');
        }
        
        if (managementIP.Sector__c) {
        	if (!pppoeVLANs.contains(managementIP.Subnet_PPPoE_VLAN__c)) {
        		managementIP.PPPoE_VLAN__c.addError('PPPoE VLAN must be unique');
        	}
        }
        
        if (managementIP.Siklu_PTP__c) {
            if (managementIP.Siklu_Tx_Link_Id__c != null && !sikluLinkIds.contains(managementIP.Subnet_Siklu_Tx_Link_Id__c)) {
                managementIP.Siklu_Tx_Link_Id__c.addError('Tx Link Id must be unique');
            }
            if (managementIP.Siklu_Rx_Link_Id__c != null && !sikluLinkIds.contains(managementIP.Subnet_Siklu_Rx_Link_Id__c)) {
                managementIP.Siklu_Rx_Link_Id__c.addError('Rx Link Id must be unique');
            }
        }
        
        if (!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}$', managementIP.Name)) {
            managementIP.Name.addError('IP Address is Invalid');
            continue;
        }
        
        subnetParts = managementSites.get(managementIP.Site__c).Parent_Subnet__c.split('\\/');
        mask = Integer.valueOf(subnetParts[1]);
        
        if (managementIP.Name == subnetParts[0]) {
            managementIP.Name.addError('IP Address cannot be Subnet Address');
            continue;
        }
        
        breakLoop = false;
        zeroCnt = 0;
        
        //Work right to left
        for (j = 3; j >= 0 ; j--) {
        	i = 8 * (j + 1);
            
            decimalNumber1 = Integer.valueOf(subnetParts[0].split('\\.')[j]);
            decimalNumber2 = Integer.valueOf(managementIP.Name.split('\\.')[j]);
            
            while (i > 8 * j) {
                if (Math.mod(decimalNumber2, 2) == 0) {
                    zeroCnt++;
                }
                
                if (i == mask && zeroCnt == 0) {
                    managementIP.Name.addError('IP Address cannot be Subnet Broadcast Address');
                    breakLoop = true;
                    break;
                }
                
                if (i <= mask && Math.mod(decimalNumber1, 2) != Math.mod(decimalNumber2, 2)) {
                    managementIP.Name.addError('IP Address is not within Site Subnet');
                    breakLoop = true;
                    break;
                }
                
                decimalNumber1 = decimalNumber1 / 2;
                decimalNumber2 = decimalNumber2 / 2;
                i--;
            }
            
            if (breakLoop == true) {
                break;
            }
        }
    }
    
}