public class ResidentialBroadband {

    protected Consumer__c consumer {get;set;}
    protected CustomerState state {get;set;}

    public static ResidentialBroadband create() {
        System.debug('ResidentialBroadband.create');
        ResidentialBroadband instance = new ResidentialBroadband();
        return instance;
    }        

    public static ResidentialBroadband create(final String postcode, final String name) {
        System.debug('ResidentialBroadband.create ' + postcode + '-' + name);
        ResidentialBroadband instance = new ResidentialBroadband(postcode, name);
        return instance;
    }        

    public static ResidentialBroadband find(final String postcode, final String name) {
        System.debug('ResidentialBroadband.find ' + postcode);
        ResidentialBroadband instance = new ResidentialBroadband();
        instance.selectConsumerRow(postcode, name);
        return instance;
    }

    private ResidentialBroadband() {
		consumer = new Consumer__c();
        consumer.Customer_State__c = state.label();
        // insert consumer;
    }
    
    private ResidentialBroadband(final String postcode, final String name) {
		consumer = new Consumer__c();
        state = CustomerState.initialise();
        consumer.Customer_State__c = state.label();
        consumer.Postcode__c = postcode;
        consumer.Customer_Name__c = name;
        // insert consumer;
    }

    private void selectConsumerRow(final String postcode, final String name) {
        consumer = [SELECT Id,
                    Account__c,
                    Contact__c,
                    Contract_Term__c,
                    Coverage_Check_Result__c,
                    Credit_Check_Result__c,
                    Customer_Name__c,
                    Customer_State__c,
                    Installation_Address__c,
                    Installation_Booking__c,
                    Installation_City__c,
                    Installation_Country__c,
                    Installation_County__c,
                    Installation_Instructions__c,
                    Installation_Locality__c,
                    Installation_Work_Order__c,
                    Lead__c,
                    Name,
                    Opportunity__c,
                    Package_Name__c,
                    Package_Term__c,
                    Postcode__c,
                    Product__c,
                    Service_Appointment__c,
                    Static_IP__c 
                    FROM Consumer__c 
                    WHERE Postcode__c LIKE :postcode AND Name LIKE :name
                    LIMIT 1];
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
    
    private void updateConsumerState() {
        consumer.Customer_State__c = state.label();
        update consumer;
    }

    public String asJson() {
        return JSON.serialize(this);
    }
    
    public void toLog() {
        System.debug('ResidentialCustomer.toLog : ' + asJson());
    }

}