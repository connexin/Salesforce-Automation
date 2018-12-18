public class GammaMobile_NetworkServices {
    public List<GammaMobile_NetworkService> networkServices {get; set;}
    
    public GammaMobile_NetworkServices () {
        this.networkServices = new List<GammaMobile_NetworkService>();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        Integer i = 0;
        for(DOM.XmlNode cnode: node.getChildren()) {
            GammaMobile_NetworkService ns = new GammaMobile_NetworkService();
            if(cnode.getText() != null) {
                ns.selectedNetworkService = cnode.getText();
                this.networkServices.add(ns);
            }
        }
        
        if (this.networkServices.size() == 0) {
            return false;
        }
        
        return true;
    }
}