public class GammaMobile_Configuration {
    public GammaMobile_NetworkServices networkServices {get; set;}
    public GammaMobile_NetworkBars networkBars {get; set;}
    public GammaMobile_BoltOns boltOns {get; set;}
    public GammaMobile_RoamingConfiguration roamingConfig {get; set;}
    
    public GammaMobile_Configuration () {
        this.networkServices = new GammaMobile_NetworkServices();
        this.networkBars = new GammaMobile_NetworkBars();
        this.boltOns = new GammaMobile_BoltOns();
        this.roamingConfig = new GammaMobile_RoamingConfiguration();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        this.networkServices.loadXml(node.getChildElement('networkServices', null));
        this.boltOns.loadXml(node.getChildElement('boltOns', null));
        this.roamingConfig.loadXml(node.getChildElement('roamingConfiguration', null));
        this.networkBars.loadXml(node.getChildElement('networkBars', null));
        return true;
    }
}