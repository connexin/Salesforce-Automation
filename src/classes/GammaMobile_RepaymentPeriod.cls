public class GammaMobile_RepaymentPeriod {
	public String selectedRepaymentPeriod {get; set;}
    
    public GammaMobile_RepaymentPeriod () {
        this.selectedRepaymentPeriod = '';
    }
    
    public Boolean addRepaymentPeriod (String repaymentPeriod) {
        if (GammaMobile_ReferenceData.refRepaymentPeriod.containsKey(repaymentPeriod)) {
            this.selectedRepaymentPeriod = GammaMobile_ReferenceData.refRepaymentPeriod.get(repaymentPeriod);
            return true;
        }
        
        return false;
    }
}