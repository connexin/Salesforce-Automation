public class GammaMobile_Tariff {
    public GammaMobile_TariffStatus tariffStatus {get; set;}
    public GammaMobile_TariffType tariffType {get; set;}
    public Date startDate {get; set;}
    
    public GammaMobile_Tariff () {
        this.tariffStatus = new GammaMobile_TariffStatus();
        this.tariffType = new GammaMobile_TariffType();
        this.startDate = date.today();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('status', null) != null && node.getChildElement('status', null).getText() != null) {
            this.tariffStatus.selectedTariffStatus = node.getChildElement('status', null).getText();
        }
        
        if(node.getChildElement('startDate', null) != null && node.getChildElement('startDate', null).getText() != null) {
            this.startDate = Date.valueOf(node.getChildElement('startDate', null).getText());
        }
        
        if(node.getChildElement('type', null) != null && node.getChildElement('type', null).getText() != null) {
            this.tariffType.selectedTariffType = node.getChildElement('type', null).getText();
        }
        
        return true;
    }
}