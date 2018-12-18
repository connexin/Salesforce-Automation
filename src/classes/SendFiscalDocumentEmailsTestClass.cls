@isTest()
public class SendFiscalDocumentEmailsTestClass {
    
    static testMethod void unitTest() {
        Pricebook2 testPricebook = new Pricebook2(
            IsActive = true,
            Name = 'Standard Pricebook'
        );
        insert testPricebook;
        
        RecordType salesInvoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
        RecordType creditNoteRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'credit_note'];
        
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
        
        Account account = new Account(Name = 'Test Account', Auto_Send_Fiscal_Documents__c = true);
        insert account;
        
        Contact contact = new Contact(LastName = 'Test', Email = 'test@test.com', AccountId = account.Id);
        insert contact;
        
        Fiscal_Document__c fd = new Fiscal_Document__c(Account__c = account.Id, Description__c = 'Test', Draft__c = true, Dispute__c = false, Price_Book__c = testPricebook.Id, RecordTypeId = salesInvoiceRecordType.Id, Auto_Actions__c = true);
        insert fd;
        
        Fiscal_Document_Line__c fdl = new Fiscal_Document_Line__c(Fiscal_Document__c = fd.Id, Description__c = 'Test', Tax__c = testTax.Id, Nominal_Code__c = testNominalCode.Id, Product__c = testProduct.Id, Quantity__c = 1, Amount__c = 20.83);
        insert fdl;
        
        fd.Draft__c = false;
        update fd;
        
        Test.startTest();
        
        Database.executeBatch(new SendFiscalDocumentEmails());
        
        Test.stopTest();
        
        System.assertEquals(0, Database.countquery('SELECT COUNT() FROM Fiscal_Document__c WHERE Sent__c = false'));
    }
    
}