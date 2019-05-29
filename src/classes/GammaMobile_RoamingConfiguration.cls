public class GammaMobile_RoamingConfiguration {
    public GammaMobile_NotificationOptions notificationOptions {get; set;}
    public GammaMobile_EuRoamingMaxCharge euRoamingMaxCharge {get; set;}
    public GammaMobile_RowRoamingMaxCharge rowRoamingMaxCharge {get; set;}
    
    public GammaMobile_RoamingConfiguration () {
        this.notificationOptions = new GammaMobile_NotificationOptions();
        this.euRoamingMaxCharge = new GammaMobile_EuRoamingMaxCharge();
        this.rowRoamingMaxCharge = new GammaMobile_RowRoamingMaxCharge();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('notificationOptions', null) != null && node.getChildElement('notificationOptions', null).getChildren().size() != 0) {
            if(!this.notificationOptions.loadXml(node.getChildElement('notificationOptions', null))) {
            	return false;
            }
        }
        
        if(node.getChildElement('euRoamingMaxCharge', null) != null && node.getChildElement('euRoamingMaxCharge', null).getText() != null) {
            this.euRoamingMaxCharge.selectedEuRoamingMaxCharge = node.getChildElement('euRoamingMaxCharge', null).getText();
        }
        
        if(node.getChildElement('rowRoamingMaxCharge', null) != null && node.getChildElement('rowRoamingMaxCharge', null).getText() != null) {
            this.rowRoamingMaxCharge.selectedRowRoamingMaxCharge = node.getChildElement('rowRoamingMaxCharge', null).getText();
        }
        
        return true;
    }
    
}