trigger SupportCaseClosed on Case (after update) {
    
    Map<Id, Schema.RecordTypeInfo> recordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    Map<Id, String> accountContactMap = new Map<Id, String>();
    
    for (Case curCase : trigger.new) {
    	if (recordTypeMap.get(curCase.RecordTypeId).getName() == 'Support' && curCase.Status == 'Resolved' && curCase.ContactEmail != null && curCase.NPSSurvey__c == true) {
            accountContactMap.put(curCase.AccountId, curCase.ContactEmail);
    	} 
    }
    
    for (Account curAccount : [SELECT Id, Type FROM Account WHERE Id IN : accountContactMap.keySet()]) {
        if (curAccount.Type == 'Residential') {
            NPSClass.sendNPSHomeSurvey(accountContactMap.get(curAccount.Id));
        } else if (curAccount.Type == 'Business') {
            NPSClass.sendNPSBusinessSurvey(accountContactMap.get(curAccount.Id));
        }
    }
    
}