trigger NOCCaseCreated on Case (after insert) {
    
    Map<ID,Schema.RecordTypeInfo> recordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosById();
    
    for (Case myCase :trigger.new) {
        if (recordTypeMap.get(myCase.recordTypeID).getName().containsIgnoreCase('NOC')) {
			SlackClass.sendMessage(myCase.Id, myCase.CaseNumber, myCase.Subject, myCase.Description, myCase.ContactEmail, myCase.Priority);
        }
    }
    
}