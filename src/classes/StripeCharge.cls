public class StripeCharge {
	public String id;
	public Integer amount;
	public Integer amount_refunded;
    public Boolean error {get; set;}
    public String error_desc {get; set;}
	
	public StripeCharge(String id, Integer amount, Integer amount_refunded) {
		this.id = id;
		this.amount = amount;
		this.amount_refunded = amount_refunded;
        this.error = false;
        this.error_desc = null;
	}
	
}