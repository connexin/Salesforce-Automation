public class Payment {
	
	public static void calculateAmountAllocated(Set<Id> paymentIds) {
		//Fiscal Document Id => Fiscal Document
		Map<Id, Payment__c> paymentMap = new Map<Id, Payment__c>();
		paymentMap.putAll([SELECT Id, Amount_Allocated__c FROM Payment__c WHERE Id IN :paymentIds]);
		//Fiscal Document Id => Amount ALlocated
		Map<Id, Decimal> paymentAmountAllocated = new Map<Id, Decimal>();
        
        for (Id paymentId : paymentMap.keySet()) {
			paymentAmountAllocated.put(paymentId, 0.00);
		}
		
		//Calculate the Correct Amount's Allocated
		for (Ledger_Item__c item : [SELECT Id, Amount__c, Payment__c, Reconciled__c FROM Ledger_Item__c WHERE Reconciled__c = true AND Payment__c IN :paymentIds]) {
            paymentAmountAllocated.put(item.Payment__c, paymentAmountAllocated.get(item.Payment__c) + item.Amount__c);
		}
		
		//Check the Fiscal Document Amount Allocated Matches the Amount Allocated just Computed
		List<Payment__c> paymentsToUpdate = new List<Payment__c>();
		for (Payment__c payment : paymentMap.values()) {
			if (payment.Amount_Allocated__c != paymentAmountAllocated.get(payment.Id)) {
				payment.Amount_Allocated__c = paymentAmountAllocated.get(payment.Id);
				paymentsToUpdate.add(payment);
			}
		}
		
		if (!paymentsToUpdate.isEmpty()) {
			update paymentsToUpdate;
		}
	}
    
}