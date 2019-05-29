@isTest
private class AccountStatementTestClass {

    static testMethod void testAccountStatement() {
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
        
        Account account = new Account(Name = 'Test', Auto_Reconcile__c = true);
        insert account;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = true, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id);
        
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        AccountStatement acctStatement;
        
        acctStatement = new AccountStatement();
        system.assertEquals(1, ApexPages.getMessages().size());
        system.assertEquals('Account ID not Specified', ApexPages.getMessages()[0].getDetail());
        
        ApexPages.currentPage().getParameters().put('accountid', account.Id);
        acctStatement = new AccountStatement();
        
        system.assertEquals(2, ApexPages.getMessages().size());
        system.assertEquals('There are Disputed Invoices on the Account', ApexPages.getMessages()[1].getDetail());
        
        acctStatement.startDate = Date.today();
        acctStatement.endDate = Date.today().addDays(-30);
        acctStatement.initStatement();
        
        system.assertEquals(3, ApexPages.getMessages().size());
        system.assertEquals('From date cannot be greater than To date', ApexPages.getMessages()[2].getDetail());
        
        acctStatement.startDate = Date.today();
        acctStatement.endDate = Date.today().addDays(30);
        acctStatement.initStatement();
        
        system.assertEquals(4, ApexPages.getMessages().size());
        system.assertEquals('From/To Dates cannot be in future', ApexPages.getMessages()[3].getDetail());
        
        system.assertEquals(0, acctStatement.getInitialBalance());
        system.assertEquals(0, acctStatement.getLastBalance());
        system.assertEquals(0, acctStatement.getOpeningDebit());
        system.assertEquals(0, acctStatement.getOpeningCredit());
		system.assertEquals(25, acctStatement.getClosingDebit());
        system.assertEquals(25, acctStatement.getClosingCredit());
        
        system.assertEquals('/apex/ManualReconcileCreditItem', acctStatement.manualReconcile().getUrl().split('\\?')[0]);
        system.assertEquals('/apex/PaymentTake', acctStatement.takePayment().getUrl().split('\\?')[0]);
        system.assertEquals('/apex/PaymentTake', acctStatement.takeOutstandingPayment().getUrl().split('\\?')[0]);
    }
    
    static testMethod void testAccountStatement2() {
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
    	
        Account account = new Account(Name = 'Test', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id, Date__c = Date.today().addDays(-30));
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 25);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        ApexPages.currentPage().getParameters().put('accountid', account.Id);
		AccountStatement acctStatement = new AccountStatement();
        
        acctStatement.initStatementOutstandingOnly();
        
        acctStatement.startDate = Date.today();
        acctStatement.endDate = Date.today().addDays(-30);
        acctStatement.initStatementOutstandingOnly();
        
        system.assertEquals(1, ApexPages.getMessages().size());
        system.assertEquals('From date cannot be greater than To date', ApexPages.getMessages()[0].getDetail());
        
        acctStatement.startDate = Date.today();
        acctStatement.endDate = Date.today().addDays(30);
        acctStatement.initStatementOutstandingOnly();
        
        system.assertEquals(2, ApexPages.getMessages().size());
        system.assertEquals('From/To Dates cannot be in future', ApexPages.getMessages()[1].getDetail());
    }
    
    static testMethod void testAccountStatement3() {
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
    	
        Account account = new Account(Name = 'Test', Auto_Reconcile__c = true);
        insert account;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = creditNoteRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 10);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Payment__c payment = new Payment__c(Account__c = account.Id, Amount__c = 25, Draft__c = true, Confirmed__c = false, Failed__c = false, Description__c = 'Test');
        insert payment;
        payment.Draft__c = false;
        payment.Confirmed__c = true;
        update payment;
        
        Refund__c refund = new Refund__c(Payment__c = payment.Id, Amount__c = 10, Draft__c = false);
        insert refund;
        
        ApexPages.currentPage().getParameters().put('accountid', account.Id);
		AccountStatement acctStatement = new AccountStatement();
        
        acctStatement.initStatement();
    }
        
        //--------------------------------------------------
        
        
	static testMethod void testAccountStatement4() {
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
        Account account = new Account(Name = 'Test', Auto_Reconcile__c = true);
        insert account;
        AccountStatement acctStatement = new AccountStatement();
        acctStatement.accountId = account.Id;
        acctStatement.account = account;
        
        acctStatement.initStatement();
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test Different', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = creditNoteRecordType.Id);
        insert fd;

        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Nominal_Code__c = testNominalCode.Id, Quantity__c = 1, Amount__c = 10);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Contact contact = new Contact(FirstName = 'test', LastName = 'email', Email = 'test@test.com', AccountId = account.Id);
        insert contact;
        acctStatement.sendEmail();
        
        PageReference pg;
        pg = acctStatement.viewPdf();
        system.assertEquals(pg.getUrl(), '/apex/AccountStatementPDF?accountId=' + String.valueOf(account.Id) + '&enddate=' + String.valueOf(acctStatement.endDate) + '&startdate=' + String.valueOf(acctStatement.startDate) + '&unallocatedonly=' + String.valueOf(acctStatement.outstandingOnly));
        
        system.assertEquals(acctStatement.getOddRowColour(), 'white',' here 1');
        system.assertEquals(acctStatement.getEvenRowColour(), '#f7f7f9',' here 2');
        
        system.assertEquals(acctStatement.getTextColour(), '#00bb00',' here 3');
        system.assertEquals(acctStatement.getLogo(), PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl(),' here 4');
        system.assertEquals(acctStatement.getFooterImage(), PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl(),' here 5');
        system.assertEquals(acctStatement.getWebsite(), 'smartcities.connexin.co.uk',' here 6');
        
        account.Type = 'Residential';
        acctStatement.account = account;
        system.assertEquals(acctStatement.getTextColour(), '#ec1c24',' here 7');
        system.assertEquals(acctStatement.getLogo(), PageReference.forResource('Connexin_Home_Logo').getUrl(),' here 8');
        system.assertEquals(acctStatement.getFooterImage(), PageReference.forResource('Connexin_Home_Footer').getUrl(),' here 9');
        system.assertEquals(acctStatement.getWebsite(), 'home.connexin.co.uk',' here 10');
        
        account.Type = 'Business';
        acctStatement.account = account;
        system.assertEquals(acctStatement.getTextColour(), '#00aff0',' here 11');
        system.assertEquals(acctStatement.getLogo(), PageReference.forResource('Connexin_Business_Logo').getUrl(),' here 12');
        system.assertEquals(acctStatement.getFooterImage(), PageReference.forResource('Connexin_Business_Footer').getUrl(),' here 13');
        system.assertEquals(acctStatement.getWebsite(), 'business.connexin.co.uk',' here 14');
        
        account.Type = 'Public Sector';
        acctStatement.account = account;
        system.assertEquals(acctStatement.getTextColour(), '#00bb00',' here 15');
        system.assertEquals(acctStatement.getLogo(), PageReference.forResource('Connexin_Smart_Cities_Logo').getUrl(),' here 16');
        system.assertEquals(acctStatement.getFooterImage(), PageReference.forResource('Connexin_Smart_Cities_Footer').getUrl(),' here 17');
        system.assertEquals(acctStatement.getWebsite(), 'smartcities.connexin.co.uk',' here 18');     
        
    }
}