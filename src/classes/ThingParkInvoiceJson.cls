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
        ThingParkInvoiceJson jsonData = (ThingParkInvoiceJson) JSON.deserialize(jsonStr, ThingParkInvoiceJson.class);
        System.assert(String.isNotBlank(jsonData.accountId));
        System.assert(String.isNotBlank(jsonData.description));
        System.assert(String.isNotBlank(jsonData.referencePeriod));
        System.assert(String.isNotBlank(jsonData.actionDate));
        for(Line line : jsonData.lines) {
	        System.assert(String.isNotBlank(line.productId));
	        System.assert(String.isNotBlank(line.description));
	        System.assert(String.isNotBlank(line.qty));
	        System.assert(String.isNotBlank(line.unitPrice));            
        }
        return true;
	}

	public static ThingParkInvoiceJson parse(String jsonStr) {
		return (ThingParkInvoiceJson) JSON.deserialize(jsonStr, ThingParkInvoiceJson.class);
	}
}