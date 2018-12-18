public class GammaMobile_ChannelPartner {
    public String name {get; set;}
    
    public GammaMobile_ChannelPartner () {
        this.name= '';
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('name', null) != null && node.getChildElement('name', null).getText() != null) {
            this.name = node.getChildElement('name', null).getText();
        }
        
        return true;
    }
}