public class GoCardlessRefund {
    public String id {get; set;}
    public Decimal amount {get; set;}
    public Decimal total_amount_confirmation {get; set;}
    public String reference {get; set;}
    public GoCardlessObjectLinks links {get;set;}
    public Boolean error {get; set;}
    public String error_desc {get; set;}
}