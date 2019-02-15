public class ThingParkInvoiceJson {

	public String accountId { get; set;}
	public String description { get; set;}
	public String referencePeriod { get; set;}
	public String actionDate { get; set;}
	public List<Line> lines { get; set;}

	public class Line {
		public String productId { get; set;}
		public String description { get; set;}
		public String qty { get; set;}
		public String unitPrice { get; set;}
	}

	public static boolean verify(String jsonStr) {
        System.debug('ThingParkInvoiceJson.verify.jsonStr : ' + jsonStr);
        ThingParkInvoiceJson jsonData = (ThingParkInvoiceJson) JSON.deserialize(jsonStr, ThingParkInvoiceJson.class);
        System.debug('ThingParkInvoiceJson.verify.jsonData : ' + jsonData);
        System.assert(String.isNotBlank(jsonData.accountId), 'accountId cannot be blank');
        System.assert(String.isNotBlank(jsonData.description), 'description cannot be blank');
        System.assert(String.isNotBlank(jsonData.referencePeriod), 'referencePeriod cannot be blank');
        System.assert(String.isNotBlank(jsonData.actionDate), 'actionDate cannot be blank');
        for(Line line : jsonData.lines) {
	        System.assert(String.isNotBlank(line.productId), 'productId cannot be blank');
	        System.assert(String.isNotBlank(line.description), 'description cannot be blank');
	        System.assert(String.isNotBlank(line.qty), 'qty cannot be blank');
	        System.assert(String.isNotBlank(line.unitPrice), 'unitPrice cannot be blank');
        }
        return true;
	}

	public static ThingParkInvoiceJson parse(String jsonStr) {
		return (ThingParkInvoiceJson) JSON.deserialize(jsonStr, ThingParkInvoiceJson.class);
	}
}