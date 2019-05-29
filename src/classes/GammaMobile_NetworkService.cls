public class GammaMobile_NetworkService {
	public String selectedNetworkService {get; set;}
    
    public GammaMobile_NetworkService () {
        this.selectedNetworkService = '';
    }
    
    public Boolean addNetworkService (String networkService) {
        if (GammaMobile_ReferenceData.refNetworkService.containsKey(networkService)) {
        	this.selectedNetworkService = GammaMobile_ReferenceData.refNetworkService.get(networkService);
            return true;
        }
        
        return false;
    }
}