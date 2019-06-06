public class ConsumerDTO extends AbstractDTO {

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

    public ConsumerDTO() {
        consumer = new Consumer__c();
    }
    
    public ConsumerDTO(final String id) {
        consumer = [SELECT id FROM Consumer__c WHERE id = :id];
    }
    
    public static ConsumerDTO parse(String json) {
        return (ConsumerDTO) System.JSON.deserialize(json, ConsumerDTO.class);
    }
    
}