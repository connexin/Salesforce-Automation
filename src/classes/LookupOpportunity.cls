global class LookupOpportunity {

	@InvocableMethod(label='Lookup Opportunity by name' description='Returns the list of leads with matching postcodes')
    public static List<String> byName(List<String> names) {
        List<Id> ids = new List<Id>();
        for(String name : names) {
            List<Opportunity> Opportunities = [SELECT Id, Name, Description FROM Opportunity WHERE name like :name];
            for (Opportunity opportunity : Opportunities) {
                ids.add(opportunity.Id);
            }
        }
        return ids;
    }
}