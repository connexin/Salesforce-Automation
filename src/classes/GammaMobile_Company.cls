public class GammaMobile_Company {
    public String externalReference {get; set;}
    public String name {get; set;}
    public String portalStatus {get; set;}
    public GammaMobile_Contact contact {get; set;}
    public GammaMobile_Address address {get; set;}
    public GammaMobile_ChannelPartner channelPartner {get; set;}
    
    public GammaMobile_Company () {
        this.externalReference = '';
        this.name = '';
        this.portalStatus = '';
        this.contact = new GammaMobile_Contact();
        this.address = new GammaMobile_Address();
        this.channelPartner = new GammaMobile_ChannelPartner();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('name', null) != null && node.getChildElement('name', null).getText() != null) {
            this.name = node.getChildElement('name', null).getText();
        }
        
        if(node.getChildElement('portalStatus', null) != null && node.getChildElement('portalStatus', null).getText() != null) {
            this.portalStatus = node.getChildElement('portalStatus', null).getText();
        }
        
        if(node.getChildElement('externalReference', null) != null && node.getChildElement('externalReference', null).getText() != null) {
            this.externalReference = node.getChildElement('externalReference', null).getText();
        }
        
        if(node.getChildElement('contact', null) != null) {
            this.contact.loadXml(node.getChildElement('contact', null));
        }
        
        if(node.getChildElement('address', null) != null) {
            this.address.loadXml(node.getChildElement('address', null));
        }
        
        if(node.getChildElement('channelPartner', null) != null) {
            this.channelPartner.loadXml(node.getChildElement('channelPartner', null));
        }
        
        return true;
    }
}