public class GammaMobile_Provision {
    public String imei {get; set;}
    public GammaMobile_Tariff tariff {get; set;}
    public GammaMobile_Configuration config {get; set;}
    public GammaMobile_ProvisionContact contact {get; set;}
    public GammaMobile_AdvancedFunding advFunding {get; set;}
    public GammaMobile_PortDetail portDetail {get; set;}
    
    public GammaMobile_Provision () {
        this.imei = '';
        this.tariff = new GammaMobile_Tariff();
        this.config = new GammaMobile_Configuration();
        this.contact = new GammaMobile_ProvisionContact();
        this.advFunding = new GammaMobile_AdvancedFunding();
        this.portDetail = new GammaMobile_PortDetail();
    }
}