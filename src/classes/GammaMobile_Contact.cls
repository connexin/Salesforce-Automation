public class GammaMobile_Contact {
    public String name {get; set;}
    public String emailAddress {get; set;}
    public String phoneNumber {get; set;}
    
    public GammaMobile_Contact () {
        this.name = '';
        this.emailAddress = '';
        this.phoneNumber = '';
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('name', null) != null && node.getChildElement('name', null).getText() != null) {
            this.name = node.getChildElement('name', null).getText();
        }
        
        if(node.getChildElement('emailAddress', null) != null && node.getChildElement('emailAddress', null).getText() != null) {
            this.emailAddress = node.getChildElement('emailAddress', null).getText();
        }
        
        if(node.getChildElement('phoneNumber', null) != null && node.getChildElement('phoneNumber', null).getText() != null) {
            this.phoneNumber = node.getChildElement('phoneNumber', null).getText();
        }
        return true;
    }
}