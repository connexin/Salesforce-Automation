public with sharing class ResidentialCoverageCheck {

	@InvocableMethod(label='Residential Coverage Check by Postcode' 
                     description='Currently acts as a Mock; passes if a Hull postcode is used, otherwise fails.')
    public static List<Boolean> byPostcode(List<String> postcodes) {
        List<Boolean> results = new List<Boolean>();
        for(String postcode : postcodes) {
            if (postcode.startsWith('HU')) {
                results.add(true);
            } else {
                results.add(false);                
            }
        }
        return results;
    }
}