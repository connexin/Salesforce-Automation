public class DirectDebitController {
    
    private Direct_Debit__c direct_debit;
    private ApexPages.StandardController stdController;
    
    public String curBankAccountId {get;set;}
    
    public DirectDebitController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.direct_debit = (Direct_Debit__c)this.stdController.getRecord();
    }
    
    public PageReference viewBankAccount() {
        PageReference pg = new PageReference('/apex/DirectDebitBankAccountView?id=' + this.curBankAccountId);
        pg.setRedirect(true);
        return pg;
    }
    
    public GoCardlessCustomerBankAccount getBankAccount() {
        return GoCardlessAPI.getBankAccount(ApexPages.currentPage().getParameters().get('id'));
    }
    
    public GoCardlessCustomerBankAccount[] getBankAccounts() {
        return GoCardlessAPI.getCustomerBankAccounts(this.direct_debit.Name);
    }
    
    public GoCardlessPayment[] getPayments() {
        return GoCardlessAPI.getCustomerPayments(this.direct_debit.Name);
    }
    
    public GoCardlessMandate[] getMandates() {
        return GoCardlessAPI.getCustomerBankAccountMandates(ApexPages.currentPage().getParameters().get('id'));
    }
    
    public void disableBankAccount() {
        system.debug(this.curBankAccountId);
        GoCardlessAPI.disableCustomerBankAccount(this.curBankAccountId);
    }
    
    public PageReference createBankAccount() {
        PageReference pg = new PageReference('/apex/DirectDebitBankAccountCreate?id=' + this.curBankAccountId);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference save() {
        if (this.direct_debit.Name != null) {
            if (!GoCardlessAPI.isValidGoCardlessID(this.direct_debit.Name)) {
                this.direct_debit.Name.addError('Go Cardless ID is not Valid');
                return ApexPages.currentPage();
            }
        } else {
            GoCardlessCustomer goCardlessCustomer = GoCardlessAPI.createCustomer(this.direct_debit.Account__c);
            this.direct_debit.Name = goCardlessCustomer.id;
        }
        
        try {
            if (this.direct_debit.Id == null) {
                insert this.direct_debit;
            } else {
                
                Direct_Debit__c curDirectDebit = [SELECT Id, Name, Account__c FROM Direct_Debit__c WHERE Id = :this.direct_debit.Id];
                if (curDirectDebit.Account__c != this.direct_debit.Account__c) {
                    GoCardlessCustomer goCardlessCustomer = new GoCardlessCustomer();
                    goCardlessCustomer.id = this.direct_debit.Id;
                    goCardlessCustomer.company_name = String.valueOf(this.direct_debit.Account__c);
                    GoCardlessAPI.updateCustomer(goCardlessCustomer);
                }
                
                update this.direct_debit;
            }
        } catch (Exception e) {
            ApexPages.addMessages(e);
            return ApexPages.currentPage();
        }
                
        PageReference pg = new PageReference('/' + this.direct_debit.Id);
        pg.setRedirect(true);
        return pg;
    }
    
}