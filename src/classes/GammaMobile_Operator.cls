public class GammaMobile_Operator {
	public Set<String> operators {get; set;}
    
    public GammaMobile_Operator () {
        this.operators = new Set<String>();
    }
    
    public Boolean addOperator (String operator) {
        if (GammaMobile_ReferenceData.refOperator.containsKey(operator) && operators.size() == 0) {
        	this.operators.add(GammaMobile_ReferenceData.refOperator.get(operator));
            return true;
        }
        
        return false;
    }
}