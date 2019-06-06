public class SelectAllColumns {
    
    public String allfields;
    public String soql;
    
    // public SelectAllColumns() {}

    public SelectAllColumns(String sfo) {
        Map<String, schema.sobjecttype> allSObjects = Schema.getGlobalDescribe();
        Schema.SObjectType q = allSObjects.get(sfo);
        Schema.DescribeSObjectResult data = q.getdescribe();
        Map<String, schema.sobjectfield> fields = data.fields.getMap();
        Set<String> keys = fields.keyset();
        String query = '';
        for(String field : keys) { query = query + '\n\t' + field + ', '; }
        query = query.subString(0,query.length()-2);
        this.allfields = query;
        this.SOQL = 'SELECT ' + query + ' FROM ' + sfo;
    }
}