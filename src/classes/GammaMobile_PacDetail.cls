public class GammaMobile_PacDetail {
    public String pac {get; set;}
    public Date expiryDate {get; set;}
    public String pacStatus {get; set;}
    
    public GammaMobile_PacDetail () {
        this.pac = '';
        this.expiryDate = date.today(); 
        this.pacStatus = '';
    }
    
}