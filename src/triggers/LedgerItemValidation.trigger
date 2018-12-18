trigger LedgerItemValidation on Ledger_Item__c (before insert, before update) {
    //Parent Id -> Sum Amount of Ledger Items, Amount of Parent
    Map<Id, List<Decimal>> parentFiscalDocuments = new Map<Id, List<Decimal>>();
    Map<Id, List<Decimal>> parentPayments = new Map<Id, List<Decimal>>();
    Map<Id, List<Decimal>> parentRefunds = new Map<Id, List<Decimal>>();
    
    //Sum Amount of Ledger Items, Amount of Parent
    List<Decimal> tmpList;
    
    Map<Id, String> recordTypeMap = new Map<Id, String>();
    for (RecordType recordType : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType IN :new List<String>{'Ledger_Item__c', 'Fiscal_Document__c'}]) {
        recordTypeMap.put(recordType.Id, recordType.DeveloperName);
    }
    
    Set<Id> ledgerItemIds = new Set<Id>();
    if (trigger.isUpdate) {
        ledgerItemIds = trigger.newMap.keySet();
    }
    
    Set<Id> fiscalDocumentIds = new Set<Id>();
    Set<Id> paymentIds = new Set<Id>();
    Set<Id> refundIds = new Set<Id>();
    Set<Id> reconciliationIds = new Set<Id>();
    for (Ledger_Item__c item : trigger.new) {
        if (item.Fiscal_Document__c != null) {
            fiscalDocumentIds.add(item.Fiscal_Document__c);
        }
        if (item.Payment__c != null) {
            paymentIds.add(item.Payment__c);
        }
        if (item.Refund__c != null) {
            refundIds.add(item.Refund__c);
        }
        if (item.Reconciliation__c != null) {
            reconciliationIds.add(item.Reconciliation__c);
        }
    }
    
    Map<Id, Fiscal_Document__c> fiscalDocumentMap = new Map<Id, Fiscal_Document__c>();
    Map<Id, Refund__c> refundMap = new Map<Id, Refund__c>();
    Map<Id, Reconciliation__c> reconciliationMap = new Map<Id, Reconciliation__c>();
    fiscalDocumentMap.putAll([SELECT Id, Subtotal__c, Account__c, RecordTypeId, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Fiscal_Document__c WHERE Id IN :fiscalDocumentIds]);
    refundMap.putAll([SELECT Id, Amount__c, Payment__c, Payment__r.Account__c, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Refund__c WHERE Id IN :refundIds]);
    reconciliationMap.putAll([SELECT Id, Account__c FROM Reconciliation__c WHERE Id IN :reconciliationIds]);
    
    for (Refund__c refund : refundMap.values()) {
        paymentIds.add(refund.Payment__c);
    }
    Map<Id, Payment__c> paymentMap = new Map<Id, Payment__c>();
    paymentMap.putAll([SELECT Id, Amount__c, Account__c, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Payment__c WHERE Id IN :paymentIds]);
    
    Id accountId; //Id of Account of Parent
    
    for (Ledger_Item__c item : trigger.new) {
        if (item.Draft__c == true) {
            continue;
        }
        
        if (
            (recordTypeMap.get(item.RecordTypeId) == 'credit' && item.Payment__c == null && 
                (item.Fiscal_Document__c == null || recordTypeMap.get(fiscalDocumentMap.get(item.Fiscal_Document__c).RecordTypeId) != 'credit_note'))
         || (recordTypeMap.get(item.RecordTypeId) == 'debit' && item.Refund__c == null && 
                (item.Fiscal_Document__c == null || recordTypeMap.get(fiscalDocumentMap.get(item.Fiscal_Document__c).RecordTypeId) != 'sales_invoice'))) {
            item.addError('Ledger Item Parent Selection is Invalid');
        }
        
        if (item.Fiscal_Document__c != null) {
            if (parentFiscalDocuments.containsKey(item.Fiscal_Document__c)) {
                tmpList = parentFiscalDocuments.get(item.Fiscal_Document__c);
                tmpList.set(0, tmpList.get(0) + item.Amount__c);
                parentFiscalDocuments.put(item.Fiscal_Document__c, tmpList);
            } else {
                parentFiscalDocuments.put(item.Fiscal_Document__c, new List<Decimal>{item.Amount__c, 0});
            }
            accountId = fiscalDocumentMap.get(item.Fiscal_Document__c).Account__c;
        }
        if (item.Payment__c != null) {
            if (parentPayments.containsKey(item.Payment__c)) {
                tmpList = parentPayments.get(item.Payment__c);
                tmpList.set(0, tmpList.get(0) + item.Amount__c);
                parentPayments.put(item.Payment__c, tmpList);
            } else {
                parentPayments.put(item.Payment__c, new List<Decimal>{item.Amount__c, 0});
            }
            
            accountId = paymentMap.get(item.Payment__c).Account__c;
        }
        if (item.Refund__c != null) {
            if (parentRefunds.containsKey(item.Refund__c)) {
                tmpList = parentRefunds.get(item.Refund__c);
                tmpList.set(0, tmpList.get(0) + item.Amount__c);
                parentRefunds.put(item.Refund__c, tmpList);
            } else {
                parentRefunds.put(item.Refund__c, new List<Decimal>{item.Amount__c, 0});
            }
            
            //accountId = refundMap.get(refundMap.get(item.Refund__c).Payment__c).Account__c;
            accountId = refundMap.get(item.Refund__c).Payment__r.Account__c;
        }
        
        //Check the reconciliation Account Id matched the Parent Account Id
        if (item.Reconciliation__c != null) {
            if (reconciliationMap.get(item.Reconciliation__c).Account__c != accountId) {
                item.Reconciliation__c.addError('Ledger Item Parent Account must match Reconciliation Account');
            }
        }
    }
    
    //for (Fiscal_Document__c fiscalDocument: [SELECT Id, Subtotal__c, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Fiscal_Document__c WHERE Id IN :parentFiscalDocuments.keySet()]) {
    for (Fiscal_Document__c fiscalDocument : fiscalDocumentMap.values()) {
        if (!parentFiscalDocuments.containsKey(fiscalDocument.Id)) {
            continue;
        }
        tmpList = parentFiscalDocuments.get(fiscalDocument.Id);
        for(Ledger_Item__c item : fiscalDocument.Ledger_Items__r) {
            tmpList.set(0, tmpList.get(0) + item.Amount__c);
        }
        tmpList.set(1, fiscalDocument.Subtotal__c);
        parentFiscalDocuments.put(fiscalDocument.Id, tmpList);
    }
    
    //for (Payment__c payment: [SELECT Id, Amount__c, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Payment__c WHERE Id IN :parentPayments.keySet()]) {
    for (Payment__c payment : paymentMap.values()) {
        if (!parentPayments.containsKey(payment.Id)) {
            continue;
        }
        tmpList = parentPayments.get(payment.Id);
        for(Ledger_Item__c item : payment.Ledger_Items__r) {
            tmpList.set(0, tmpList.get(0) + item.Amount__c);
        }
        tmpList.set(1, payment.Amount__c);
        parentPayments.put(payment.Id, tmpList);
    }
    
    //for (Refund__c refund: [SELECT Id, Amount__c, (SELECT Amount__c FROM Ledger_Items__r WHERE Id NOT IN :ledgerItemIds) FROM Refund__c WHERE Id IN :parentRefunds.keySet()]) {
    for (Refund__c refund : refundMap.values()) {
        if (!parentRefunds.containsKey(refund.Id)) {
            continue;
        }
        tmpList = parentRefunds.get(refund.Id);
        for(Ledger_Item__c item : refund.Ledger_Items__r) {
            tmpList.set(0, tmpList.get(0) + item.Amount__c);
        }
        tmpList.set(1, refund.Amount__c);
        parentRefunds.put(refund.Id, tmpList);
    }
    
    for (Ledger_Item__c item : trigger.new) {
        if (item.Draft__c == true) {
            continue;
        }
        
        if (item.Fiscal_Document__c != null && parentFiscalDocuments.get(item.Fiscal_Document__c).get(0) != parentFiscalDocuments.get(item.Fiscal_Document__c).get(1)) {
            item.addError('Sum of Ledger Item Amounts does not equal Fiscal Documents Subtotal');
        }
        
        if (item.Payment__c != null && parentPayments.get(item.Payment__c).get(0) != parentPayments.get(item.Payment__c).get(1)) {
            item.addError('Sum of Ledger Item Amounts does not equal Payment Amount ' + item.Payment__c + ' - ' + parentPayments.get(item.Payment__c).get(0) + ' - ' + parentPayments.get(item.Payment__c).get(1));
        }
        if (item.Refund__c != null && parentRefunds.get(item.Refund__c).get(0) != parentRefunds.get(item.Refund__c).get(1)) {
            item.addError('Sum of Ledger Item Amounts does not equal Refund Amount');
        }
    }
    
    
    
}