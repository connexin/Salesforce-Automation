trigger DirectDebitValidation on Direct_Debit__c (before insert, before update) {
    Map<Id, Integer> accountIds = new Map<Id, Integer>();
    Set<Id> directDebitIds = new Set<Id>();
    
    //Loop through each new Direct Debit and check that the Account__c is unique
    for (Direct_Debit__c directDebit : trigger.new) {
    	if (directDebit.Id != null) {
    		directDebitIds.add(directDebit.Id);
    	}
    	
    	if (accountIds.containsKey(directDebit.Account__c)) {
    		accountIds.put(directDebit.Account__c, accountIds.get(directDebit.Account__c) + 1);
    		continue;
    	}
        
    	accountIds.put(directDebit.Account__c, 1);
    }
    
    for (Direct_Debit__c directDebit : [SELECT Name, Account__c FROM Direct_Debit__c WHERE Account__c IN :accountIds.keySet() AND Id NOT IN :directDebitIds]) {
        accountIds.put(directDebit.Account__c, accountIds.get(directDebit.Account__c) + 1);
    }
    
    for (Direct_Debit__c directDebit : trigger.new) {
    	if (accountIds.get(directDebit.Account__c) > 1) {
    		directDebit.Account__c.addError('Account must be Unique');
    	}
    }
    
}