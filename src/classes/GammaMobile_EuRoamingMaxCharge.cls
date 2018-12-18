public class GammaMobile_EuRoamingMaxCharge {
	public String selectedEuRoamingMaxCharge {get; set;}
    
    public GammaMobile_EuRoamingMaxCharge () {
        this.selectedEuRoamingMaxCharge = null;
    }
    
    public Boolean addEuRoamingMaxCharge (String EuRoamingMaxCharge) {
        if (GammaMobile_ReferenceData.refEuRoamingMaxCharge.containsKey(EuRoamingMaxCharge)) {
            this.selectedEuRoamingMaxCharge = GammaMobile_ReferenceData.refEuRoamingMaxCharge.get(EuRoamingMaxCharge);
            return true;
        }
        
        return false;
    }
}