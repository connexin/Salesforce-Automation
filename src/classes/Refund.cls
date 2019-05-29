public class Refund {
	
	public static void calculateAmountAllocated(Set<Id> refundIds) {
		//Fiscal Document Id => Fiscal Document
		Map<Id, Refund__c> refundMap = new Map<Id, Refund__c>();
		refundMap.putAll([SELECT Id, Amount_Allocated__c FROM Refund__c WHERE Id IN :refundIds]);
		//Fiscal Document Id => Amount ALlocated
		Map<Id, Decimal> refundAmountAllocated = new Map<Id, Decimal>();
        
		//Populate the Fiscal Document Id => Amount Allocated Mapping
		for (Id refundId : refundMap.keySet()) {
			refundAmountAllocated.put(refundId, 0.00);
		}
		
		//Calculate the Correct Amount's Allocated
		for (Ledger_Item__c item : [SELECT Id, Amount__c, Refund__c FROM Ledger_Item__c WHERE Reconciled__c = true AND Refund__c IN :refundIds]) {
            if(refundAmountAllocated.containsKey(item.Refund__c)) {
                refundAmountAllocated.put(item.Refund__c, refundAmountAllocated.get(item.Refund__c) + item.Amount__c);
            } else {
                refundAmountAllocated.put(item.Refund__c, item.Amount__c);
            }
        }
		
		//Check the Fiscal Document Amount Allocated Matches the Amount Allocated just Computed
		/*List<Refund__c> refundsToUpdate = new List<Refund__c>();
		for (Refund__c refund : refundMap.values()) {
			if (refund.Amount_Allocated__c != refundAmountAllocated.get(refund.Id)) {
				refund.Amount_Allocated__c = refundAmountAllocated.get(refund.Id);
				refundsToUpdate.add(refund);
			}
		}*/
        
        List<Refund__c> refundsToUpdate = new List<Refund__c>();
		for (Refund__c refund : refundMap.values()) {
			if (refund.Amount_Allocated__c != refundAmountAllocated.get(refund.Id)) {
				if (refundAmountAllocated.get(refund.Id) == null) {
					refund.Amount_Allocated__c = 0.00;
				} else {
					refund.Amount_Allocated__c = refundAmountAllocated.get(refund.Id);
				}
				refundsToUpdate.add(refund);
			}
		}
		
		if (!refundsToUpdate.isEmpty()) {
			update refundsToUpdate;
		}
	}
}