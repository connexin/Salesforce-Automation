public class DebtorsController {
    
    public Boolean includeDisputedInvoices {get; set;}
    public Boolean includeOpenInvoices {get; set;}
    public Boolean includePendingPayments {get;set;}
    public List<SelectOption> customerTypes {get; set;}
    public String selectedCustomerType {get; set;}
    public Date invoiceCutoffDate {get; set;}
    
    public transient List<SortedDebtorsList> sortedDebtors {get; set;}
    public Integer offset {get; set;}
    public Integer dataLimit {get; set;}
    public Integer totalDebtors {get; set;}
    public List<SortedDebtorsList> debtorsToShow {get; set;}
    public Boolean nextEnable {get; set;}
    public Boolean prevEnable {get; set;}
    public String reportDate {get; set;}
    
    public DebtorsController() {
    	if (this.includeDisputedInvoices == null) {
    		if (System.currentPageReference().getParameters().get('') != null) {
    			this.includeDisputedInvoices = Boolean.valueOf(System.currentPageReference().getParameters().get('includedisputed'));   
    		} else {
    			this.includeDisputedInvoices = false;
    		}
    	}
    	
    	if (this.selectedCustomerType == null) {
	        if (System.currentPageReference().getParameters().get('customertype') != null) {
	        	this.selectedCustomerType = System.currentPageReference().getParameters().get('customertype');    
	        } else {
	            this.selectedCustomerType = 'All';
	        }
    	}
    	
    	this.includeOpenInvoices = true;
    	
    	if (this.invoiceCutoffDate == null) {
	        if (System.currentPageReference().getParameters().get('cutoffDate') != null) {
	        	this.invoiceCutoffDate = Date.valueOf(System.currentPageReference().getParameters().get('cutoffDate'));    
	        } else {
	            this.invoiceCutoffDate = Date.today();
	        }
    	}
    	
    	if (this.includePendingPayments == null) {
	        if (System.currentPageReference().getParameters().get('includePendingPayments') != null) {
	        	this.includePendingPayments = Boolean.valueOf(System.currentPageReference().getParameters().get('includePendingPayments'));
	        } else {
	            this.includePendingPayments = true;
	        }
    	}
    	
        this.reportDate = this.invoiceCutoffDate.year() + '-' + this.invoiceCutoffDate.month() + '-' + this.invoiceCutoffDate.day();
        
        Account acc;
        
        this.customerTypes = new List<SelectOption>();
        customerTypes.add(new SelectOption('All', 'All'));
        Schema.DescribeFieldResult fieldResult = Account.Type.getDescribe();
        List<Schema.PicklistEntry> plv = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : plv){
            customerTypes.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        this.offset = 0;
        this.dataLimit = 25;
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        this.debtorsToShow = new List<SortedDebtorsList>();
        this.totalDebtors = sortedDebtors.size();
        for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
            if(i == this.totalDebtors) {
                break;
            }
            this.debtorsToShow.add(sortedDebtors[i]);
        }
        this.offset += this.dataLimit;
        
        if(this.dataLimit >= this.totalDebtors) {
            this.nextEnable = false;
            this.prevEnable = false;
        } else {
            this.nextEnable = true;
            this.prevEnable = false;
        }
        
        system.debug('DATE IS: ' + this.invoiceCutoffDate);
    }

    public PageReference SortedDebtors() {
        this.debtorsToShow.clear();
        this.reportDate = this.invoiceCutoffDate.year() + '-' + this.invoiceCutoffDate.month() + '-' + this.invoiceCutoffDate.day();
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        this.totalDebtors = sortedDebtors.size();
        this.offset = 0;
        if(this.dataLimit >= this.totalDebtors) {
            this.nextEnable = false;
            this.prevEnable = false;
        } else {
            this.nextEnable = true;
            this.prevEnable = false;
        }
        for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
            if(i >= this.totalDebtors) {
                break;
            }
            this.debtorsToShow.add(sortedDebtors[i]);
        }
        this.offset += this.dataLimit;
        return null;
    }
    
    public PageReference next() {
        this.debtorsToShow.clear();
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        this.offset = this.offset <= 0 ? this.offset + this.dataLimit : this.offset;
        if(this.offset + this.dataLimit < this.totalDebtors) {
            for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
                if(i == this.totalDebtors) {
                    break;
                }
                this.debtorsToShow.add(sortedDebtors[i]);
            }
            if(this.offset + this.dataLimit < this.totalDebtors) {
            	this.offset += this.dataLimit;
            } else {
                this.offset = this.totalDebtors - 1;
            }
            this.nextEnable = true;
            this.prevEnable = true;
        } else {
            for(Integer i=this.offset;i<this.totalDebtors; i++) {
                if(i == this.totalDebtors) {
                    break;
                }
                this.debtorsToShow.add(sortedDebtors[i]);
            }
            this.nextEnable = false;
            this.prevEnable = true;
            this.offset += this.dataLimit;
        }
        return null;
    }
    
    public PageReference prev() {
        this.debtorsToShow.clear();
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        if(this.offset - this.dataLimit > 0) {
            if(this.offset == (this.totalDebtors - 1)) {
                this.offset -= this.dataLimit * 2;
            } else {
            	this.offset -= this.dataLimit * 2;
            }
            
            for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
                if(i == this.totalDebtors) {
                    break;
                }
                this.debtorsToShow.add(sortedDebtors[i]);
            }
            if(this.offset == 0) {
                this.prevEnable = false;
            } else {
            	this.prevEnable = true;
            }
            this.nextEnable = true;
            this.offset += this.dataLimit;
        } else {
            this.offset = 0;
            for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
                if(i == this.totalDebtors) {
                    break;
                }
                this.debtorsToShow.add(sortedDebtors[i]);
            }
            this.prevEnable = false;
            this.nextEnable = true;
        }
        return null;
    }
    
    public PageReference first() {
        this.debtorsToShow.clear();
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        this.offset = 0;
        for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
            if(i == this.totalDebtors) {
                break;
            }
            this.debtorsToShow.add(sortedDebtors[i]);
        }
        this.prevEnable = false;
        this.nextEnable = true;
        return null;
    }
    
    public PageReference last() {
        this.debtorsToShow.clear();
        sortedDebtors = AccountClass.getSortedDebtorsList(this.includeDisputedInvoices, this.selectedCustomerType, this.includeOpenInvoices, this.invoiceCutoffDate, this.includePendingPayments);
        Integer lastChop = (Integer)Math.mod(this.totalDebtors, this.dataLimit);
        if(lastChop == 0) {
            this.offset = this.totalDebtors - this.dataLimit;
        } else {
            this.offset = this.totalDebtors - lastChop;
        }
        
        for(Integer i=this.offset; i<this.offset + this.dataLimit; i++) {
            if(i == this.totalDebtors) {
                break;
            }
            this.debtorsToShow.add(sortedDebtors[i]);
        }
        
        this.prevEnable = true;
        this.nextEnable = false;
        return null;
    }
}