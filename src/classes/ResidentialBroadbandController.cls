public class ResidentialBroadbandController {

    public String selectedLead { get; set; }
    public String selectedOpportunity { get; set; }

    public String consumerStatus { get; set; }
    public String consumerPostcode { get; set; }
    public String consumerName { get; set; }
    public String consumerAddress { get; set; }
    public String consumerLocality { get; set; }
    public String consumerCity { get; set; }
    public String consumerCounty { get; set; }
    public String consumerCountry { get; set; }

    public Boolean staticIP { get; set; }
    public String consumerPackage { get; set; }
    public String consumerTerm { get; set; }

    public String installationBooking { get; set; }
    public String bookingInstructions { get; set; }

    public CoverageCheckResult coverageResult = new CoverageCheckResult();
    public CreditCheckResult creditResult = new CreditCheckResult();

    public List<String> packageList;
    public List<String> termList;

    public Consumer__c consumer { get; set; }

    public ResidentialBroadbandController() {
		consumer = new Consumer__c();
    }

    // control navigation through the wizard.
    // Each returns a PageReference for one of the three pages in the wizard.
    // Note do not set the redirect attribute, URL should does not need to change.
    public PageReference step1() {
        System.debug('step1 ResidentialNewCustomerPage :' + consumerPostcode);

        consumer.Customer_State__c = CustomerState.initialise().label();
        insert consumer;

        return Page.ResidentialNewCustomer;
    }

    public PageReference step2() {
        if (String.isNotBlank(consumerPostcode)) {
        System.debug('step2 ResidentialNewCustomerCoverage :' + consumerPostcode);
            consumer.Lead__c = consumerPostcode;
        }
        
        if (String.isNotBlank(selectedLead)) {
	        System.debug('step2 selectedLead :' + selectedLead);
            consumer.Lead__c = selectedLead;
            // consumer.Name = 
        }

        if (String.isNotBlank(selectedOpportunity)) {
        	System.debug('step2 selectedOpportunity :' + selectedOpportunity);
            consumer.Opportunity__c = selectedOpportunity;
        }

        update consumer;
            
        return Page.ResidentialNewCustomerCoverage;
    }

    public PageReference step3() {
        
        // consumer.Coverage_Check_Result__c = coverageResult;

        return Page.ResidentialNewCustomerDetails;
    }

    public PageReference step4() {
		// consumer.Name

        // consumer.Credit_Check_Result__c = creditResult;
        
        return Page.ResidentialNewCustomerBooking;
    }

    public PageReference step5() {
        System.debug('step5 ResidentialCustomerMenu :' + consumerPostcode);
        saveConsumer();
        return Page.ResidentialCustomerMenu;
    }

    public PageReference cancel() {
        PageReference consumerPage = new ApexPages.StandardController(consumer).view();
        consumerPage.setRedirect(true);
        return consumerPage;
    }

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

    public List<TimeSlot> getOpenAppointments() {
        List<TimeSlot> openAppointments;
        openAppointments = [SELECT Id, DayOfWeek, StartTime, EndTime FROM TimeSlot];
        System.debug('openAppointments :  ' + openAppointments);
        return openAppointments;
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

    public List<SelectOption> opportunityList {
        get {
            opportunityList = new List<SelectOption>();
            
            for(Opportunity opportunity : getOpenOpportunities()) {
                opportunityList.add(new SelectOption(opportunity.Id, opportunity.Name));
            }
            return opportunityList;
        }
        set;
    }    
    
    public List<SelectOption> appointmentList {
        get {
            appointmentList = new List<SelectOption>();

            appointmentList.add(new SelectOption('1', 'Monday	09:00	11:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Monday	11:00	13:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Monday	13:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Monday	15:00	17:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	09:00	11:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	11:00	13:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	13:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	15:00	17:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	09:00	11:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	11:00	13:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	13:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	15:00	17:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	09:00	11:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	11:00	13:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	13:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	15:00	17:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	09:00	11:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	11:00	13:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	13:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	15:00	17:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Monday	09:00	12:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	09:00	12:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	09:00	12:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	09:00	12:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	09:00	12:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Monday	12:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Tuesday	12:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Wednesday	12:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Thursday	12:00	15:00	Normal'));
            appointmentList.add(new SelectOption('1', 'Friday	12:00	15:00	Normal'));
            // for(TimeSlot appointment : getOpenAppointments()) {
            //    String description = appointment.DayOfWeek + ':' + appointment.StartTime + '-' + appointment.EndTime;
            //    appointmentList.add(new SelectOption(new SelectOption(appointment.Id, description));
            //}
            return appointmentList;
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
    
    public PageReference checkCoverage() {
        if (String.isNotBlank(consumerPostcode)) {
            List<String> postcodeAsList = listFromString(consumerPostcode);
            List<Boolean> resultAsList = ResidentialCoverageCheck.byPostcode(postcodeAsList);
            Boolean result = booleanFromList(resultAsList);
            coverageResult = CoverageCheckResult.fromValue(result);
            if (!result) {
                showInfo('No coverage provided');
            }
        } else {
            showWarning('Cannot check coverage for blank postcode');
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
            Boolean result = booleanFromList(resultAsList);
            creditResult = CreditCheckResult.fromValue(result);
            if (!result) {
                showInfo('credit not available');
            }
        } else {
            showWarning('Cannot check credit for blank postcode');
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
    
    public PageReference saveConsumer() {
        System.debug('save consumerPostcode :' + consumerPostcode);

        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'INFO'));
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'WARNING'));
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'ERROR'));

 		consumer = new Consumer__c();
        
        if (String.isNotBlank(consumerPostcode)) {
            consumer.Postcode__c = consumerPostcode;
        }

        if (String.isNotBlank(consumerName)) {
            consumer.Customer_Name__c = consumerName;
        }

        if (String.isNotBlank(consumerAddress)) {
            consumer.Installation_Address__c = consumerAddress;
        }

        if (String.isNotBlank(consumerLocality)) {
            consumer.Installation_Locality__c = consumerLocality;
        }
        
        if (String.isNotBlank(consumerCity)) {
            consumer.Installation_City__c = consumerCity;
        }

        if (String.isNotBlank(consumerCounty)) {
            consumer.Installation_County__c = consumerCounty;
        }

        if (String.isNotBlank(consumerCountry)) {
            consumer.Installation_Country__c = consumerCountry;
        }
        
       	consumer.Static_IP__c = staticIP;
        
        if (String.isNotBlank(consumerPackage)) {
            consumer.Package_Name__c = consumerPackage;
        }
        
        if (String.isNotBlank(consumerTerm)) {
            consumer.Package_Term__c = consumerTerm;
        }

        if (String.isNotBlank(installationBooking)) {
            // consumer.Installation_Booking__c = installationBooking;
        }

        if (String.isNotBlank(bookingInstructions)) {
            consumer.Installation_Instructions__c = bookingInstructions;
        }

		consumer.Coverage_Check_Result__c = coverageResult.asString();
		consumer.Credit_Check_Result__c = creditResult.asString();
        
        try {
            insert consumer;
			} catch(DmlException ex) {
            ApexPages.addMessages(ex);
        }
        
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
        
        // Create WorkOrder
        
        // Create ServiceAppointment
        
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
        return aList.get(0);
    }
    
    public void showInfo(final String message) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, message));
    }    
    
    public void showWarning(final String message) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, message));
    }

    public void showError(final String message) {
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, message));
    }

}