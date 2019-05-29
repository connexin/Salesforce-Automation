public with sharing class ResidentialCreditCheck {

	@InvocableMethod(label='Residential Credit Check by Postcode'
                     description='Currently acts as a Mock; fails if our postcode is used, otherwise passes.')
    public static List<Boolean> byPostcode(List<String> postcodes) {
        List<Boolean> results = new List<Boolean>();
        for(String postcode : postcodes) {
            if (postcode.equals('HU4 7DW')) {
                results.add(false);
            } else {
                results.add(true);                
            }
        }
        return results;
    }

}