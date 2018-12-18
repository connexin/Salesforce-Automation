public class GammaMobile_NotificationOptions {
    public List<GammaMobile_NotificationOption> notificationOptions {get; set;}
    
    public GammaMobile_NotificationOptions () {
        this.notificationOptions = new List<GammaMobile_NotificationOption>();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        for(DOM.XmlNode cnode: node.getChildren()) {
            GammaMobile_NotificationOption no = new GammaMobile_NotificationOption();
            if(cnode.getText() != null) {
                no.selectedNotificationOption = cnode.getText();
                this.notificationOptions.add(no);
            }
        }
        
        if(notificationOptions.size() == 0) {
            return false;
        }
        
        return true;
    }
}