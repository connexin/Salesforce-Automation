public class GammaMobile_PortDetail {
    public String msisdn {get; set;}
    public Date portDate {get; set;}
    public GammaMobile_PacDetail pacDetail {get; set;}
    
    public GammaMobile_PortDetail () {
        this.msisdn = '';
        this.portDate = Date.today();
        this.pacDetail = new GammaMobile_PacDetail();
    }
}