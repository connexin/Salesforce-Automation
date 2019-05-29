public class GammaMobile_NetworkBar {
	public String selectedNetworkBar {get; set;}
    
    public GammaMobile_NetworkBar () {
        this.selectedNetworkBar = '';
    }
    
    public Boolean addNetworkBar (String networkBar) {
        if (GammaMobile_ReferenceData.refNetworkBar.containsKey(networkBar)) {
        	this.selectedNetworkBar = GammaMobile_ReferenceData.refNetworkBar.get(networkBar);
            return true;
        }
        return false;
    }
}