public class FiscalDocumentLineController {
    private ApexPages.StandardController stdController;
    public Fiscal_Document_Line__c fiscal_document_line {get; set;}
    public Decimal subtotal {get; set;}
    public Decimal tax_subtotal {get; set;}
    public Decimal net_subtotal {get; set;}
    public Id pricebook {get; set;}
    
    public FiscalDocumentLineController(ApexPages.StandardController controller) {
        this.stdController = controller;
        this.fiscal_document_line = (Fiscal_Document_Line__c)this.stdController.getRecord();
        if (this.fiscal_document_line.Id != null) {
            this.fiscal_document_line = [SELECT Id, Fiscal_Document__c, Product__c, Description__c, Amount__c, Quantity__c, Nominal_Code__C, Tax__c, Net_Subtotal__c, Tax_Subtotal__c, Subtotal__c FROM Fiscal_Document_Line__c WHERE Id = :this.fiscal_document_line.Id];
        }
        
        if (Default_Tax__c.getValues('default') != null) {
            this.fiscal_document_line.Tax__c = Default_Tax__c.getValues('default').Tax__c;
        }
        
        this.subtotal = this.fiscal_document_line.Subtotal__c;
        this.tax_subtotal = this.fiscal_document_line.Tax_Subtotal__c;
        this.net_subtotal = this.fiscal_document_line.Net_Subtotal__c;
        
        if (this.pricebook == null) {
            Fiscal_Document__c fiscalDocument = [SELECT Id, Price_Book__c FROM Fiscal_Document__c WHERE Id = :this.fiscal_document_line.Fiscal_Document__c];
            this.pricebook =  fiscalDocument.Price_Book__c;
        }
    }
    
    public PageReference save() {
        try {
            if (this.fiscal_document_line.Id == null) {
                insert this.fiscal_document_line;
            } else {
                update this.fiscal_document_line;
            }
        } catch (Exception e) { 
            ApexPages.addMessages(e);
            return null;
        }
        
        return this.stdController.save();
    }
    
    public void selectProduct() {
        Pricebook2 selPricebook;
        Set<Id> pricebookIds = new Set<Id>();
        for (Pricebook2 pricebook : [SELECT Id, IsStandard FROM Pricebook2 WHERE IsStandard = true OR Id = :this.pricebook]) {
            pricebookIds.add(pricebook.Id);
            if (pricebook.IsStandard == false) {
                selPricebook = pricebook;
            }
        }
        
        Product2 product = [SELECT Id, Description, Nominal_Code__c FROM Product2 WHERE Id = :this.fiscal_document_line.Product__c];
        this.fiscal_document_line.Description__c = product.Description;
        
        for (PricebookEntry pricebookentry : [SELECT Id, UnitPrice, Pricebook2Id FROM PricebookEntry WHERE Product2Id = :product.Id AND Pricebook2Id IN :pricebookIds]) {
            //If we're using the standard pricebook
            if (selPricebook == null) {
                this.fiscal_document_line.Amount__c = pricebookentry.UnitPrice;
                //If we've specified a pricebook
            } else if (pricebookentry.Pricebook2Id == selPricebook.Id) {
                this.fiscal_document_line.Amount__c = pricebookentry.UnitPrice;
                //If we've specified a pricebook but there is no pricebook entry for the selected product
            } else if (selPricebook != null) {
                this.fiscal_document_line.Amount__c = pricebookentry.UnitPrice;
            }
        }
        
        this.fiscal_document_line.Nominal_Code__c = product.Nominal_Code__c;
        
        this.calculateSubtotals();
    }
    
    public void calculateSubtotals() {
        if (this.fiscal_document_line.Tax__c == null) {
            this.fiscal_document_line.Tax_Rate__c = 0;
        } else {
            Tax__c tax = [SELECT Id, Rate__c FROM Tax__c WHERE Id = :this.fiscal_document_line.Tax__c];
            this.fiscal_document_line.Tax_Rate__c = tax.Rate__c;
        }
        
        this.subtotal = this.fiscal_document_line.Amount__c * (1 + this.fiscal_document_line.Tax_Rate__c / 100) * this.fiscal_document_line.Quantity__c;
        this.tax_subtotal = this.fiscal_document_line.Amount__c * this.fiscal_document_line.Tax_Rate__c / 100 * this.fiscal_document_line.Quantity__c;
        this.net_subtotal = this.subtotal - this.tax_subtotal;
    }
    
}