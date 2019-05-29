public class ManualReconciliationController {
    public Id accountId {get; set;}
    public Map<Id, SortedStatement> selectedCreditItems {get; set;}
    public Map<Id, Boolean> selectedItems {get; set;}
    public Map<Id, SortedStatement> credits {get; set;}
    public Map<Id, SortedStatement> debits {get; set;}
    public Set<Id> creditIds {get; set;}
    public Set<Id> debitIds {get; set;}
    public Decimal totalCreditAmount {get; set;}
    public List<Reconciliation__c> reconciliations {get; set;}
    public Id clickedItem {get; set;}
    public Decimal userInputSplitAmount {get; set;}
    
    public ManualReconciliationController() {
        this.reconciliations = new List<Reconciliation__c>();
        
        this.accountId = System.currentPageReference().getParameters().get('accountid');
        if(this.accountId == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Account ID not Specified'));
            return;
        }
        
        Map<String, String> params = system.currentPageReference().getParameters();
        Integer creditItemParamCount = 1;
        creditIds = new Set<Id>();
        debitIds = new Set<Id>();
        
        while(params.containsKey('credit'+creditItemParamCount)) {
            this.creditIds.add(params.remove('credit'+creditItemParamCount));
            creditItemParamCount++;
        }
        this.selectedItems = new Map<Id, Boolean>();
        this.selectedCreditItems = new Map<Id, SortedStatement>();
        this.totalCreditAmount = 0.00;
        this.initCreditItems();
        this.initDebitItems();
        
        if(creditIds.size() > 0) {
            for(Id key: credits.keySet()) {
                if(creditIds.contains(credits.get(key).objectId)) {
                    this.selectedCreditItems.put(key, credits.get(key));
                    this.totalCreditAmount += credits.get(key).credit_amount;
                }
            }
        }
    }
    
    public Boolean getCreditsIsEmpty() {
        return this.credits.isEmpty();
    }
    
    public Boolean getDebitsIsEmpty() {
        return this.debits.isEmpty();
    }
    
    public void initCreditItems() {
        if(this.accountId == null) {
            return;
        }
        this.credits = new Map<Id, SortedStatement>();
        
        List<SortedStatement> tmpCredits = AccountClass.getReconciliationItems(this.accountId, 'credit');
        for(SortedStatement stmt: tmpCredits) {
            this.selectedItems.put(stmt.objectId, false);
            this.credits.put(stmt.objectId, stmt);
        }
    }
    
    public void initDebitItems() {
        if(this.accountId == null) {
            return;
        }
        this.debits = new Map<Id, SortedStatement>();
        
        List<SortedStatement> tmpDebits = AccountClass.getReconciliationItems(this.accountId, 'debit');
        for(SortedStatement stmt: tmpDebits) {
            this.selectedItems.put(stmt.objectId, false);
            this.debits.put(stmt.objectId, stmt);
        }
    }
    
    public PageReference selectCredit() {
        for(Id key: this.selectedItems.keySet()) {
            if(selectedItems.get(key)) {
                this.creditIds.add(key);
            }
        }
        
        if(this.creditIds.isEmpty()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select atleast one item'));
            return null;
        } else {
            PageReference pf = new PageReference('/apex/ManualReconcileDebitItem');
            pf.getParameters().put('accountid',this.accountId);
            Integer creditItemCount = 1;
            for(Id itemId: this.creditIds) {
                pf.getParameters().put('credit'+creditItemCount,itemId);
                creditItemCount++;
            }
            pf.setRedirect(true);
            return pf;
        }
    }
    
    public PageReference selectDebit() {
        List<SortedStatement> selectedDebits = new List<SortedStatement>();
        List<SortedStatement> selectedCredits = new List<SortedStatement>();
        
        for(Id key: this.selectedItems.keySet()) {
            if(selectedItems.get(key)) {
                this.debitIds.add(key);
                selectedDebits.add(this.debits.get(key));
            }
        }
        
        for(Id credit: this.creditIds) {
            selectedCredits.add(this.credits.get(credit));
        }
        
        
        if(this.debitIds.isEmpty()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select atleast one item'));
            return null;
        } else {
            //for(SortedStatement stmt: selectedDebits) {
            for(Integer i=0; i<selectedDebits.size(); i++) {
                if(selectedDebits[i].debit_amount < selectedDebits[i].split_amount) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Debit split amount cannot be greater than total amount'));
                    return null;
                } else {
                    if(selectedDebits[i].debit_amount > selectedDebits[i].split_amount) {
                        List<Decimal> splitList = new List<Decimal>();
                        splitList.add(selectedDebits[i].split_amount);
                        splitList.add(selectedDebits[i].debit_amount - selectedDebits[i].split_amount);
                        Ledger_Item__c splitItem = [SELECT Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c, RecordTypeId FROM Ledger_Item__c WHERE Id = :selectedDebits[i].objectId];
                        this.creditIds.add(LedgerItem.splitItem(splitItem, splitList));
                    }
                }
            }

            for(Integer i=0; i < selectedCredits.size(); i++) {
                if(selectedCredits[i].credit_amount < selectedCredits[i].split_amount) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Credit split amount cannot be greater than total amount'));
                    return null;
                } else {
                    if(selectedCredits[i].credit_amount > selectedCredits[i].split_amount) {
                        List<Decimal> splitList = new List<Decimal>();
                        splitList.add(selectedCredits[i].split_amount);
                        splitList.add(selectedCredits[i].credit_amount - selectedCredits[i].split_amount);
                        Ledger_Item__c splitItem = [SELECT Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciled__c, Reconciliation__c, RecordTypeId FROM Ledger_Item__c WHERE Id = :selectedCredits[i].objectId];
                        this.debitIds.add(LedgerItem.splitItem(splitItem, splitList));
                    }
                }
            }
            
            List<Ledger_Item__c> creditLedgers = new List<Ledger_Item__c>();
            List<Ledger_Item__c> debitLedgers = new List<Ledger_Item__c>();
            creditLedgers.addAll([SELECT Id FROM Ledger_Item__c WHERE Id IN :this.creditIds AND Reconciliation__c = null AND ((Payment__c != null AND Payment__r.Draft__c = false AND Payment__r.Confirmed__c = true AND Payment__r.Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false))]);
            debitLedgers.addAll([SELECT Id FROM Ledger_Item__c WHERE Id IN :this.debitIds AND Reconciliation__c = null AND ((Refund__c != null AND Refund__r.Draft__c = false AND Refund__r.Confirmed__c = true AND Refund__r.Failed__c = false AND Refund__r.Payment_Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.Dispute__c = false))]);
            
            if(creditLedgers.size() != creditIds.size()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Credit Item Not found.Probably by someone else reconciled while you were still thinking...'));
                return null;
            }
            
            if(debitLedgers.size() != debitIds.size()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Debit Item Not found.Probably by someone else reconciled while you were still thinking...'));
                return null;
            }
            
            List<Reconciliation__c> tmpRecon = LedgerItem.matchLedgerItems(new Set<Id>{this.accountId}, this.creditIds, this.debitIds);
            if(tmpRecon.isEmpty()) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Failed to Reconcile'));
                return null;
            }
            
            List<Id> reconcileIds = new List<Id>();
            for(Reconciliation__c reconciliation: tmpRecon) {
                reconcileIds.add(reconciliation.Id);
            }
            
            this.reconciliations.addAll([SELECT Id, Name, Credits__c, Debits__c, Balance__c, Reconciled__c FROM Reconciliation__c WHERE Id IN :reconcileIds]);
            
            return null;
            
        }
    }
    
    public void toggleSelection() {
        if(this.selectedItems.get(this.clickedItem)) {
            this.selectedItems.put(this.clickedItem, false);
        } else {
            this.selectedItems.put(this.clickedItem, true);
        }
    }
    
    public void recalculateRemainingAmount() {
        if(this.userInputSplitAmount < debits.get(clickedItem).total_amount) {
            debits.get(clickedItem).outstanding_amount = debits.get(clickedItem).total_amount - (debits.get(clickedItem).amount_allocated + this.userInputSplitAmount);
        }
    }
    
    public PageReference cancel() {
        PageReference pf = new PageReference('/apex/AccountStatement');
        pf.getParameters().put('accountid',this.accountId);
        pf.setRedirect(true);
        return pf;
    }
}