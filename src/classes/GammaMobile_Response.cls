public class GammaMobile_Response {
	public String errorCode {get; set;}
    public String errorMessage {get; set;}
    public Boolean errorStatus {get; set;}
    public Integer httpResponseCode {get; set;}
    public Integer defaultSuccessResponseCode {get; set;}
    public Integer provisionCancelSuccessResponseCode {get; set;}
    public GammaMobile_RequestStatus gammaRequestStatus {get; set;}
    
    public GammaMobile_Response () {
        this.errorCode = '';
        this.errorMessage = '';
        this.errorStatus = true;
        this.defaultSuccessResponseCode = 200;
        this.provisionCancelSuccessResponseCode = 204;
        this.httpResponseCode = null;
        this.gammaRequestStatus = new GammaMobile_RequestStatus();
    }
}