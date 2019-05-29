public class CreditCheckResult {

    private StatusResult result = StatusResult.PENDING;

    public static CreditCheckResult fromValue(final Boolean aBoolean) {
		return new CreditCheckResult(aBoolean);
    }

    public CreditCheckResult() {
		result = StatusResult.PENDING;
    }

    public CreditCheckResult(final Boolean value) {
        if (value == true) {
            result = StatusResult.PASSED;
        } else {
            result = StatusResult.FAILED;
        }
    }

    public Boolean isPending() {
        return result == StatusResult.PENDING;
    }    
    
    public Boolean isPassed() {        
        return result == StatusResult.PASSED;
    }    
    
    public Boolean isFailed() {        
        return result == StatusResult.FAILED;
    }    

}