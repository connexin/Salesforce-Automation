public class DynamicConsumerController {

    public String getQueryString() {
        return new SelectAllColumns('Consumer__c').soql;
    }

    public String getQueryResults() {
		return '' + Database.query(getQueryString());
    }
    
}