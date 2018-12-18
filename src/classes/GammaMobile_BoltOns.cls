public class GammaMobile_BoltOns {
    public List<GammaMobile_BoltOn> boltOns {get; set;}
    
    public GammaMobile_BoltOns () {
        this.boltOns = new List<GammaMobile_BoltOn>();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        for(DOM.XmlNode cnode: node.getChildren()) {
            GammaMobile_BoltOn bo = new GammaMobile_BoltOn();
            if(cnode.getText() != null) {
            	bo.selectedBoltOn = cnode.getText();
                this.boltOns.add(bo);
            }
        }
        
        if(this.boltOns.size() == 0) {
            return false;
        }
        
        return true;
    }
}