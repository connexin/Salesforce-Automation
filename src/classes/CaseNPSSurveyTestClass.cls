@isTest
public class CaseNPSSurveyTestClass {
	
    static testmethod void testNPSSurvey() {
        Account myAccount = new Account(Name='Test Account', Type='Residential');
        insert myAccount;
        
        Contact myContact = new Contact(LastName='Test', Account=myAccount, Email='test@test.com');
        insert myContact;
        
        Case myCase = new Case(RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId());
        insert myCase;
        
        myCase.ContactId = myContact.Id;
        myCase.AccountId = myAccount.Id;
        update myCase;
        
        Test.setMock(HttpCalloutMock.class, new NPSSurveyMockHTTPGenerator());
        
        myCase.Status = 'Resolved';
        update myCase;
        
        Account myAccount2 = new Account(Name='Test Account', Type='Business');
        insert myAccount2;
        
        Case myCase2 = new Case(RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId());
        insert myCase2;
        
        myCase.ContactId = myContact.Id;
        myCase.AccountId = myAccount2.Id;
        update myCase2;
        
        myCase2.Status = 'Resolved';
        update myCase2;
    }
    
}