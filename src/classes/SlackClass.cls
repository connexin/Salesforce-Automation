public class SlackClass {
	
    @future(callout=true)
    public static void sendMessage(Id caseId, String caseNumber, String caseSubject, String caseDescription, String caseEmail, String casePriority) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setEndpoint('https://hooks.slack.com/services/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');
        req.setMethod('POST');
        req.setBody('payload={"attachments": [{"fallback": "New NOC Ticket - Ticket #'+ caseNumber + ': ' + caseSubject + ' - https://cxn.my.salesforce.com/' + caseId + '", "pretext": "New NOC Ticket - Ticket #' + caseNumber + '", "title": "' + caseSubject + '", "title_link": "https://cxn.my.salesforce.com/' + caseId + '", "text": "' + caseDescription + '", "color": "#FF0000", "fields": [{"title": "Email", "value": "' + caseEmail + '", "short": true}, {"title": "Priority", "value": "' + casePriority + '", "short": true}]}]}');
        
        http.send(req);
    }
    
}