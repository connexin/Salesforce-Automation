public class GammaMobile_TariffStatus {
	public String selectedTariffStatus {get; set;}
    
    public GammaMobile_TariffStatus () {
        this.selectedTariffStatus = '';
    }
    
    public Boolean addTariffStatus (String tariffStatus) {
        if (GammaMobile_ReferenceData.refTariffStatus.containsKey(tariffStatus)) {
        	this.selectedTariffStatus = GammaMobile_ReferenceData.refTariffStatus.get(tariffStatus);
            return true;
        }
        
        return false;
    }
}