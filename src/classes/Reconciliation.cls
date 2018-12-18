public class Reconciliation {
    
    /*public static Map<Id, Map<String, Decimal>> calculateBalance(Set<Id> reconciliationIds) {
        //Create Map for Return Value
        Map<Id, Map<String, Decimal>> balance = new Map<Id, Map<String, Decimal>>();
        for (Id reconciliationId : reconciliationIds) {
            //Check the IDs are Valid
            if (reconciliationId.getSObjectType().getDescribe().getName() != 'Reconciliation__c') {
                //throw new Exception('ID is not a valid Reconciliation__c ID');
            }
            //Create a balance for the Reconciliation
            balance.put(reconciliationId, new Map<String, Decimal>{'credits' => 0, 'debits' => 0});
        }
        
        //Create Record Type Mapp
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        for (RecordType record : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Ledger_Item__c']) {
            recordTypeMap.put(record.Id, record.DeveloperName);
        }
        
        Map<String, Decimal> curBalance;
        //Get the Sumation of the Fiscal Documents and Add/Subtract them from the Reconciliation Balance
        for (AggregateResult result : [SELECT Reconciliation__c, RecordTypeId, SUM(Amount__c) FROM Ledger_Item__c WHERE Reconciliation__c IN :reconciliationIds GROUP BY Reconciliation__c, RecordTypeId]) {
            curBalance = balance.get((Id)result.get('Reconciliation__c'));
            if (recordTypeMap.get((Id)result.get('RecordTypeId')) == 'debit') {
                curBalance.put('debits', curBalance.get('debits') + (Decimal)result.get('expr0'));
            } else if (recordTypeMap.get((Id)result.get('RecordTypeId')) == 'credit') {
                curBalance.put('credits', curBalance.get('credits') + (Decimal)result.get('expr0'));
            }
            balance.put((Id)result.get('Reconciliation__c'), curBalance);
        }
        
        for (Id curId : balance.keySet()) {
            balance.get(curId).put('balance', balance.get(curId).get('credits') - balance.get(curId).get('debits'));
        }
        
        return balance;
    }
    
    public static void reconcileReconciliation(Set<Id> reconciliationIds) {
        for (Id reconciliationId : reconciliationIds) {
            //Check the IDs are Valid
            if (reconciliationId.getSObjectType().getDescribe().getName() != 'Reconciliation__c') {
                //throw new Exception('ID is not a valid Reconciliation__c ID');
            }
        }
        
        List<Reconciliation__c> reconciliationsToUpdate = new List<Reconciliation__c>();
        Map<Id, Map<String, Decimal>> balance = Reconciliation.calculateBalance(reconciliationIds);
        for (Reconciliation__c reconciliation : [SELECT Id, Reconciled__c FROM Reconciliation__c WHERE Id IN :reconciliationIds]) {
            //if (balance.get(reconciliation.Id).get('balance') == 0) {
            if (balance.get(reconciliation.Id).get('balance') == 0 && balance.get(reconciliation.Id).get('credits') > 0 && balance.get(reconciliation.Id).get('debits') > 0) {
                reconciliation.Reconciled__c = true;
            } else {
                reconciliation.Reconciled__c = false;
            }
            reconciliation.Credits__c = balance.get(reconciliation.Id).get('credits');
            reconciliation.Debits__c = balance.get(reconciliation.Id).get('debits');
            reconciliationsToUpdate.add(reconciliation);
        }
        
        update reconciliationsToUpdate;
    }*/
    
    public static void unreconcileReconciliations(Set<Id> reconciliationIds) { //unreconcile and delete
        if(reconciliationIds.isEmpty()) {
            return;
        }
        
        List<Reconciliation__c> reconciliations = new List<Reconciliation__c>([SELECT Id, Account__c, Reconciled__c, (SELECT Id, Amount__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciliation__c FROM Ledger_Items__r) FROM Reconciliation__c WHERE Id IN :reconciliationIds]);
        List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>();
        Set<Id> accountIds = new Set<Id>();
        
        for(Reconciliation__c reconciliation: reconciliations) {
            reconciliation.Reconciled__c = false;
            accountIds.add(reconciliation.Account__c);
            ledgerItems.addAll(reconciliation.Ledger_Items__r);
        }
        update reconciliations;
        
        List<Id> fiscalDocuments = new List<Id>();
        List<Id> payments = new List<Id>();
        List<Id> refunds = new List<Id>();
        
        if(ledgerItems.size() > 0) {
            for(Ledger_Item__c item: ledgerItems) {
                if(item.Fiscal_Document__c != null) {
                    fiscalDocuments.add(item.Fiscal_Document__c);
                }
                
                if(item.Payment__c != null) {
                    payments.add(item.Payment__c);
                }
                
                if(item.Refund__c != null) {
                    refunds.add(item.Refund__c);
                }
            }
            
            if(fiscalDocuments.size() > 0) {
                LedgerItem.removeReconciliation(fiscalDocuments);
            }
            
            if(payments.size() > 0) {
                LedgerItem.removeReconciliation(payments);
            }
            
            if(refunds.size() > 0) {
                LedgerItem.removeReconciliation(refunds);
            }
        }
        delete reconciliations;
        
        if(!accountIds.isEmpty()) {
            //LedgerItem.matchLedgerItems(accountIds, new Set<Id>(), new Set<Id>()); //fix the looping error before enabling this line
        }
    }
}