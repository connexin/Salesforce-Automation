trigger ValidateManagementSite on Management_Site__c (before insert, before update) {
    Integer decimalNumber;
    String[] subnetParts;
    Integer mask;
    Integer i;
    
    for (Management_Site__c managementSite : trigger.new) {
        if (managementSite.Parent_Site__c != null) {
            continue;
        }
        
        if (!Pattern.matches('^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/([0-9]|[1-2][0-9]|3[0-2])$', managementSite.Subnet__c)) {
            managementSite.addError('Subnet is Invalid');
            continue;
        }
        
        subnetParts = managementSite.Subnet__c.split('\\/');
        mask = Integer.valueOf(subnetParts[1]);
        
        if (mask == 32) {
            continue;
        }
        
        decimalNumber = Integer.valueOf(subnetParts[0].split('\\.')[mask / 8]);
        
        i = 8 - Math.mod(mask, 8);
        while (decimalNumber > 0 && i > 0) {
            if (String.valueOf(Math.mod(decimalNumber, 2)) == '1') {
                managementSite.addError('Subnet is Invalid');
                break;
            }
            decimalNumber = decimalNumber / 2;
            i--;
        }
    }
    
}