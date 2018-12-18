public class GammaMobile_UsimStatus {
    public String selectedUsimStatus {get; set;}
    
    public GammaMobile_UsimStatus () {
        this.selectedUsimStatus = '';
    }
    
    public Boolean addUsimStatus (String usimStatus) {
        if (GammaMobile_ReferenceData.refUsimStatus.containsKey(usimStatus)) {
        	this.selectedUsimStatus = GammaMobile_ReferenceData.refUsimStatus.get(usimStatus);
            return true;
        }
        
        return false;
    }
}