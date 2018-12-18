public class GammaMobile_Msisdn {
	public String value {get; set;}
    public GammaMobile_MsisdnStatus status {get; set;}
    public GammaMobile_PortingStatus portingStatus {get; set;}
    public GammaMobile_ChannelPartner channelPartner {get; set;}
    public GammaMobile_PortData portData {get; set;}
    public String operator {get; set;}
    public DateTime startDate {get; set;}
    
    public GammaMobile_Msisdn () {
        this.value = '';
        this.status = new GammaMobile_MsisdnStatus();
        this.portingStatus = new GammaMobile_PortingStatus();
        this.channelPartner = new GammaMobile_ChannelPartner();
        this.portData = new GammaMobile_PortData();
        this.operator = '';
        this.startDate = DateTime.now().date();
    }
    
    public Boolean loadXml (DOM.XmlNode node) {
        if(node == null || node.getChildren().size() == 0) {
            return false;
        }
        
        if(node.getChildElement('value', null) != null && node.getChildElement('value', null).getText() != null) {
            this.value = node.getChildElement('value', null).getText();
        }
        
        if(node.getChildElement('operator', null) != null && node.getChildElement('operator', null).getText() != null) {
            this.operator = node.getChildElement('operator', null).getText();
        }
        
        if(node.getChildElement('startDate', null) != null && node.getChildElement('startDate', null).getText() != null) {
            this.startDate = DateTime.valueOf(JSON.deserialize(node.getChildElement('startDate', null).getText(), DateTime.class));
        }
        
        if(node.getChildElement('portData', null) != null) {
            DOM.XmlNode portDataNode = node.getChildElement('portData', null);
            if(portDataNode.getChildElement('pac', null) != null && portDataNode.getChildElement('pac', null).getText() != null) {
                this.portData.pac = portDataNode.getChildElement('pac', null).getText();
            }
            
            if(portDataNode.getChildElement('pacExpiryDate', null) != null && portDataNode.getChildElement('pacExpiryDate', null).getText() != null) {
                this.portData.pacExpiryDate = Date.valueOf(JSON.deserialize(portDataNode.getChildElement('pacExpiryDate', null).getText(), Date.class));
            }
            
            if(portDataNode.getChildElement('portDate', null) != null && portDataNode.getChildElement('portDate', null).getText() != null) {
                this.portData.portDate = Date.valueOf(JSON.deserialize(portDataNode.getChildElement('portDate', null).getText(), Date.class));
            }
            
            if(portDataNode.getChildElement('portInPacId', null) != null && portDataNode.getChildElement('portInPacId', null).getText() != null) {
                this.portData.portInPacId = Integer.valueOf(portDataNode.getChildElement('portInPacId', null).getText());
            }
        }
        
        if(node.getChildElement('portingStatus', null) != null && node.getChildElement('portingStatus', null).getText() != null) {
            this.portingStatus.selectedPortingStatus = node.getChildElement('portingStatus', null).getText();
        }
        
        if(node.getChildElement('channelPartner', null) != null) {
            DOM.XmlNode cpNode = node.getChildElement('channelPartner', null);
            this.channelPartner.name = cpNode.getChildElement('name', null).getText();
        }
        
        if(node.getChildElement('status', null) != null && node.getChildElement('status', null).getText() != null) {
            this.status.selectedMsisdnStatus = node.getChildElement('status', null).getText();
        }
        return true;
    }
}