@RestResource(urlMapping = '/Finance/sendFiscalDocuments')
global with sharing class FinanceRestResource {
    
    @HttpPost
    global static String doPost() {
		Database.executeBatch(new SendFiscalDocumentEmails());
		
		return null;
    }
    
}