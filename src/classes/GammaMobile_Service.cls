public class GammaMobile_Service {
    public GammaMobile_ServiceStatus status {get; set;}
    public GammaMobile_Msisdn msisdn {get; set;}
    public GammaMobile_Usim usim {get; set;}
    public GammaMobile_Handset handset {get; set;}
    public GammaMobile_Tariff tariff {get; set;}
    public GammaMobile_Configuration config {get; set;}
    public GammaMobile_Response gammaResponse {get; set;}
    public Date startDate {get; set;}
    
    public GammaMobile_Service () {
        this.msisdn = new GammaMobile_Msisdn();
        this.usim = new GammaMobile_Usim();
        this.handset = new GammaMobile_Handset();
        this.tariff = new GammaMobile_Tariff();
        this.config = new GammaMobile_Configuration();
        this.status = new GammaMobile_ServiceStatus();
        this.startDate = date.today();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            system.debug('NODE EMPTY, RETURNING');
            return false;
        }
        
        if(node.getChildElement('status', null) != null && node.getChildElement('status', null).getText() != null) {
            this.status.selectedServiceStatus = node.getChildElement('status', null).getText();
        }
        
        this.msisdn.loadXml(node.getChildElement('msisdn', null));
        this.usim.loadXml(node.getChildElement('usim', null));
        this.handset.loadXml(node.getChildElement('handset', null));
        this.tariff.loadXml(node.getChildElement('tariff', null));
        this.config.loadXml(node.getChildElement('configuration', null));
        
        return true;
    }
}