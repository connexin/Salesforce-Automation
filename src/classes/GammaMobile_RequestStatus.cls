public class GammaMobile_RequestStatus {
	public Set<String> requestStatuses {get; set;}
    
    public GammaMobile_RequestStatus () {
        this.requestStatuses = new Set<String>();
    }
    
    public Boolean addRequestStatuses (String requestStatus) {
        if (GammaMobile_ReferenceData.refRequestStatus.containsKey(requestStatus) && requestStatuses.size() == 0) {
        	this.requestStatuses.add(GammaMobile_ReferenceData.refRepaymentPeriod.get(requestStatus));
            return true;
        }
        
        return false;
    }
}