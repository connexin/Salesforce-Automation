@isTest
public class DebtorsTestClass {

    static testMethod void testDebtors1() {
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
        
        List<Account> accounts = new List<Account>();
        List<Payment__c> payments = new List<Payment__c>();
        List<Fiscal_Document__c> fds = new List<Fiscal_Document__c>();
        List<Fiscal_Document_Line__c> fdls = new List<Fiscal_Document_Line__c>();
        
        for(Integer i=0; i<100; i++) {
            accounts.add(new Account(Name = 'Test' + i, Auto_Reconcile__c = true));
        }
        insert accounts;
        
        for(Integer i=0; i<75; i++) {
            payments.add(new Payment__c(Account__c = accounts[i].id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test'));
        }
        insert payments;
        
        for(Integer i=0; i<75; i++) {
            payments[i].Draft__c = false;
            payments[i].Confirmed__c = true;
        }
        update payments;
        
        for(Integer i=0; i<85; i++) {
            fds.add(new Fiscal_Document__c(Account__c = accounts[i].Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id));
        }
        insert fds;
        
        for(Integer i=0; i<85; i++) {
            fdls.add(new Fiscal_Document_Line__c(Fiscal_Document__c = fds[i].Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25));
        }
        insert fdls;
        
        for(Integer i=0; i<85; i++) {
            fds[i].Draft__c = false;
        }
        update fds;
        
        DebtorsController debtors;
        debtors = new DebtorsController();
        
        system.assertEquals(25, debtors.offset,'Initial offset supposed to be 25, found it to be ' + debtors.offset);
        system.assertEquals(25, debtors.debtorsToShow.size(),'Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        /*system.assertEquals(-25, debtors.sortedDebtors[0].balanceAmount,'Account 4 balance supposed to be -25, found ' + debtors.sortedDebtors[0].balanceAmount);
        system.assertEquals(true, debtors.nextEnable, 'On Page load, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(false, debtors.prevEnable, 'On Page load, prev should be disabled, but its not. Found ' + debtors.prevEnable);*/
        
        debtors.next();
        system.assertEquals(50, debtors.offset,'Initial offset supposed to be 50, found it to be ' + debtors.offset);
        /*system.assertEquals(25, debtors.debtorsToShow.size(),'Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        system.assertEquals(true, debtors.nextEnable, 'On Next Page, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(true, debtors.prevEnable, 'On Next Page, prev should be enabled, but its not. Found ' + debtors.prevEnable);        */
        
        debtors.prev();
        system.assertEquals(25, debtors.offset,'Initial offset supposed to be 25, found it to be ' + debtors.offset);
        /*system.assertEquals(25, debtors.debtorsToShow.size(),'Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        system.assertEquals(true, debtors.nextEnable, 'On Next Page, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(false, debtors.prevEnable, 'On Next Page, prev should be disabled, but its not. Found ' + debtors.prevEnable);*/                
        
        debtors.last();
        system.assertEquals(75, debtors.offset,'Initial offset supposed to be 75, found it to be ' + debtors.offset);
        /*system.assertEquals(25, debtors.debtorsToShow.size(),'Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        system.assertEquals(false, debtors.nextEnable, 'On Next Page, next should be disabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(true, debtors.prevEnable, 'On Next Page, prev should be enabled, but its not. Found ' + debtors.prevEnable);*/ 
        
        debtors.first();
        system.assertEquals(0, debtors.offset,'Initial offset supposed to be 0, found it to be' + debtors.offset);
        /*system.assertEquals(25, debtors.debtorsToShow.size(),'Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        system.assertEquals(true, debtors.nextEnable, 'On Next Page, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(false, debtors.prevEnable, 'On Next Page, prev should be disabled, but its not. Found ' + debtors.prevEnable);*/
  
        
    }
    
    static testMethod void testDebtorsDisputed1() {
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
        
        List<Account> accounts = new List<Account>();
        List<Payment__c> payments = new List<Payment__c>();
        List<Fiscal_Document__c> fds = new List<Fiscal_Document__c>();
        List<Fiscal_Document_Line__c> fdls = new List<Fiscal_Document_Line__c>();
        
        for(Integer i=0; i<100; i++) {
            accounts.add(new Account(Name = 'Test' + i, Auto_Reconcile__c = true));
        }
        insert accounts;
        
        for(Integer i=0; i<75; i++) {
            payments.add(new Payment__c(Account__c = accounts[i].id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test'));
        }
        insert payments;
        
        for(Integer i=0; i<75; i++) {
            payments[i].Draft__c = false;
            payments[i].Confirmed__c = true;
        }
        update payments;
        
        for(Integer i=0; i<85; i++) {
            fds.add(new Fiscal_Document__c(Account__c = accounts[i].Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id));
        }
        insert fds;
        
        for(Integer i=0; i<85; i++) {
            fdls.add(new Fiscal_Document_Line__c(Fiscal_Document__c = fds[i].Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25));
        }
        insert fdls;
        
        for(Integer i=0; i<85; i++) {
            fds[i].Draft__c = false;
        }
        update fds;
        
        DebtorsController debtors;
        debtors = new DebtorsController();
        debtors.includeDisputedInvoices = true;
        debtors.SortedDebtors();
        
        system.assertEquals(25, debtors.offset,'Initial offset supposed to be 25, found it to be ' + debtors.offset);
        /*system.assertEquals(25, debtors.debtorsToShow.size(),'1 Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        system.assertEquals(-25, debtors.sortedDebtors[0].balanceAmount,'Account 4 balance supposed to be -25, found ' + debtors.sortedDebtors[0].balanceAmount);
        system.assertEquals(true, debtors.nextEnable, 'On Page load, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(false, debtors.prevEnable, 'On Page load, prev should be disabled, but its not. Found ' + debtors.prevEnable);*/
        
        debtors.next();
        //system.assertEquals(50, debtors.offset,'Initial offset supposed to be 50, found it to be ' + debtors.offset);
        system.assertEquals(25, debtors.debtorsToShow.size(),'2 Debtors to show should contain 25, found ' + debtors.debtorsToShow.size());
        /*system.assertEquals(true, debtors.nextEnable, 'On Next Page, next should be enabled, but its not. Found ' + debtors.nextEnable);
        system.assertEquals(true, debtors.prevEnable, 'On Next Page, prev should be enabled, but its not. Found ' + debtors.prevEnable);        */
        
        debtors.prev();
        system.assertEquals(25, debtors.offset,'Initial offset supposed to be 25, found it to be ' + debtors.offset);
    }
    
    static testMethod void testDebtorsIncreasedDataLimit() {
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
        
        List<Account> accounts = new List<Account>();
        List<Payment__c> payments = new List<Payment__c>();
        List<Fiscal_Document__c> fds = new List<Fiscal_Document__c>();
        List<Fiscal_Document_Line__c> fdls = new List<Fiscal_Document_Line__c>();
        
        for(Integer i=0; i<5; i++) {
            accounts.add(new Account(Name = 'Test' + i, Auto_Reconcile__c = true));
        }
        insert accounts;
        
        for(Integer i=0; i<3; i++) {
            payments.add(new Payment__c(Account__c = accounts[i].id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test'));
        }
        insert payments;
        
        for(Integer i=0; i<3; i++) {
            payments[i].Draft__c = false;
            payments[i].Confirmed__c = true;
        }
        update payments;
        
        for(Integer i=0; i<4; i++) {
            fds.add(new Fiscal_Document__c(Account__c = accounts[i].Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id));
        }
        insert fds;
        
        for(Integer i=0; i<4; i++) {
            fdls.add(new Fiscal_Document_Line__c(Fiscal_Document__c = fds[i].Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25));
        }
        insert fdls;
        
        for(Integer i=0; i<4; i++) {
            fds[i].Draft__c = false;
        }
        update fds;
        
        DebtorsController debtors;
        debtors = new DebtorsController();
        debtors.dataLimit = 25;
        debtors.includeDisputedInvoices = true;
        debtors.SortedDebtors();
        
        for(Integer i=0; i<4; i++) {
            system.debug('FDS ' + i + ' - ' + fds[i]);
        }
        
        for(Integer i=0;i<5;i++) {
            system.debug('Debtors ' + i + ' - ' + debtors.sortedDebtors[i]);
        }
        
        debtors.invoiceCutoffDate = Date.valueOf('25-10-2018 00:00:00');
        debtors.sortedDebtors();
        
        debtors.selectedCustomerType = 'Residential';
        debtors.sortedDebtors();
    }
    
}