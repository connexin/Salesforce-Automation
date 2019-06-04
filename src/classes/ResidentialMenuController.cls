public class ResidentialMenuController {

    public ApexPages.StandardController stdController;

    public PageReference newCustomer() {
        return Page.ResidentialNewCustomer;
    }

    public PageReference addDataToCustomer() {
        return Page.ExistingResidentialAddData;
    }

    public PageReference changeCustomerPackage() {
        return Page.ExistingResidentialChangePackage;
    }

    public PageReference customerPaymentPlan() {
        return Page.ExistingResidentialPaymentPlan;
    }

    public PageReference cancelCustomerAccount() {
        return Page.ExistingResidentialCancelAccount;
    }

}