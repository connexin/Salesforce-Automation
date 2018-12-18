global class SendFiscalDocumentEmails implements Database.Batchable<sObject> {
    global final Id owea;
    
    global SendFiscalDocumentEmails() {
    	this.owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'support@connexin.co.uk'].get(0).Id;
    }
    
    global Database.QueryLocator start (Database.BatchableContext BC) {
    	return Database.getQueryLocator('SELECT Id, Account__c, RecordType.Name, Reference__c FROM Fiscal_Document__c WHERE Sent__c = false AND Draft__c = false AND Account__r.Auto_Send_Fiscal_Documents__c = true AND Auto_Actions__c = true');
    }
    
    global void execute (Database.BatchableContext BC, List<Fiscal_Document__c> scope) {
    	List<Id> fiscalDocIds = new List<Id>();
        List<Id> accountIds = new List<Id>();
    	
    	for (Fiscal_Document__c fd : scope) {
            fiscalDocIds.add(fd.Id);
    		accountIds.add(fd.Account__c);
    	}
        
        Map<Id, String> accountIdsToEmail = new Map<Id, String>();
        for (Account account : [SELECT Id, Email__c FROM Account where Id IN :accountIds]) {
            if (account.Email__c != null) {
            	accountIdsToEmail.put(account.Id, account.Email__c);
            }
        }
    	
    	Map<Id, List<Contact>> accountIdsToContacts = new Map<Id, List<Contact>>();
    	List<Contact> contacts;
    	for (Contact contact : [SELECT Id, AccountId, Email FROM Contact WHERE AccountId = :accountIds AND Email != null]) {
    		if (!accountIdsToContacts.containsKey(contact.AccountId)) {
    			accountIdsToContacts.put(contact.AccountId, new List<Contact>());
    		}
			contacts = accountIdsToContacts.get(contact.AccountId);
			contacts.add(contact);
			accountIdsToContacts.put(contact.AccountId, contacts);
    	}
    	
    	Messaging.SingleEmailMessage mail;
    	List<String> toAddresses;
    	Messaging.EmailFileAttachment efa;
    	List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    	
    	for (Fiscal_Document__c fd : scope) {
    		mail = new Messaging.SingleEmailMessage();
            
            toAddresses = new List<String>();
            if (accountIdsToEmail.containsKey(fd.Account__c)) {
                toAddresses.add(accountIdsToEmail.get(fd.Account__c));
            }
    		
            if (accountIdsToContacts.containsKey(fd.Account__c)) {
                for (Contact contact : accountIdsToContacts.get(fd.Account__c)) {
                    if (!toAddresses.contains(contact.Email)) {
                        toAddresses.add(contact.Email);
                    }
                }
            }
            
            if (toAddresses.isEmpty()) {
                continue;
            }
            
    		mail.setToAddresses(toAddresses);
    		mail.setUseSignature(false);
    		mail.setOrgWideEmailAddressId(owea);
    		mail.setSubject('Your Connexin ' + fd.RecordType.Name + ' - ' + fd.Reference__c);
    		mail.setPlainTextBody('Hi,\n\nPlease find your Connexin ' + fd.RecordType.Name + ' attached\n\nIf you have any questions please do not hesitate to contact us\n\nKind Regards,\n\nThe Connexin Accounts Team\n01482 36 37 38');
    		mail.setHtmlBody('Hi,<br /><br />Please find your Connexin ' + fd.RecordType.Name + ' attached<br /><br />If you have any questions please do not hesitate to contact us<br /><br />Kind Regards,<br /><br />The Connexin Accounts Team<br />01482 36 37 38<br />');
    		
    		PageReference pdf = Page.FiscalDocumentPDF;
    		pdf.getParameters().put('id', (String)fd.Id);
    		
    		efa = new Messaging.EmailFileAttachment();
    		efa.setFileName(fd.Reference__c + '.pdf');
    		blob pdfBody;
	        if (Test.isRunningTest()) { 
          		pdfBody = blob.valueOf('Unit.Test');
	        } else {
          		pdfBody = pdf.getContent();
	        }
	        efa.setBody(pdfBody);
	        
	        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { efa });
	        
	        emails.add(mail);
	        
	        fd.Sent__c = true;
    	}
    	
    	Messaging.sendEmail(emails);
    	
    	update scope;
    }
    
    global void finish(Database.BatchableContext BC) {}
    
}