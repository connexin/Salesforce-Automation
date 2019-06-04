public class ResidentialCustomer {
    
    private CustomerState state;
    private Consumer__c consumer;
    
    public ResidentialCustomer() {
        state = CustomerState.initialise();
    	consumer = new Consumer__c();
        insert consumer;
    }

    public void updateConsumerState() {
		consumer.Customer_State__c = state.label();
		update consumer;
    }

    public void failedCoverage() {
        state.failedCoverage();
        updateConsumerState();
    }

    public void passedCoverage() {
        state.passedCoverage();
        updateConsumerState();
    }

    public void failedCredit() {
        state.failedCredit();
        updateConsumerState();
    }

    public void passedCredit() {
        state.passedCredit();
        updateConsumerState();
    }

    public void depositTaken() {
        state.depositTaken();
        updateConsumerState();
    }

    public void installationBooked() {
        state.installationBooked();
        updateConsumerState();
    }

    public void installationDispatched() {
        state.installationDispatched();
        updateConsumerState();
    }

	public void surveyPending() {
        state.surveyPending();
        updateConsumerState();
    }
    
	public void passedSurvey() {
        state.passedSurvey();
        updateConsumerState();
    }

	public void failedSurvey() {
        state.failedSurvey();
        updateConsumerState();
    }

	public void failedInstall() {
        state.failedInstall();
        updateConsumerState();
    }
    
	public void installationInProgress() {
        state.installationInProgress();
        updateConsumerState();
    }

	public void installationComplete() {
        state.installationComplete();
        updateConsumerState();        
    }
    
	public void installationCommissioned() {
        state.installationCommissioned();
        updateConsumerState();
    }

	public void active() {
        state.active();
        updateConsumerState();
    }

	public void suspendedBilling() {
        state.suspendedBilling();
        updateConsumerState();
    }

	public void suspendedOverage() {
        state.suspendedOverage();
        updateConsumerState();
    }

	public void onPaymentPlan() {
        state.onPaymentPlan();
        updateConsumerState();
    }

	public void onTransientPackage() {
        state.onTransientPackage();
        updateConsumerState();
    }

	public void cancelled() {
        state.cancelled();
        updateConsumerState();
    }
    
	public void lost() {
        state.lost();
        updateConsumerState();
    }

	public String asJson() {
        return JSON.serialize(this);
    }

    public void toLog() {
        System.debug('ResidentialCustomer.toLog : ' + asJson());
    }          

}