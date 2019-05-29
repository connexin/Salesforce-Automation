public class GammaMobile_NotificationOption {
	public String selectedNotificationOption {get; set;}
    
    public GammaMobile_NotificationOption () {
        this.selectedNotificationOption = '';
    }
    
    public Boolean addNotificationOption (String notificationOption) {
        if (GammaMobile_ReferenceData.refNotificationOption.containsKey(notificationOption)) {
        	this.selectedNotificationOption = GammaMobile_ReferenceData.refNotificationOption.get(notificationOption);
            return true;
        }
        
        return false;
    }
}