global class LookupConsumerOpportunity {

   @InvocableMethod
   public static List<String> byName(List<String> names) {
       List<Id> ids = new List<Id>();
       List<Opportunity> Opportunities = [SELECT Id FROM Opportunity WHERE name in :names];
      for (Opportunity opportunity : Opportunities) {
         ids.add(opportunity.Id);
      }
      return ids;
   }

    // todo 
    // @InvocableMethod
    // public static List<String> byPostcode(List<String> postcodes) { }
    
}