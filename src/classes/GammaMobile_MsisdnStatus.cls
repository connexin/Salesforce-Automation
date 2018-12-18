public class GammaMobile_MsisdnStatus {
	public String selectedMsisdnStatus {get; set;}
    
    public GammaMobile_MsisdnStatus () {
        this.selectedMsisdnStatus = '';
    }
    
    public Boolean addMsisdnStatus (String msisdnStatus) {
        if (GammaMobile_ReferenceData.refMsisdnStatus.containsKey(msisdnStatus)) {
        	this.selectedMsisdnStatus = GammaMobile_ReferenceData.refMsisdnStatus.get(msisdnStatus);
            return true;
        }
        
        return false;
    }
}