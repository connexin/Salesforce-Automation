// Trailhead example class
// https://trailhead.salesforce.com/en/content/learn/projects/salesforce_developer_workshop/creating_apex_class
public with sharing class EmailManager {
    
    public void sendMail(String [] addresses, String [] subjects, String [] messages) {
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
        Integer totalMails = addresses.size();
        for(Integer i=0; i < totalMails; i++){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(subjects[i]);
            email.setToAddresses(new List<String> { addresses[i] });
            email.setPlainTextBody(messages[i]);
            emails.add(email);
        }
        Messaging.sendEmail(emails);
    }
}