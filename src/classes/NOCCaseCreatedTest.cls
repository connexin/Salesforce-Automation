@isTest
public class NOCCaseCreatedTest {
    static testMethod void checkTrigger() {
        Case myCase = new Case(Subject='Test', Description='Test');
        insert myCase;
        
        Test.setMock(HttpCalloutMock.class, new SlackClassMockHTTPGenerator());
        SlackClass.sendMessage(myCase.Id, myCase.CaseNumber, myCase.Subject, myCase.Description, myCase.ContactEmail, myCase.Priority);
    }
}