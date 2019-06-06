public class Consumer {
    
    private Consumer__c consumer;
    
    public String Name {get;set;}
    public String CoverageCheckResult {get;set;}
    public String CreditCheckResult {get;set;}
    public String CustomerName {get;set;}
    public String CustomerState {get;set;}
    public String InstallationBooking {get;set;}
    public String Lead {get;set;}
    public String Opportunity {get;set;}
    public String Postcode {get;set;}
    public String Product {get;set;}
    public String SpecialInstructions {get;set;}
    public String ContractTerm {get;set;}
    
    public Consumer() {
        consumer = new Consumer__c();
    }
    
    public static Consumer parse(String json) {
        return (Consumer) System.JSON.deserialize(json, Consumer.class);
    }
    
}