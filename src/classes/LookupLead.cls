public class LookupLead {

	@InvocableMethod(label='Lookup Leads by postcode' description='Returns the list of leads with matching postcodes')
    public static List<String> byPostcode(List<String> postcodes) {
		List<Id> ids = new List<Id>();
		for(String postcode : postcodes) {
        	List<Lead> leads = [SELECT Id FROM Lead WHERE PostalCode like :postcode];
            for (Lead lead : leads) {
                ids.add(lead.Id);
            }
        }
        return ids;
    }

}