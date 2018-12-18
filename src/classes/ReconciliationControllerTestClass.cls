@isTest
private class ReconciliationControllerTestClass {

    static testMethod void testStandardController() {
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
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        List<Reconciliation__c> reconciliations = [SELECT Id FROM Reconciliation__c];
        system.assertEquals(reconciliations.size(), 1);
        ReconciliationController controller = new ReconciliationController(new ApexPages.StandardController(reconciliations[0]));
        
        system.assertEquals(controller.ledgerItems.size(), 2);
        system.assertEquals(controller.salesInvoiceRelations.size(), 1);
        system.assertEquals(controller.salesInvoiceRelations[0].Id, fd.Id);
        system.assertEquals(controller.paymentRelations.size(), 1);
        system.assertEquals(controller.paymentRelations[0].Id, payment.Id);
        
        controller.deleteReconciliation();
        system.assertEquals(ApexPages.getMessages().size(), 1);
        system.assertEquals(ApexPages.getMessages()[0].getDetail(), 'Cannot delete reconciliation for acounts set to reconcile automatically. Please set \'Auto Reconcile\' to disable before deleting reconciliations');
        
        account.Auto_Reconcile__c = false;
        update account;
        controller.deleteReconciliation();
        system.assertEquals([SELECT Id FROM Reconciliation__c].size(), 0);
    }
    
    static testMethod void testStandardController2() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType creditNoteRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'credit_note'];
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = creditNoteRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 35, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 25, Draft__c = false);
        insert refund;
        
        Set<Id> debitIds = new Set<Id>();
        Set<Id> creditIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        Ledger_Item__c fdLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Fiscal_Document__c != null];
        Ledger_Item__c refundLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Refund__c != null];
        creditIds.add(fdLedgerItem.Id);
        debitIds.add(refundLedgerItem.Id);
        accountIds.add(account.Id);
        LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds);
        
        List<Reconciliation__c> reconciliations = [SELECT Id FROM Reconciliation__c];
        system.assertEquals(reconciliations.size(), 1);
        
        system.debug([SELECT Amount__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.Recordtype.DeveloperName, Reconciliation__c FROM Ledger_Item__c]);
        
        ReconciliationController controller = new ReconciliationController(new ApexPages.StandardController(reconciliations[0]));
        
        system.assertEquals(controller.ledgerItems.size(), 2);
        system.assertEquals(controller.creditNoteRelations.size(), 1);
        system.assertEquals(controller.creditNoteRelations[0].Id, fd.Id);
        system.assertEquals(controller.refundRelations.size(), 1);
        system.assertEquals(controller.refundRelations[0].Id, refund.Id);
    }
    
}