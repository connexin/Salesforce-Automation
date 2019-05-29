public class GammaMobile_TariffType {
	public String selectedTariffType {get; set;}
    
    public GammaMobile_TariffType () {
        this.selectedTariffType = '';
    }
    
    public Boolean addTariffType (String tariffType) {
        if (GammaMobile_ReferenceData.refTariffType.containsKey(tariffType)) {
            this.selectedTariffType = GammaMobile_ReferenceData.refTariffType.get(tariffType);
            return true;
        }
        
        return false;
    }
}