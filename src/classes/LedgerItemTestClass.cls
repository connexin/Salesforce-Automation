@isTest
public class LedgerItemTestClass {

    static testMethod void ledgerItemInsert() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false);
        insert refund;
        
        Integer i = 0;
        List<Ledger_Item__c> items = [SELECT Id, Fiscal_Document__c, Payment__c, Refund__c FROM Ledger_Item__c];
        for(Ledger_Item__c item: items) {
            i++;
        }
        
        system.assertEquals(3, i, 'Number of ledger Items does not equal the actual expected (3). Got: ' + i);
        
        try {
        	delete items;
        	system.assert(false);
        } catch (DMLException e) {
        	
        }
    }
    
    static testMethod void ledgerItemUpdate() {
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;

        
        Integer i = 0;
        for(Ledger_Item__c item: [SELECT Id, Fiscal_Document__c, Payment__c, Refund__c FROM Ledger_Item__c]) {
            i++;
        }
        
        if(i != 1) {
            system.assertEquals(1, i, 'Number of ledger Items does not equal the actual expected (3). Got: ' + i);
        }
    }
    
    
    static testMethod void testLedgerItemSplit() {
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Ledger_Item__c curLedgerItem = [SELECT Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c, RecordTypeId FROM Ledger_Item__c WHERE Payment__c = :payment.Id];
        LedgerItem.splitItem(curLedgerItem, new List<Decimal>{15, 10});
        
        List<Ledger_Item__c> ledgerItems = [SELECT Id, Name, Amount__c, Payment__c, Draft__c FROM Ledger_Item__c];
        //System.debug(ledgerItems);
        
        system.assertEquals(2, ledgerItems.size(), 'Failed: Size should be 2. Got ' + ledgerItems.size());
    }
    
    static testMethod void testLedgerItemUnsplit() {
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        //List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>();
        //LedgerItem.unsplitItems(ledgerItems);
        //ledgerItems = [SELECT Id, Draft__c, Amount__c, Reconciliation__c, Payment__c, Fiscal_Document__c FROM Ledger_Item__c];
        //system.debug('UnSplit Item Before split: ' + ledgerItems);
        
        Ledger_Item__c curLedgerItem = [SELECT Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c, RecordTypeId FROM Ledger_Item__c WHERE Payment__c = :payment.Id];
        LedgerItem.splitItem(curLedgerItem, new List<Decimal>{15, 10});
        
        List<Ledger_Item__c> ledgerItems = [SELECT Id, Name, Amount__c, Reconciliation__c, Payment__c, Draft__c, Fiscal_Document__c FROM Ledger_Item__c];
        //System.debug('Split Items: ' + ledgerItems);
        
        LedgerItem.unsplitItems(ledgerItems);
        ledgerItems = [SELECT Id FROM Ledger_Item__c];
        //system.debug('UnSplit Item: ' + ledgerItems);
        system.assertEquals(1, ledgerItems.size(), 'Ledger Item should be 1 after unsplit executes. Current Size is: ' + ledgerItems.size());
    }
    
    static testMethod void testLedgerItemUnsplit2() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        // = new List<Ledger_Item__c>();
        //LedgerItem.unsplitItems(ledgerItems);
        //ledgerItems = [SELECT Id, Draft__c, Amount__c, Reconciliation__c, Payment__c, Fiscal_Document__c FROM Ledger_Item__c];
        //system.debug('UnSplit Item Before split: ' + ledgerItems);
        
        Ledger_Item__c curLedgerItem = [SELECT Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c, RecordTypeId FROM Ledger_Item__c WHERE Fiscal_Document__c = :fd.Id];
        LedgerItem.splitItem(curLedgerItem, new List<Decimal>{15, 10});
        
        List<Ledger_Item__c> ledgerItems = [SELECT Id, Name, Amount__c, Reconciliation__c, Payment__c, Draft__c, Fiscal_Document__c FROM Ledger_Item__c];
        //System.debug('Split Items: ' + ledgerItems);
        
        LedgerItem.unsplitItems(ledgerItems);
        ledgerItems = [SELECT Id FROM Ledger_Item__c];
        //system.debug('UnSplit Item: ' + ledgerItems);
        system.assertEquals(1, ledgerItems.size(), 'Ledger Item should be 1 after unsplit executes. Current Size is: ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_InvoicePaymentReferenceMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        for(Ledger_Item__c item: ledgerItems) {
            system.assertEquals(true, item.Reconciled__c, 'Item not reconciled');
        }
        
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_InvoicePaymentAmountMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        for(Ledger_Item__c item: [SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]) {
            system.assertEquals(true, item.Reconciled__c, 'Item not reconciled');
        }
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_InvoicePaymentSplitCreditsMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 37, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of ledger Item is 2. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_InvoicePaymentSplitDebitsMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 2, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of ledger Item is 2. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_PaymentRefundReconcile() {
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 25, Draft__c = false);
        insert refund;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of ledger Item is 2. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_PaymentRefundSplitReconcile() {
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false);
        insert refund;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of reconciled ledger Item is 2. Got count ' + ledgerItems.size());
        
        ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = false]);
        system.assertEquals(1, ledgerItems.size(), 'Expected count of unreconciled ledger Item is 1. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_autoReconcile_PaymentFail() {
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 20, Draft__c = false);
        insert refund;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of reconciled ledger Item is 2. Got count ' + ledgerItems.size());
        
        ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = false]);
        system.assertEquals(1, ledgerItems.size(), 'Expected count of unreconciled ledger Item is 1. Got count ' + ledgerItems.size());
        
        payment.Failed__c = true;
        update payment;
        
        ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = false]);
        system.assertEquals(1, ledgerItems.size(), 'Expected count of unreconciled ledger Item is 1. Got count ' + ledgerItems.size());
        
    }
    
    static testMethod void testmatchLedgerItems_manualReconcile_InvoicePaymentMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        SET<Id> debitIds = new SET<Id>();
        SET<Id> creditIds = new SET<Id>();
        SET<Id> accountIds = new SET<Id>();
        
        Ledger_Item__c paymentLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Payment__c != null];
        Ledger_Item__c fdLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice'];
        creditIds.add(paymentLedgerItem.Id);
        debitIds.add(fdLedgerItem.Id);
        accountIds.add(account.Id);
        
        List<Id> reconciliationIds = new List<Id>();
        for (Reconciliation__c reconciliation : LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds)) {
        	reconciliationIds.add(reconciliation.Id);
        }
        
        for (Reconciliation__c reconciliation : [SELECT Id, Reconciled__c, Balance__c FROM Reconciliation__c WHERE Id IN :reconciliationIds]) {
        	system.assertEquals(true, reconciliation.Reconciled__c, 'Manual Reconciliation Supposed to be reconciled');
        	system.assertEquals(0.00, reconciliation.Balance__c, 'Manual Reconciliation balance supposed to be zero');
        }
        
        /*Reconciliation__c reconciliation = new Reconciliation__c(Account__c = account.Id, Reconciled__c = false);
        insert reconciliation;
        Id reconId = reconciliation.Id;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>();
        for(Ledger_Item__c item: [SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]) {
            item.Reconciliation__c = reconciliation.Id;
            ledgerItems.add(item);
        }
        update ledgerItems;
        
        Reconciliation__c reconciledRecon = [SELECT Id, Reconciled__c, Credits__c, Debits__c, Balance__c FROM Reconciliation__c WHERE Id = :reconId];
        System.debug(reconciledRecon);
        System.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        system.assertEquals(true, reconciledRecon.Reconciled__c, 'Manual Reconciliation Supposed to be reconciled');
        system.assertEquals(0.00, reconciledRecon.Balance__c, 'Manual Reconciliation balance supposed to be zero');*/
    }
    
    static testMethod void testmatchLedgerItems_manualToAutoReconcile() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        //system.debug('ledger items 1');
        //system.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        //system.debug('ledger items 2');
        //system.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        
        SET<Id> debitIds = new SET<Id>();
        SET<Id> creditIds = new SET<Id>();
        SET<Id> accountIds = new SET<Id>();
        
        Ledger_Item__c paymentLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Payment__c != null];
        Ledger_Item__c fdLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice'];
        creditIds.add(paymentLedgerItem.Id);
        debitIds.add(fdLedgerItem.Id);
        accountIds.add(account.Id);
        
        LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds);
        
        //system.debug('ledger items 3');
        //system.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        
        account.Auto_Reconcile__c = true;
        update account;
        
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of ledger Item is 2. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testReconciliationValidation() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;
        
        Fiscal_Document__c fd2 = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd2;
		
        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 2, Amount__c = 20.83);
        Fiscal_Document_Line__c fdl2 = new Fiscal_Document_Line__c(Fiscal_Document__c = fd2.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 2, Amount__c = 20.83);
        insert new List<Fiscal_Document_Line__c>{fdl, fdl2};
        
        fd.Draft__c = false;
        fd2.Draft__c = false;
        update new List<Fiscal_Document__c>{fd, fd2};
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        Payment__c payment2 = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert new List<Payment__c>{payment, payment2};
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        payment2.Draft__c = false;
        payment2.Confirmed__c = true;
        update new List<Payment__c>{payment, payment2};
        
        List<Reconciliation__c> reconciliations = new List<Reconciliation__c>();
        for (Reconciliation__c reconciliation : [SELECT Id, Reconciled__c FROM Reconciliation__c]) {
        	reconciliation.Reconciled__c = false;
        	reconciliations.add(reconciliation);
        }
        update reconciliations;
        
    }
    
    static testMethod void testmatchLedgerItems_ReferenceMatch() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Fiscal_Document__c fdRef = [SELECT Id, Reference__c FROM Fiscal_Document__c WHERE Id =: fd.Id];
        
        //system.debug('ledger items 1 - ' + fdRef.Reference__c);
        //system.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = fdRef.Reference__c);
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        SET<Id> debitIds = new SET<Id>();
        SET<Id> creditIds = new SET<Id>();
        SET<Id> accountIds = new SET<Id>();
        
        Ledger_Item__c paymentLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Payment__c != null];
        Ledger_Item__c fdLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice'];
        creditIds.add(paymentLedgerItem.Id);
        debitIds.add(fdLedgerItem.Id);
        accountIds.add(account.Id);
        
        LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds);
                
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(2, ledgerItems.size(), 'Expected count of ledger Item is 2. Got count ' + ledgerItems.size());
    }
    
    static testMethod void testmatchLedgerItems_PaymentFailed() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Fiscal_Document__c fdRef = [SELECT Id, Reference__c FROM Fiscal_Document__c WHERE Id =: fd.Id];
        
        //system.debug('ledger items 1 - ' + fdRef.Reference__c);
        //system.debug([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c]);
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = fdRef.Reference__c);
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        SET<Id> debitIds = new SET<Id>();
        SET<Id> creditIds = new SET<Id>();
        SET<Id> accountIds = new SET<Id>();
        
        Ledger_Item__c paymentLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Payment__c != null];
        Ledger_Item__c fdLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Fiscal_Document__c != null AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice'];
        creditIds.add(paymentLedgerItem.Id);
        debitIds.add(fdLedgerItem.Id);
        accountIds.add(account.Id);
        
        List<Reconciliation__c> reconciliations = LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds);
        //system.debug('Reconciliation Size is: ' + reconciliations.size());
        
        payment.Failed__c = true;
        update payment;
        
        List<Reconciliation__c> remainingRecon = [SELECT Id, Reconciled__c FROM Reconciliation__c];
        //system.debug('Remaining Reconciliation Size is: ' + remainingRecon.size());
                
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(1, reconciliations.size(), 'Expected count of reconnciliations is 1 before payment failed. Got count ' + reconciliations.size());
        system.assertEquals(0, remainingRecon.size(), 'Expected count of reconnciliations is 0 after payment failed. Got count ' + remainingRecon.size());
    }
    
    static testMethod void testmatchLedgerItems_RefundFailed() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = false);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = '123');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c( Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Payment__c = payment.Id );
        insert refund;
        
        refund.Draft__c = false;
        refund.Confirmed__c = true;
        update refund;        
        
        SET<Id> debitIds = new SET<Id>();
        SET<Id> creditIds = new SET<Id>();
        SET<Id> accountIds = new SET<Id>();
        
        Ledger_Item__c paymentLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Payment__c != null];
        Ledger_Item__c refundLedgerItem = [SELECT Id FROM Ledger_Item__c WHERE Refund__c != null];
        creditIds.add(paymentLedgerItem.Id);
        debitIds.add(refundLedgerItem.Id);
        accountIds.add(account.Id);
        
        List<Reconciliation__c> reconciliations = LedgerItem.matchLedgerItems(accountIds, creditIds, debitIds);
        //system.debug('Reconciliation Size is: ' + reconciliations.size());
        
        refund.Failed__c = true;
        update refund;
        
        List<Reconciliation__c> remainingRecon = [SELECT Id, Reconciled__c FROM Reconciliation__c];
        //system.debug('Remaining Reconciliation Size is: ' + remainingRecon.size());
                
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Fiscal_Document__c, Payment__c, Amount__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Reconciled__c = true]);
        system.assertEquals(1, reconciliations.size(), 'Expected count of reconnciliations is 1 before refund failed. Got count ' + reconciliations.size());
        system.assertEquals(0, remainingRecon.size(), 'Expected count of reconnciliations is 0 after refund failed. Got count ' + remainingRecon.size());
    }
    
    static testMethod void testmatchLedgerItems_PaymentRefundBulkTest() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        List<Payment__c> paymentsList = new List<Payment__c>();
        for(Integer i=0; i<10; i++) {
            paymentsList.add(new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = '123'));
        }
        insert paymentsList;
        
        for(Payment__c payment: paymentsList) {
            payment.Draft__c = false;
            payment.Confirmed__c = true;
        }
        update paymentsList;
        
        List<Refund__c> refundsList = new List<Refund__c>();
        for(Payment__c payment: paymentsList) {
            refundsList.add(New Refund__c( Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Payment__c = payment.Id ));
        }
        insert refundsList;
        
        for(Refund__c refund: refundsList) {
            refund.Draft__c = false;
            refund.Confirmed__c = true;
        }
        update refundsList;
    }
    
    static testMethod void testmatchLedgerItems_FDPaymentBulkTest() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        List<Fiscal_Document__c> fdList = new List<Fiscal_Document__c>();
        List<Fiscal_Document_Line__c> fdlList = new List<Fiscal_Document_Line__c>();
        for(Integer i=0; i < 10; i++) {
            Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
            Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
            fdList.add(fd);
            fdlList.add(fdl);
        }
        insert fdList;
        
        for (Integer j = 0; j < fdList.size(); j++) {
        	fdlList[j].Fiscal_Document__c = fdList[j].Id;
        }
        
        insert fdlList;
        for(Fiscal_Document__c fd: fdList) {
            fd.Draft__c = false;
        }
        update fdList;
        
        List<Payment__c> paymentsList = new List<Payment__c>();
        for(Integer i=0; i<10; i++) {
            paymentsList.add(new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = '123'));
        }
        insert paymentsList;
        
        for(Payment__c payment: paymentsList) {
            payment.Draft__c = false;
            payment.Confirmed__c = true;
        }
        update paymentsList;
    }
    
    static testMethod void testmatchLedgerItems_FailedPaymentLedgerItemDelete() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = '123');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c( Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Payment__c = payment.Id );
        insert refund;
        
        refund.Draft__c = false;
        refund.Confirmed__c = true;
        update refund;        
        
        List<Reconciliation__c> reconciliations = [SELECT Id, Reconciled__c FROM Reconciliation__c];
        system.debug('Reconciliation Size is: ' + reconciliations.size());
                
        List<Ledger_Item__c>  ledgerItems = new List<Ledger_Item__c>([SELECT Id, Draft__c, Payment__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Payment__c != null]);
        system.debug('Payment Ledger Items: ' + ledgerItems);
        
        payment.Failed__c = true;
        update payment;
        
        List<Reconciliation__c> reconciliationsAfter = [SELECT Id, Reconciled__c FROM Reconciliation__c];
        system.debug('Reconciliation Size is after: ' + reconciliationsAfter.size());
                
        List<Ledger_Item__c>  ledgerItemsAfter = new List<Ledger_Item__c>([SELECT Id, Draft__c, Payment__c, Reconciled__c, Reconciliation__c FROM Ledger_Item__c WHERE Payment__c != null]);
        system.debug('Payment Ledger Items after: ' + ledgerItemsAfter);
        
        system.assertEquals(1, reconciliations.size(), 'Expected count of reconnciliations is 1 before. Got count ' + reconciliations.size());
        system.assertEquals(0, reconciliationsAfter.size(), 'Expected count of reconnciliations is 0 before. Got count ' + reconciliationsAfter.size());
        
        system.assertEquals(1, ledgerItems.size(), 'Expected count of reconnciliations is 1 before. Got count ' + ledgerItems.size());
        system.assertEquals(0, ledgerItemsAfter.size(), 'Expected count of ledgerItemsAfter is 0 after. Got count ' + ledgerItemsAfter.size());
    }
    
    static testMethod void testmatchLedgerItems_NotInsertLedgerItemOnUpdateFailedPayment() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = true, Description__c = '123');
        insert payment;
        
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        List<Ledger_Item__c> paymentItems = new List<Ledger_Item__c>();
        paymentItems.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items: ' + paymentItems);
        system.assertEquals(0, paymentItems.size(), 'Expected count of ledgerItems is 0 before. Got count ' + paymentItems.size());
        
        payment.Failed__c = false;
        update payment;
        
        List<Ledger_Item__c> paymentItemsAfter = new List<Ledger_Item__c>();
        paymentItemsAfter.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items After: ' + paymentItemsAfter);
        system.assertEquals(1, paymentItemsAfter.size(), 'Expected count of ledgerItemsAfter is 1 before. Got count ' + paymentItemsAfter.size());
    }
    
    static testMethod void testmatchLedgerItems_NotInsertLedgerItemOnInsertFailedPayment() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = false, Failed__c = false, Description__c = '123', Reference__c = 'notinsertledgeritem');
        insert payment;
        
        List<Ledger_Item__c> paymentItems = new List<Ledger_Item__c>();
        paymentItems.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items: ' + paymentItems);
        system.assertEquals(0, paymentItems.size(), 'Expected count of ledgerItems is 0 before. Got count ' + paymentItems.size());
        
        payment.Failed__c = false;
        update payment;
        
        List<Ledger_Item__c> paymentItemsAfter = new List<Ledger_Item__c>();
        paymentItemsAfter.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items After: ' + paymentItemsAfter);
        system.assertEquals(0, paymentItemsAfter.size(), 'Expected count of ledgerItemsAfter is 0 before. Got count ' + paymentItemsAfter.size());
    }
    
    static testMethod void testmatchLedgerItems_NotInsertLedgerItemOnInsertFailedPayment2() {
    	Pricebook2 testPricebook = new Pricebook2(
    		IsActive = true,
    		Name = 'Standard Pricebook'
    	);
    	insert testPricebook;
    	
    	RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
    	
    	Tax__c testTax = new Tax__c(
    		Name = 'Test Tax',
    		Rate__c = 20
    	);
    	insert testTax;
    	
    	Nominal_Code__c testNominalCode = new Nominal_Code__c(
    		Name = '100',
    		Description__c = 'Test Nominal Code'
    	);
    	insert testNominalCode;
    	
    	Product2 testProduct = new Product2(
    		Name = 'Test Product',
    		ProductCode = 'Test',
    		Description = 'Test Product',
    		Nominal_Code__c = testNominalCode.Id
    	);
    	
        Account account = new Account(Name = 'Test Account', Auto_Reconcile__c = true);
        insert account;
        
        account.Name = 'Test Account 2';
        update account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = false, Confirmed__c = true, Failed__c = true, Description__c = '123', Reference__c = 'notinsertledgeritem');
        insert payment;
        
        List<Ledger_Item__c> paymentItems = new List<Ledger_Item__c>();
        paymentItems.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items: ' + paymentItems);
        system.assertEquals(0, paymentItems.size(), 'Expected count of ledgerItems is 0 before. Got count ' + paymentItems.size());
        
        payment.Failed__c = false;
        update payment;
        
        List<Ledger_Item__c> paymentItemsAfter = new List<Ledger_Item__c>();
        paymentItemsAfter.addAll([SELECT Id, Payment__c FROM Ledger_Item__c WHERE Payment__c = :payment.Id]);
        
        system.debug('Ledger Items After: ' + paymentItemsAfter);
        system.assertEquals(1, paymentItemsAfter.size(), 'Expected count of ledgerItemsAfter is 1 before. Got count ' + paymentItemsAfter.size());
    }
}