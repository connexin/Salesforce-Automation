public class FiscalDocument {
	
	public static void calculateAmountAllocated(Set<Id> fiscalDocumentIds) {
		//Fiscal Document Id => Fiscal Document
		Map<Id, Fiscal_Document__c> fiscalDocumentMap = new Map<Id, Fiscal_Document__c>();
		fiscalDocumentMap.putAll([SELECT Id, Amount_Allocated__c FROM Fiscal_Document__c WHERE Id IN :fiscalDocumentIds]);
		//Fiscal Document Id => Amount ALlocated
		Map<Id, Decimal> fiscalDocumentAmountAllocated = new Map<Id, Decimal>();
		
        for (Id fdId : fiscalDocumentMap.keySet()) {
			fiscalDocumentAmountAllocated.put(fdId, 0.00);
		}
        
		//Calculate the Correct Amount's Allocated
		for (Ledger_Item__c item : [SELECT Id, Amount__c, Fiscal_Document__c FROM Ledger_Item__c WHERE Reconciled__c = true AND Fiscal_Document__c IN :fiscalDocumentIds]) {
			fiscalDocumentAmountAllocated.put(item.Fiscal_Document__c, fiscalDocumentAmountAllocated.get(item.Fiscal_Document__c) + item.Amount__c);
		}
		
		//Check the Fiscal Document Amount Allocated Matches the Amount Allocated just Computed
		List<Fiscal_Document__c> fiscalDocumentsToUpdate = new List<Fiscal_Document__c>();
		for (Fiscal_Document__c fiscalDocument : fiscalDocumentMap.values()) {
			if (fiscalDocument.Amount_Allocated__c != fiscalDocumentAmountAllocated.get(fiscalDocument.Id)) {
				fiscalDocument.Amount_Allocated__c = fiscalDocumentAmountAllocated.get(fiscalDocument.Id);
				fiscalDocumentsToUpdate.add(fiscalDocument);
			}
		}
		
		if (!fiscalDocumentsToUpdate.isEmpty()) {
			update fiscalDocumentsToUpdate;
		}
		
	}
	
}