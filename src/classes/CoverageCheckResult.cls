public class CoverageCheckResult {

    private StatusResult result = StatusResult.PENDING;

    public static CoverageCheckResult fromValue(final Boolean aBoolean) {
		return new CoverageCheckResult(aBoolean);
    }
    
    public CoverageCheckResult() {
		result = StatusResult.PENDING;
    }    
    
    public CoverageCheckResult(final Boolean value) {
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