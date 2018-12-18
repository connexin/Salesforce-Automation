/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class FiscalDocumentsActionsControllerTestCLs {

    static testMethod void testConfirmation() {
        // TO DO: implement unit test
        
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
        
        fd = [SELECT Id, Name, Account__c, Description__c, Draft__c, Dispute__c, Price_Book__c, Subtotal__c, Amount_Allocated__c, Reference__c, Sent__c FROM Fiscal_Document__c WHERE Id = :fd.Id];
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(fd);
        FiscalDocumentsActionsController controller = new FiscalDocumentsActionsController(stdController);
        
        PageReference pg = controller.unsetActions();
        system.assertEquals(controller.firstConfirmation, false);
        system.assertEquals(controller.fiscal_document.Auto_Actions__c, false);
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentView?id=' + String.valueOf(fd.Id));
        
        pg = controller.setFirstActions();
        system.assertEquals(controller.firstConfirmation, true);
        system.assertEquals(controller.fiscal_document.Auto_Actions__c, false);
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentActionsConfirmation?firstconf=true&id=' + String.valueOf(fd.Id));
        
        pg = controller.setSecondActions();
        system.assertEquals(controller.firstConfirmation, true);
        system.assertEquals(controller.fiscal_document.Auto_Actions__c, true);
        system.assertEquals(pg.getUrl(), '/apex/FiscalDocumentView?id=' + String.valueOf(fd.Id));
       
    }
    
    
}