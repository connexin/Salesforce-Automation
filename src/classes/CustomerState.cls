public class CustomerState {

    public class StateException extends Exception {}
	public Customer_State__mdt customerState;

    public static CustomerState initialise() {
        return new CustomerState();
    }
    
    public static CustomerState selectBy(final String stateName) {
        return new CustomerState(stateName);
    }

    private CustomerState() {
        setState('Pending');
    }

    // Use the named state
    private CustomerState(final String stateName) {
        setState(stateName);
    }

    private void setState(final String stateName) {
        final List<Customer_State__mdt> rows = [
            SELECT DeveloperName, Label, Description__c
            FROM Customer_State__mdt 
            WHERE DeveloperName = :stateName 
            LIMIT 1];

        if (rows.size() == 0) {
            throw new StateException('State not found with name : ' + stateName);
        } else if (rows.size() > 1) {
            throw new StateException('To many states found with name : ' + stateName);
        } else  {
            customerState = rows.get(0);
			System.debug('customerCredit : ' + customerState);
        }
    }

    public String stateName() {
        return customerState.DeveloperName;
    }

    public String label() {
        return customerState.Label;
    }

    public String description() {
        return customerState.Description__c;
    }

    public void failedCoverage() {
        setState('Lost_No_Coverage');
    }

    public void passedCoverage() {
        setState('Coverage_Passed');
    }

    public void failedCredit() {
        setState('Lost_Credit');
    }

    public void passedCredit() {
        setState('Credit_Check_Passed');
    }

    public void depositTaken() {
        setState('Deposit_Taken');
    }

    public void installationBooked() {
        setState('Installation_Booked');
    }

    public void installationDispatched() {
        setState('Installation_Dispatched');
    }

	public void surveyPending() {
        setState('Survey_Pending');
    }
    
	public void passedSurvey() {
        setState('Survey_Passed');
    }

	public void failedSurvey() {
        setState('Lost_Failed_Survey');
    }

	public void failedInstall() {
        setState('Lost_Failed_Install');
    }
    
	public void installationInProgress() {
        setState('Installation_in_Progress');
    }

	public void installationComplete() {
        setState('Installation_Complete');
    }
    
	public void installationCommissioned() {
        setState('Installation_Commissioned');
    }

	public void active() {
        setState('Active_Customer');
    }

	public void suspendedBilling() {
        setState('Suspended_Billing');
    }

	public void suspendedOverage() {
        setState('Suspended_Overage');
    }

	public void onPaymentPlan() {
        setState('On_Payment_Plan');
    }

	public void onTransientPackage() {
        setState('Transient');
    }

	public void cancelled() {
        setState('Cancelled');
    }
    
	public void lost() {
        setState('Lost_Other');
    }

	public String asJson() {
        return JSON.serialize(customerState);
    }

    public void toLog() {
        System.debug('CustomerState.toLog : ' + asJson());
    }          
    
}