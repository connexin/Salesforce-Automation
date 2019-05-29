public class ResidentialBroadbandController {

    public String selectedLead { get; set; }
    public String selectedOpportunity { get; set; }

    public String consumerPostcode { get; set; }
    public String consumerName { get; set; }
    public String consumerAddress { get; set; }
    public Boolean staticIP { get; set; }
    public String consumerPackage { get; set; }
    public String consumerTerm { get; set; }
    public String bookingDate { get; set; }
    public String bookingTime { get; set; }
    public String bookingInstructions { get; set; }

    public CoverageCheckResult coverageResult;
    public CreditCheckResult creditResult;

    public List<String> packageList;
    public List<String> termList;

    public Consumer__c consumer { get; set; }

    public List<Lead> getOpenLeads() {
        System.debug('getOpenLeads for : ' + consumerPostcode);
		List<Lead> openLeads;

        if (String.isNotBlank(consumerPostcode)) {
            String searchTerm = '%'+consumerPostcode+'%';
            openLeads = [SELECT Id, Name, Address, City, PostalCode 
                     FROM Lead 
                     WHERE PostalCode LIKE :searchTerm];
        } else {
            openLeads = [SELECT Id, Name, Address, City, PostalCode FROM Lead];
        }

        System.debug('openLeads for : ' + openLeads);
        return openLeads;
    }
    
    public List<Opportunity> getOpenOpportunities() {
        System.debug('getOpenOpportunities for : ' + consumerPostcode);        
		List<Opportunity> openOpportunities;

        if (String.isNotBlank(consumerPostcode)) {
            String searchTerm = '%'+consumerPostcode+'%';            
            openOpportunities = [SELECT o.Name, a.BillingPostalCode 
                             FROM Opportunity o, o.Account a 
                             WHERE a.BillingPostalCode LIKE :searchTerm];
            
        } else {
            openOpportunities = [SELECT o.Name, a.BillingPostalCode 
                             FROM Opportunity o, o.Account a];
        }

        System.debug('openOpportunities for : ' + openOpportunities);        
        return openOpportunities;
    }

	public List<SelectOption> leadList {
        get {
            leadList = new List<SelectOption>();
            
            for(Lead lead : getOpenLeads()) {
                leadList.add(new SelectOption(lead.Id, lead.Name));
            }
            return leadList;
        }
        set;
    }    
	public List<SelectOption> OpportunityList {
        get {
            OpportunityList = new List<SelectOption>();
            
            for(Opportunity opportunity : getOpenOpportunities()) {
                OpportunityList.add(new SelectOption(opportunity.Id, opportunity.Name));
            }
            return OpportunityList;
        }
        set;
    }    

    public List<String> getPackageList() {
        packageList = new List<String>();
        packageList.add('Essential');
        packageList.add('Extra');
        packageList.add('Extreme');
        return packageList;
    }    

    public List<String> getTermList() {
        termList = new List<String>();
        termList.add('18 Months');
        termList.add('24 Months');
        termList.add('36 Months');
        termList.add('48 Months');
        return termList;
    }

    // control navigation through the wizard.
    // Each returns a PageReference for one of the three pages in the wizard.
    // Note do not set the redirect attribute, URL should does not need to change.
    public PageReference step1() {
        System.debug('step1 ResidentialNewCustomerPage :' + consumerPostcode);
        return Page.ResidentialNewCustomerPage;
    }

    public PageReference step2() {
        System.debug('step2 ResidentialNewCustomerCoverage :' + consumerPostcode);
        return Page.ResidentialNewCustomerCoverage;
    }

    public PageReference step3() {
        System.debug('step3 ResidentialNewCustomerDetails :' + consumerPostcode);
        return Page.ResidentialNewCustomerDetails;
    }

    public PageReference step4() {
        System.debug('step4 ResidentialNewCustomerBooking :' + consumerPostcode);
        return Page.ResidentialNewCustomerBooking;
    }

    public PageReference step5() {
        System.debug('step5 ResidentialCustomerMenu :' + consumerPostcode);
        return Page.ResidentialCustomerMenu;
    }

    public PageReference cancel() {
        PageReference consumerPage = new ApexPages.StandardController(consumer).view();
        consumerPage.setRedirect(true);
        return consumerPage;
    }

    public PageReference checkCoverage() {
        if (String.isNotBlank(consumerPostcode)) {
            List<String> postcodeAsList = listFromString(consumerPostcode);
            List<Boolean> resultAsList = ResidentialCoverageCheck.byPostcode(postcodeAsList);
			coverageResult = CoverageCheckResult.fromValue(booleanFromList(resultAsList));
        }
        return null;
    }

    public PageReference cancelCheckCoverage() {
        coverageResult = CoverageCheckResult.fromValue(false);
        return null;
    }

    public PageReference checkCredit() {
        if (String.isNotBlank(consumerPostcode)) {
            List<String> postcodeAsList = listFromString(consumerPostcode);
            List<Boolean> resultAsList = ResidentialCreditCheck.byPostcode(postcodeAsList);
			creditResult = CreditCheckResult.fromValue(booleanFromList(resultAsList));
        }
        return null;
    }
    
    public PageReference cancelCheckCredit() {
        creditResult = CreditCheckResult.fromValue(false);
        return null;
    }

    public List<Product2> getProducts() {
        return [SELECT Id, Name, Description, Family, ProductCode, IsActive FROM Product2 WHERE Family = 'LORAWAN' LIMIT 10];
    }

    public boolean getCoverageIsPending() {
    	return coverageResult.isPending();
    }

    public boolean getCoverageIsPassed() {
    	return coverageResult.isPassed();
    }

    public boolean getCoverageIsFailed() {
    	return coverageResult.isFailed();
    }

    public boolean getCreditIsPending() {
    	return creditResult.isPending();
    }

    public boolean getCreditIsPassed() {
    	return creditResult.isPassed();
    }

    public boolean getCreditIsFailed() {
    	return creditResult.isFailed();
    }

    public PageReference save() {
        System.debug('save consumerPostcode :' + consumerPostcode);                

        // Create the account.
        // insert the contact's phone number into the account phone number field.
        // account.phone = contact.phone;
        // insert account;

        // Create the contact.
        // insert the account id into the contact 
        // contact.accountId = account.id;
        // insert contact;

        // Create the opportunity.
        // insert the account id in the opportunity
        // opportunity.accountId = account.id;
        // insert opportunity;

        // join the contact role and the opportunity
        // role.opportunityId = opportunity.id;
        // role.contactId = contact.id;
        // insert role;

        PageReference consumerPage = new ApexPages.StandardController(consumer).view();
        consumerPage.setRedirect(true);

        return consumerPage;
    }

    public List<String> listFromString(final String aString) {
        List<String> aList = new List<String>();
        aList.add(aString);
        return aList;
    }

    public Boolean booleanFromList(final List<Boolean> aList) {
        return aList.get(1);
    }

}