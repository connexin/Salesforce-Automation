public class GammaMobile_Handset {
    public String imei {get; set;}
    public Boolean blacklisted {get; set;}
    
    public GammaMobile_Handset () {
        this.imei = '';
        this.blacklisted = false;
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('imei', null) != null && node.getChildElement('imei', null).getText() != null) {
            this.imei = node.getChildElement('imei', null).getText();
        }
        
        if(node.getChildElement('blacklisted', null) != null && node.getChildElement('blacklisted', null).getText() != null) {
            this.blacklisted = Boolean.valueOf(node.getChildElement('blacklisted', null).getText());
        }
        
        return true;
    }
}