public class GammaMobile_AdvancedFunding {
    public GammaMobile_AdvancedFundingType advFundingType {get; set;}
    public GammaMobile_RepaymentPeriod repaymentPeriod {get; set;}
    public Date startDate {get; set;}
    
    public GammaMobile_AdvancedFunding () {
        this.advFundingType = new GammaMobile_AdvancedFundingType();
        this.repaymentPeriod = new GammaMobile_RepaymentPeriod();
        this.startDate = date.today();
    }
}