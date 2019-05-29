public class GammaMobile_Usim {
    public String iccid {get; set;}
    public GammaMobile_UsimStatus usimStatus {get; set;}
    public GammaMobile_UsimType usimType {get; set;}
    public String homeImsi {get; set;}
    public String roamingImsi {get; set;}
    public GammaMobile_ChannelPartner channelPartner {get; set;}
    public String operator {get; set;}
    public DateTime startDate {get; set;}
    public DateTime endDate {get; set;}
    public String pin1 {get; set;}
    public String pin2 {get; set;}
    public String puk1 {get; set;}
    public String puk2 {get; set;}
    
    public GammaMobile_Usim () {
        this.iccid = '';
        this.usimStatus = new GammaMobile_UsimStatus();
        this.usimType = new GammaMobile_UsimType();
        this.homeImsi = '';
        this.roamingImsi = '';
        this.channelPartner = new GammaMobile_ChannelPartner();
        this.operator = '';
        this.startDate = DateTime.now();
        this.endDate = dateTime.now();
        this.pin1 = '';
        this.pin2 = '';
        this.puk1 = '';
        this.puk2 = '';
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('iccid', null) != null && node.getChildElement('iccid', null).getText() != null) {
            this.iccid = node.getChildElement('iccid', null).getText();
        }
        
        if(node.getChildElement('status', null) != null && node.getChildElement('status', null).getText() != null) {
            this.usimStatus.selectedUsimStatus = node.getChildElement('status', null).getText();
        }
        
        if(node.getChildElement('type', null) != null && node.getChildElement('type', null).getText() != null) {
            this.usimType.selectedUsimType = node.getChildElement('type', null).getText();
        }
        
        if(node.getChildElement('channelPartner', null) != null) {
            this.channelPartner.loadXml(node);
        }
        
        if(node.getChildElement('homeImsi', null) != null && node.getChildElement('homeImsi', null).getText() != null) {
            this.homeImsi = node.getChildElement('homeImsi', null).getText();
        }
        
        if(node.getChildElement('roamingImsi', null) != null && node.getChildElement('roamingImsi', null).getText() != null) {
            this.roamingImsi = node.getChildElement('roamingImsi', null).getText();
        }
        
        if(node.getChildElement('operator', null) != null && node.getChildElement('operator', null).getText() != null) {
            this.operator = node.getChildElement('operator', null).getText();
        }
        
        if(node.getChildElement('startDate', null) != null && node.getChildElement('startDate', null).getText() != null) {
            this.startDate = Date.valueOf(node.getChildElement('startDate', null).getText());
        }
        
        if(node.getChildElement('endDate', null) != null && node.getChildElement('endDate', null).getText() != null) {
            this.endDate = Date.valueOf(node.getChildElement('endDate', null).getText());
        }
        
        if(node.getChildElement('pin1', null) != null && node.getChildElement('pin1', null).getText() != null) {
            this.pin1 = node.getChildElement('pin1', null).getText();
        }
        
        if(node.getChildElement('pin2', null) != null && node.getChildElement('pin2', null).getText() != null) {
            this.pin2 = node.getChildElement('pin2', null).getText();
        }
        
        if(node.getChildElement('puk1', null) != null && node.getChildElement('puk1', null).getText() != null) {
            this.puk1 = node.getChildElement('puk1', null).getText();
        }
        
        if(node.getChildElement('puk2', null) != null && node.getChildElement('puk2', null).getText() != null) {
            this.puk2 = node.getChildElement('puk2', null).getText();
        }
        
        return true;
    }
}