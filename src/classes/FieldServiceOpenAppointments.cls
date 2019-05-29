public with sharing class FieldServiceOpenAppointments {

	@InvocableMethod(label='Find open appointments in FieldService'
                     description='Currently acts as a Mock;')
    public static List<String> findOpen(List<String> postcodes) {
        List<String> results = new List<String>();
        for(String postcode : postcodes) {
            if (postcode.equals('HU4 7DW')) {
                results.add('Today');
            } else {
                results.add('Tomorrow');
            }
        }
        return results;
    }
}