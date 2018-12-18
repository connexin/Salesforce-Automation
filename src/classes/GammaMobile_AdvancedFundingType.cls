public class GammaMobile_AdvancedFundingType {
	public String selectedAdvancedFundingType {get; set;}
    
    public GammaMobile_AdvancedFundingType () {
        this.selectedAdvancedFundingType = '';
    }
    
    public Boolean addAdvancedFundingType (String advancedFundingType) {
        if (GammaMobile_ReferenceData.refAdvancedFundingType.containsKey(advancedFundingType)) {
            this.selectedAdvancedFundingType = GammaMobile_ReferenceData.refAdvancedFundingType.get(advancedFundingType);
            return true;
        }
        
        return false;
    }
}