public class GammaMobile_NetworkBars {
    public List<GammaMobile_NetworkBar> networkBars {get; set;}
    
    public GammaMobile_NetworkBars () {
        this.networkBars = new List<GammaMobile_NetworkBar>();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if (node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        for(DOM.XmlNode cnode: node.getChildren()) {
            GammaMobile_NetworkBar bar = new GammaMobile_NetworkBar();
            if(cnode.getText() != null) {
            	bar.selectedNetworkBar = cnode.getText();
                this.networkBars.add(bar);
            }
        }
        
        if(this.networkBars.size() == 0) {
            return false;
        }
        
        return true;
    }
}