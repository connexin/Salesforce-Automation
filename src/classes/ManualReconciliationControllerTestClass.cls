@isTest
private class ManualReconciliationControllerTestClass {

    static testMethod void testManualReconciliationController() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
        
        Account account = new Account(Name = 'Test', Auto_Reconcile__c = false);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        ManualReconciliationController controller;
        
        controller = new ManualReconciliationController();
        system.assertEquals(1, ApexPages.getMessages().size());
        system.assertEquals('Account ID not Specified', ApexPages.getMessages()[0].getDetail());
        
        ApexPages.currentPage().getParameters().put('accountid', account.Id);
        controller = new ManualReconciliationController();
        
        for (Id creditId : controller.credits.keySet()) {
        	controller.selectedItems.put(creditId, true);
        	ApexPages.currentPage().getParameters().put('credit1', creditId);
        }
        
        controller.selectCredit();
        
        controller = new ManualReconciliationController();
        
        for (Id debitId : controller.debits.keySet()) {
        	controller.selectedItems.put(debitId, true);
        }
        
        controller.selectDebit();
        
        system.assertEquals(1, [SELECT Id FROM Reconciliation__c].size());
        
        system.assertEquals(false, controller.getCreditsIsEmpty());
        system.assertEquals(false, controller.getDebitsIsEmpty());
        system.assertEquals('/apex/AccountStatement', controller.cancel().getUrl().split('\\?')[0]);
    }
}