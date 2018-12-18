public class GammaMobile_CallForward {
    public String type {get; set;}
    public String forwardToNumber {get; set;}
    public Boolean voicemail {get; set;}
    
    public GammaMobile_CallForward () {
        this.type = '';
        this.forwardToNumber = '';
        this.voicemail = false;
    }
    
    public Boolean setCallForward (String forwardType, String dstNumber, Boolean sendToVoicemail) {
        if(!GammaMobile_ReferenceData.refCallForward.containsKey(type)) {
            return false;
        }
        
        if(!sendToVoicemail && (dstNumber == null || dstNumber.length() < 11)) {
            return false;
        }
        
        this.type = forwardType;
        this.forwardToNumber = dstNumber;
        this.voicemail = sendToVoicemail;
        return true;
    }
}