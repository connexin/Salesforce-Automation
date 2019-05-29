public class GammaMobile_BoltOn {
    public String selectedBoltOn {get; set;}
    
    public GammaMobile_BoltOn () {
        this.selectedBoltOn = '';
    }
    
    public Boolean addBoltOn (String boltOn) {
        if (GammaMobile_ReferenceData.refBoltOn.containsKey(boltOn)) {
        	this.selectedBoltOn = GammaMobile_ReferenceData.refBoltOn.get(boltOn);
            return true;
        }
        
        return false;
    }
}