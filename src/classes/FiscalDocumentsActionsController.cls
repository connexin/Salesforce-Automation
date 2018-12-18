public class FiscalDocumentsActionsController {
    private ApexPages.StandardController stdController;
    public Fiscal_Document__c fiscal_document {get; set;}
    public Boolean firstConfirmation {get; set;}
    
    public FiscalDocumentsActionsController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.firstConfirmation = false;
        
        this.fiscal_document = (Fiscal_Document__c)this.stdController.getRecord();
        if (this.fiscal_document != null) {
            this.fiscal_document.Auto_Actions__c = false;
            this.fiscal_document = [SELECT Id, Reference__c, Auto_Actions__c, RecordType.Name FROM Fiscal_Document__c WHERE Id =: this.fiscal_document.Id];
        }
        
        if (System.currentPageReference().getParameters().get('firstconf') != null) {
            this.firstConfirmation = Boolean.valueOf(System.currentPageReference().getParameters().get('firstconf'));
        }
    }
    
    public PageReference setFirstActions () {
        this.firstConfirmation = true;
        PageReference pg = new PageReference('/apex/FiscalDocumentActionsConfirmation?id=' + String.valueOf(this.fiscal_document.Id) + '&firstconf=true');
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference setSecondActions () {
        this.fiscal_document.Auto_Actions__c  = true;
        update this.fiscal_document;
        System.debug(this.fiscal_document);
        PageReference pg = new PageReference('/apex/FiscalDocumentView?id=' + String.valueOf(this.fiscal_document.Id));
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference unsetActions () {
        this.fiscal_document.Auto_Actions__c  = false;
        update this.fiscal_document;
        PageReference pg = new PageReference('/apex/FiscalDocumentView?id=' + String.valueOf(this.fiscal_document.Id));
        pg.setRedirect(true);
        return pg;
    }
    
}