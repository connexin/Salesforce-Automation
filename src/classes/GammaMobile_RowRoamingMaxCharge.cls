public class GammaMobile_RowRoamingMaxCharge {
	public String selectedRowRoamingMaxCharge {get; set;}
    
    public GammaMobile_RowRoamingMaxCharge () {
        this.selectedRowRoamingMaxCharge = null;
    }
    
    public Boolean addRoamingMaxCharge (String rowRoamingMaxCharge) {
        if (GammaMobile_ReferenceData.refRowRoamingMaxCharge.containsKey(rowRoamingMaxCharge)) {
            this.selectedRowRoamingMaxCharge = GammaMobile_ReferenceData.refRowRoamingMaxCharge.get(rowRoamingMaxCharge);
        	return true;
        }
        return false;
    }
}