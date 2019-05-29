public class ManagementSiteClass {
	
	public static String getFreeIPAddress(Id managementSiteId) {
		return ManagementSiteClass.getFreeIPAddress(managementSiteId, new Set<String>());
	}
	
    public static String getFreeIPAddress(Id managementSiteId, Set<String>excludeIps) {
    	Set<String> usedIps = new Set<String>();
    	Management_Site__c managementSite;
    	Integer curVal;
    	Integer subnetMinVal = 0;
    	Integer subnetMaxVal;
    	Integer i;
    	Integer d1;
    	Integer d2;
    	Integer d3;
    	Integer d4;
    	String ip;
    	
    	managementSite = [SELECT Id, Parent_Subnet__c FROM Management_Site__c WHERE Id = :managementSiteId];
    	
    	for (Management_IP__c managementIP : [SELECT Name FROM Management_IP__c WHERE Subnet__c = :managementSite.Parent_Subnet__c]) {
    		usedIps.add(managementIP.Name);
    	}
    	
    	String subnet = managementSite.Parent_Subnet__c.split('\\/')[0];
    	Integer mask = Integer.valueOf(managementSite.Parent_Subnet__c.split('\\/')[1]);
    	
    	for (i = 0; i < 4; i++) {
    		curVal = Integer.valueOf(subnet.split('\\.')[i]);
    		curVal = curVal << (8 * (3 - i));
    		subnetMinVal += curVal;
    	}
    	
    	if (mask > 31) {
    		subnetMaxVal = subnetMinVal;
    	} else {
	    	curVal = 1;
	    	for (i = 31; i >= mask; i--) {
	    		curVal *= 2;
	    	}
	    	subnetMaxVal = subnetMinVal + curVal - 1;
    	}
    	
    	for (i = subnetMinVal + 1; i < subnetMaxVal; i++) {
    		d4 = i >> 24;
    		d3 = (i - (d4 << 24)) >> 16;
    		d2 = (i - (d4 << 24) - (d3 << 16)) >> 8;
    		d1 = i - (d4 << 24) - (d3 << 16) - (d2 << 8);
    		ip = String.valueOf(d4) + '.' + String.valueOf(d3) + '.' + String.valueOf(d2) + '.' + String.valueOf(d1);
    		
    		if (usedIps.contains(ip)) {
    			continue;
    		}
    		
    		if (excludeIps.contains(ip)) {
    			continue;
    		}
    		
    		return ip;
    	}
    	
    	return null;
    	
    }
    
    public static Decimal getFreeSikluLinkId(Id managementSiteId) {
        return ManagementSiteClass.getFreeSikluLinkId(managementSiteId, new Set<Decimal>());
    }
    
    public static Decimal getFreeSikluLinkId(Id managementSiteId, Set<Decimal>excludeIds) {
        Set<Decimal> usedIds = new Set<Decimal>();
        
    	for (Management_IP__c managementIP : [SELECT Siklu_Tx_Link_Id__c, Siklu_Rx_Link_Id__c FROM Management_IP__c WHERE Site__c = :managementSiteId]) {
    		usedIds.add(managementIP.Siklu_Tx_Link_Id__c);
            usedIds.add(managementIP.Siklu_Rx_Link_Id__c);
    	}
        
        for (Decimal i = 1; i < 128; i++) {
            if (usedIds.contains(i)) {
                continue;
            }
            
            if (excludeIds.contains(i)) {
                continue;
            }
            
            return i;
        }
        
        return null;
    }
    
}