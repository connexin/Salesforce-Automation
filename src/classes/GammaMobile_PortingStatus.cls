public class GammaMobile_PortingStatus {
	public String selectedPortingStatus {get; set;}
    
    public GammaMobile_PortingStatus () {
        this.selectedPortingStatus = '';
    }
    
    public Boolean addPortingStatus (String portingStatus) {
        if (GammaMobile_ReferenceData.refPortingStatus.containsKey(portingStatus)) {
        	this.selectedPortingStatus = GammaMobile_ReferenceData.refPortingStatus.get(portingStatus);
            return true;
        }
        
        return false;
    }
}