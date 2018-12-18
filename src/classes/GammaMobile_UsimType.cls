public class GammaMobile_UsimType {
	public String selectedUsimType {get; set;}
    
    public GammaMobile_UsimType () {
        this.selectedUsimType = '';
    }
    
    public Boolean addUsimType (String usimType) {
        if (GammaMobile_ReferenceData.refUsimType.containsKey(usimType)) {
        	this.selectedUsimType = GammaMobile_ReferenceData.refUsimType.get(usimType);
            return true;
        }
        
        return false;
    }
}