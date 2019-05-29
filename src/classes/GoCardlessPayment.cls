public class GoCardlessPayment {
    public String id {get;set;}
    public DateTime created_at {get;set;}
    public Date charge_date {get;set;}
    public Integer amount {get;set;}
    public String description {get;set;}
    public String currency_code {get;set;}
    public String status {get;set;}
    public String reference {get;set;}
    public Integer amount_refunded {get;set;}
    public GoCardlessObjectLinks links {get;set;}
}