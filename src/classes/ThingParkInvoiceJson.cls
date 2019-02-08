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

	public static ThingParkInvoiceJson parse(String jsonStr) {
		return (ThingParkInvoiceJson) JSON.deserialize(jsonStr, ThingParkInvoiceJson.class);
	}
}