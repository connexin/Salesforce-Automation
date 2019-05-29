public class ThingParkUsageJson {

	public String accountId { get; set;}
	public String tenancyId { get; set;}
    public String productId { get; set;}
	public String description { get; set;}
	public String referencePeriod { get; set;}
	public Date actionDate { get; set;}
	public PackageUsage packageUsage { get; set;}
	public MessageUsage messageUsage { get; set;}
	public MessageUsage eolUsage { get; set;}

	public class PackageUsage {
		public String packageId { get; set;}
		public String productId { get; set;}
		public String description { get; set;}
		public Integer activeDevices { get; set;}
		public String label { get; set;}
	}

	public class MessageUsage {
		public String packageId { get; set;}
		public String productId { get; set;}
		public String description { get; set;}
		public Integer messageCount { get; set;}
		public String label { get; set;}
	}

    public static boolean verify(String jsonStr) {
        System.debug('ThingParkUsageJson.verify.jsonStr : ' + jsonStr);
        ThingParkUsageJson jsonData = (ThingParkUsageJson) JSON.deserialize(jsonStr, ThingParkUsageJson.class);
        System.debug('ThingParkUsageJson.verify.jsonData : ' + jsonData);
        System.assert(String.isNotBlank(jsonData.accountId), 'accountId cannot be blank');
        System.assert(String.isNotBlank(jsonData.tenancyId), 'tenancyId cannot be blank');
        System.assert(String.isNotBlank(jsonData.description), 'description cannot be blank');
        System.assert(String.isNotBlank(jsonData.referencePeriod), 'referencePeriod cannot be blank');
        System.assert(jsonData.actionDate != null, 'actionDate cannot be blank');

        System.assert(jsonData.packageUsage != null, 'packageUsage cannot be blank');
        System.assert(String.isNotBlank(jsonData.packageUsage.productId), 'productId cannot be blank');
        System.assert(String.isNotBlank(jsonData.packageUsage.packageId), 'packageId cannot be blank');
        System.assert(jsonData.packageUsage.activeDevices != null, 'activeDevices cannot be blank');

        System.assert(jsonData.messageUsage != null, 'messageUsage cannot be blank');
        System.assert(String.isNotBlank(jsonData.messageUsage.productId), 'productId cannot be blank');
        System.assert(String.isNotBlank(jsonData.messageUsage.packageId), 'packageId cannot be blank');
        System.assert(jsonData.messageUsage.messageCount != null, 'messageCount cannot be blank');

        System.assert(jsonData.eolUsage != null, 'eolUsage cannot be blank');
        System.assert(String.isNotBlank(jsonData.eolUsage.productId), 'productId cannot be blank');
        System.assert(String.isNotBlank(jsonData.eolUsage.packageId), 'packageId cannot be blank');
        System.assert(jsonData.eolUsage.messageCount != null, 'messageCount cannot be blank');

        return true;
    }

	public static ThingParkUsageJson parse(String jsonStr) {
		return (ThingParkUsageJson) JSON.deserialize(jsonStr, ThingParkUsageJson.class);
	}
}