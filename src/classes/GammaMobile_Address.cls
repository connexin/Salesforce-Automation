public class GammaMobile_Address {
    public String thoroughfareNumber {get; set;}
    public String thoroughfareName {get; set;}
    public String town {get; set;}
    public String county {get; set;}
    public String postcode {get; set;}
    
    public GammaMobile_Address () {
        this.thoroughfareNumber = '';
        this.thoroughfareName = '';
        this.town = '';
        this.county = '';
        this.postcode = '';
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('thoroughfareNumber', null) != null && node.getChildElement('thoroughfareNumber', null).getText() != null) {
            this.thoroughfareNumber = node.getChildElement('thoroughfareNumber', null).getText();
        }
        
        if(node.getChildElement('thoroughfareName', null) != null && node.getChildElement('thoroughfareName', null).getText() != null) {
            this.thoroughfareName = node.getChildElement('thoroughfareName', null).getText();
        }
        
        if(node.getChildElement('town', null) != null && node.getChildElement('town', null).getText() != null) {
            this.town = node.getChildElement('town', null).getText();
        }
        
        if(node.getChildElement('county', null) != null && node.getChildElement('county', null).getText() != null) {
            this.county = node.getChildElement('county', null).getText();
        }
        
        if(node.getChildElement('postcode', null) != null && node.getChildElement('postcode', null).getText() != null) {
            this.postcode = node.getChildElement('postcode', null).getText();
        }
        
        return true;
    }
}