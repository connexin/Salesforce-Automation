trigger LedgerItemUnsplit on Ledger_Item__c (after update) {
    Map<Id, Ledger_Item__c> newItems = new Map<Id, Ledger_Item__c>(trigger.newMap);
    Map<Id, Ledger_Item__c> oldItems = new Map<Id, Ledger_Item__c>(trigger.oldMap);
    
    Set<Id> fiscalDocuments = new Set<Id>();
    Set<Id> payments = new Set<Id>();
    Set<Id> refunds = new Set<Id>();
    Set<Id> reconciliationIds = new Set<Id>();

    for(Id ledgerId: newItems.keySet()) {
        if(newItems.get(ledgerId).Reconciliation__c == null && oldItems.get(ledgerid).Reconciliation__c != null && newItems.get(ledgerId).Draft__c == false) {
            reconciliationIds.add(oldItems.get(ledgerid).Reconciliation__c);
            if(newItems.get(ledgerId).Fiscal_Document__c != null) {
                fiscalDocuments.add(newItems.get(ledgerId).Fiscal_Document__c);
            }
            
            if(newItems.get(ledgerId).Payment__c != null) {
                payments.add(newItems.get(ledgerId).Payment__c);
            }
            
            if(newItems.get(ledgerId).Refund__c != null) {
                refunds.add(newItems.get(ledgerId).Refund__c);
            }
        }
    }

    if(fiscalDocuments.size() > 0) {
        LedgerItem.unsplitItems([SELECT Id, Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciliation__c FROM Ledger_Item__c WHERE Fiscal_Document__c IN :fiscalDocuments AND Reconciled__c = false AND Reconciliation__c = null]);
    }
    
    if(payments.size() > 0) {
        LedgerItem.unsplitItems([SELECT Id, Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciliation__c FROM Ledger_Item__c WHERE Payment__c IN :payments AND Reconciled__c = false AND Reconciliation__c = null]);
    }
    
    if(refunds.size() > 0) {
        LedgerItem.unsplitItems([SELECT Id, Amount__c, Draft__c, Fiscal_Document__c, Payment__c, Refund__c, Reconciliation__c FROM Ledger_Item__c WHERE Refund__c IN :refunds AND Reconciled__c = false AND Reconciliation__c = null]);    
    }
}