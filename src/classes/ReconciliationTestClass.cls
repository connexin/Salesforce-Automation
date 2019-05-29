@isTest
private class ReconciliationTestClass {

    static testMethod void testReconciliationValidation() {
        
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Reconciliation__c reconciliation = new Reconciliation__c(
        	Account__c = account.Id
        );
        insert reconciliation;
        
        reconciliation.Credits__c = 10;
        reconciliation.Reconciled__c = true;
        
        try {
        	update reconciliation;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
        
        Reconciliation__c reconciliation2 = new Reconciliation__c(
        	Account__c = account.Id,
        	Credits__c = 10
        );
        
        try {
        	insert reconciliation2;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
        
        Reconciliation__c reconciliation3 = new Reconciliation__c(
        	Account__c = account.Id,
        	Debits__c = 10
        );
        
        try {
        	insert reconciliation3;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
        
        
    }
}