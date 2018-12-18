public class GammaMobile_PortData {
    public String pac {get; set;}
    public Date pacExpiryDate {get; set;}
    public Date portDate {get; set;}
    public Integer portInPacId {get; set;}
    
    public GammaMobile_PortData () {
        this.pac = '';
        this.pacExpiryDate = DateTime.now().date();
        this.portDate = DateTime.now().date();
        this.portInPacId = null;
    }
}