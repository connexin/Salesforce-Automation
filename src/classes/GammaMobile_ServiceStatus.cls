public class GammaMobile_ServiceStatus {
	public String selectedServiceStatus {get; set;}
    
    public GammaMobile_ServiceStatus () {
        this.selectedServiceStatus = '';
    }
    
    public Boolean addServiceStatus (String serviceStatus) {
        if (GammaMobile_ReferenceData.refServiceStatus.containsKey(serviceStatus)) {
        	this.selectedServiceStatus = GammaMobile_ReferenceData.refServiceStatus.get(serviceStatus);
            return true;
        }
        
        return false;
    }
}