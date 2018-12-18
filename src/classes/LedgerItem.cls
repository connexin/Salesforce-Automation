public class LedgerItem {
    public static Id splitItem(Ledger_Item__c item, List<Decimal> splits) {
    	Id newLedgerId;
        Id reconciliationId;
    	if (item.Draft__c) {
    		return null;
    	}
    	
    	if (item.RecordTypeId == null) {
    		return null;
    	}
        
        if(item.Reconciliation__c != null) {
            reconciliationId  = item.Reconciliation__c;
        }
        
    	Decimal cntCheck = 0;
    	for (Decimal cnt : splits) {
    		cntCheck += cnt;
    	}
        
    	if (item.Amount__c != cntCheck) {
    		return null;
    	}
    	
    	List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>();
    	Ledger_Item__c curItem;
        
    	for (Integer i = 1; i < splits.size(); i++) {
    		curItem = item.clone(false, true);
    		curItem.Amount__c = splits.get(1);
            curItem.Reconciliation__c = null;
    		curItem.Draft__c = true;
    		ledgerItems.add(curItem);
    	}

    	insert ledgerItems;
        newLedgerId = ledgerItems[0].Id;
    	
    	for (Integer i = 0; i < ledgerItems.size(); i++) {
    		curItem = ledgerItems.get(i);
    		curItem.Draft__c = false;
            curItem.Reconciliation__c = reconciliationId;
    		ledgerItems.set(i, curItem);
    	}

        item.Amount__c = splits.get(0);
        ledgerItems.add(item);
        
        update ledgerItems;
        
        return newLedgerId;
    }
    
    public static void unsplitItems(List<Ledger_Item__c> ledgerItems) {
        if(ledgerItems.size() <= 1) {
            return;
        }
        
        Decimal unreconciledLedgerItemAmount = 0.00;
        Map<Id, List<Ledger_Item__c>> multiParentLedgers = new Map<Id, List<Ledger_Item__c>>();
        
        for(Ledger_Item__c item: ledgerItems) {
            Id objId = null;
            if(item.Fiscal_Document__c != null) {
                objId = item.Fiscal_Document__c;
            } else if(item.Payment__c != null) {
                objId = item.Payment__c;
            } else if(item.Refund__c != null) {
                objId = item.Refund__c;
            }
            
            if(multiParentLedgers.containsKey(objId)) {
                List<Ledger_Item__c> tmpList = new List<Ledger_Item__c>();
                tmpList = multiParentLedgers.get(objId);
                tmpList.add(item);
                multiParentLedgers.put(objId, tmpList);
            } else {
                List<Ledger_Item__c> tmpList = new List<Ledger_Item__c>();
                tmpList.add(item);
                multiParentLedgers.put(objId, tmpList);
            }
        }

        if(multiParentLedgers.size() > 0) { 

            for(Id objId: multiParentLedgers.keySet()) {
                unreconciledLedgerItemAmount = 0.00;
                ledgerItems = multiParentLedgers.get(objId);
                if(ledgerItems.size() <= 1){
                    continue;
                }
                for(Ledger_Item__c ledgerItem: ledgerItems) {
                    unreconciledLedgerItemAmount += ledgerItem.Amount__c;
                    if(ledgerItem.Reconciliation__c != null) {
                        ledgerItem.Reconciliation__c = null;
                    }
                    ledgerItem.Amount__c = 0.00;
                    ledgerItem.Draft__c = true;
                    update ledgerItem;
                }
                Ledger_Item__c firstItem = ledgerItems[0].clone(true, false, false, true);
                ledgerItems.remove(0);
                if(ledgerItems.size() > 0) {
                    delete ledgerItems;
                }
                firstItem.Amount__c = unreconciledLedgerItemAmount;
                firstItem.Draft__c = false;
                update firstItem;
        	}
        } 
    }
    
    public static List<Reconciliation__c> matchLedgerItems(Set<Id> accountIds, Set<Id> creditIds, Set<Id> debitIds) {
        Set<List<Ledger_Item__c>> reconcileList = new Set<List<Ledger_Item__c>>();
        
        List<Ledger_Item__c> splitLedgers = new List<Ledger_Item__c>();
        List<Ledger_Item__c> newLedgers = new List<Ledger_Item__c>();
        
        List<Ledger_Item__c> creditLedgers = new List<Ledger_Item__c>();
        List<Ledger_Item__c> DebitLedgers = new List<Ledger_Item__c>();
        
        Map<Id, Map<String, List<Ledger_Item__c>>> accountMap = new Map<Id, Map<String, List<Ledger_Item__c>>>(); 
        //accountMap can be defined as given below
        // Map<accountId, Map<'credit', List<payments + creditnotes>>>
        // Map<accountId, Map<'debit', List<invoices + refunds>>>
        
        Map<Id, Map<String, Ledger_Item__c>> paymentReferences = new Map<Id, Map<String, Ledger_Item__c>>();
        Map<Id, Map<String, Ledger_Item__c>> invoiceReferences = new Map<Id, Map<String, Ledger_Item__c>>();
        //references can be defined as below
        //Map<accountId, Map<'payment_ref', Payment Ledger Item>>
        //Map<accountId, Map<'invoice_ref', Invoice Ledger Item>>
        
        Map<Id, Decimal> totalCredit = new Map<Id, Decimal>(); //Total credit map for all accounts in the request
        Map<Id, Decimal> totalDebit = new Map<Id, Decimal>(); //Total debit map for all accounts in the request
        
        //Get all payments and creditnotes into credits list of ledgers for all accounts
        List<Ledger_Item__c> credits = new List<Ledger_Item__c>();
        if(creditIds.isEmpty()) {
        	credits = [SELECT Id, Amount__c, RecordType.DeveloperName, Reconciled__c, Reconciliation__c, Draft__c, Fiscal_Document__r.Description__c, Fiscal_Document__r.Account__c, Payment__r.Account__c, Payment__r.Description__c, Payment__r.Reference__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Payment__c != null AND Payment__r.Confirmed__c = true AND Payment__r.Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'credit_note')) AND (Payment__r.Account__c IN :accountIds OR Fiscal_Document__r.Account__c IN :accountIds) ORDER BY Date__c ASC];
        } else {
            credits = [SELECT Id, Amount__c, RecordType.DeveloperName, Reconciled__c, Reconciliation__c, Draft__c, Fiscal_Document__r.Description__c, Fiscal_Document__r.Account__c, Payment__r.Account__c, Payment__r.Description__c, Payment__r.Reference__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Payment__c != null AND Payment__r.Confirmed__c = true AND Payment__r.Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'credit_note')) AND (Payment__r.Account__c IN :accountIds OR Fiscal_Document__r.Account__c IN :accountIds) AND Id IN :creditIds ORDER BY Date__c ASC];
        }
        
        //Get all invoices and refunds into debits list of ledgers for all accounts
        List<Ledger_Item__c> debits = new List<Ledger_Item__c>();
        if(debitIds.isEmpty()) {
        	debits = [SELECT Id, Amount__c, RecordType.DeveloperName, Reconciled__c, Reconciliation__c, Draft__c, Fiscal_Document__r.Description__c, Fiscal_Document__r.Reference__c, Fiscal_Document__r.Account__c, Refund__r.Payment__r.Account__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Refund__c != null AND Refund__r.Draft__c = false AND Refund__r.Confirmed__c = true AND Refund__r.Failed__c = false AND Refund__r.Payment_Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice' AND Fiscal_Document__r.Dispute__c = false)) AND (Refund__r.Payment__r.Account__c IN :accountIds OR Fiscal_Document__r.Account__c IN :accountIds) ORDER BY Date__c ASC];
        } else {
            debits = [SELECT Id, Amount__c, RecordType.DeveloperName, Reconciled__c, Reconciliation__c, Draft__c, Fiscal_Document__r.Description__c, Fiscal_Document__r.Reference__c, Fiscal_Document__r.Account__c, Refund__r.Payment__r.Account__c, Fiscal_Document__c, Payment__c, Refund__c, Fiscal_Document__r.RecordType.DeveloperName FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Refund__c != null AND Refund__r.Draft__c = false AND Refund__r.Confirmed__c = true AND Refund__r.Failed__c = false AND Refund__r.Payment_Failed__c = false) OR (Fiscal_Document__c != null AND Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice' AND Fiscal_Document__r.Dispute__c = false)) AND (Refund__r.Payment__r.Account__c IN :accountIds OR Fiscal_Document__r.Account__c IN :accountIds) AND Id IN :debitIds ORDER BY Date__c ASC];
        }
        
        
        for(Integer i=0;i<credits.size();i++) { 
            Id accountId = credits[i].Fiscal_Document__r.Account__c != null ? credits[i].Fiscal_Document__r.Account__c : credits[i].Payment__r.Account__c;
            
            //Calculate total credit first
            if(totalCredit.containsKey(accountId)) {
                Decimal tmpCredit = totalCredit.get(accountId);
                tmpCredit += credits[i].Amount__c;
                totalCredit.put(accountId, tmpCredit);
            } else {
                totalCredit.put(accountId, credits[i].Amount__c);
            }
            
            //extract any payment references
            if(credits[i].Payment__c != null && credits[i].Payment__r.Description__c != null) {
                if(paymentReferences.containsKey(accountId)) {
                    Map<String, Ledger_Item__c> tmpMap = new Map<String, Ledger_Item__c>(paymentReferences.get(accountId));
                    if(!tmpMap.containsKey(credits[i].Payment__r.Description__c)) {
                        tmpMap.put(credits[i].Payment__r.Description__c, credits[i]);
                        paymentReferences.put(accountId, tmpMap);
                    }
                } else {
                    Map<String, Ledger_Item__c> tmpMap = new Map<String, Ledger_Item__c>{credits[i].Payment__r.Description__c => credits[i]};
                    paymentReferences.put(accountId, tmpMap);
                }
            }
            
            //add Credit Ledger item into accountMap for later processing
            if(accountMap.containsKey(accountId)) {
                Map<String, List<Ledger_Item__c>> tmpMap = new Map<String, List<Ledger_Item__c>>();
                tmpMap = accountMap.get(accountId);
                tmpMap.get('credit').add(credits[i]);
                accountMap.put(accountId, tmpMap);
            } else {
                Map<String, List<Ledger_Item__c>> tmpMap = new Map<String, List<Ledger_Item__c>>();
                List<Ledger_Item__c> tmpList = new List<Ledger_Item__c>();
                tmpMap.put('debit', new List<Ledger_Item__c>());
                tmpList.add(credits[i]);
                tmpMap.put('credit', tmpList);
                accountMap.put(accountId, tmpMap);
            }
        }

        for(Integer i=0;i<debits.size();i++) {
            Id accountId = debits[i].Fiscal_Document__r.Account__c != null ? debits[i].Fiscal_Document__r.Account__c : debits[i].Refund__r.Payment__r.Account__c;
            
            //Calculate total debit first for every account
            if(totalDebit.containsKey(accountId)) {
                Decimal tmpDebit = totalDebit.get(accountId);
                tmpDebit += debits[i].Amount__c;
                totalDebit.put(accountId, tmpDebit);
            } else {
                totalDebit.put(accountId, debits[i].Amount__c);
            }
            
            //Extract any invoice references
            //if(debits[i].Fiscal_Document__c != null && debits[i].Fiscal_Document__r.Description__c != null) {
            if(debits[i].Fiscal_Document__c != null && debits[i].Fiscal_Document__r.Reference__c != null) {
                if(invoiceReferences.containsKey(accountId)) {
                    Map<String, Ledger_Item__c> tmpMap = new Map<String, Ledger_Item__c>(invoiceReferences.get(accountId));
                    if(!tmpMap.containsKey(debits[i].Fiscal_Document__r.Reference__c)) {
                        tmpMap.put(debits[i].Fiscal_Document__r.Reference__c, debits[i]);
                        invoiceReferences.put(accountId, tmpMap);
                    }
                } else {
                    Map<String, Ledger_Item__c> tmpMap = new Map<String, Ledger_Item__c>{debits[i].Fiscal_Document__r.Reference__C => debits[i]};
                    invoiceReferences.put(accountId, tmpMap);
                }
            }
            
            // Add invoice/refund ledger items into accountMap
            if(accountMap.containsKey(accountId)) {
                Map<String, List<Ledger_Item__c>> tmpMap = new Map<String, List<Ledger_Item__c>>();
                tmpMap = accountMap.get(accountId);
                tmpMap.get('debit').add(debits[i]);
                accountMap.put(accountId, tmpMap);
            } else {
                Map<String, List<Ledger_Item__c>> tmpMap = new Map<String, List<Ledger_Item__c>>();
                List<Ledger_Item__c> tmpList = new List<Ledger_Item__c>();
                tmpMap.put('credit', new List<Ledger_Item__c>());
                tmpList.add(debits[i]);
                tmpMap.put('debit', tmpList);
                accountMap.put(accountId, tmpMap);
            }
        }
      
        //Look for payment and invoice reference matches
        for(Id accId: accountIds) {       
            if(paymentReferences.containsKey(accId) && invoiceReferences.containsKey(accId)) {
                Map<String, Ledger_Item__c> payments = new Map<String, Ledger_Item__c>();
                Map<String, Ledger_Item__c> invoices = new Map<String, Ledger_Item__c>();
                payments = paymentReferences.get(accId);
                invoices = invoiceReferences.get(accId);
                for(String ref: payments.keySet()) {
                    if(invoices.containsKey(ref)) {
                        if(payments.get(ref).Amount__c == invoices.get(ref).Amount__c) {
                            //system.debug('Reconciliation: Reference and Amount Matched');
                            //Step 1: deduct and update amount of matched payment/creditnotes and invoice/refunds from totalCredit and totalDebit
                            Decimal reconcileAmount = payments.get(ref).Amount__c;
                            Decimal creditAmount = totalCredit.get(accId);
                            Decimal debitAmount = totalDebit.get(accId);
                            totalCredit.put(accId, creditAmount - reconcileAmount);
                            totalDebit.put(accId, debitAmount - reconcileAmount);
                            
                            //Step 2: remove matched payments/creditnotes and invoices/refunds from accountMap
                            List<Ledger_Item__c> accCredits = new List<Ledger_Item__c>();
                            List<Ledger_Item__c> accDebits = new List<Ledger_Item__c>();
                            accCredits = accountMap.get(accId).get('credit');
                            accDebits = accountMap.get(accId).get('debit');
                            Integer creditIndex = accCredits.indexOf(payments.get(ref));
                            Integer debitIndex = accDebits.indexOf(invoices.get(ref));
                            accCredits.remove(creditIndex);
                            accDebits.remove(debitIndex);
                            accountMap.get(accId).put('credit', accCredits);
                            accountMap.get(accId).put('debit', accDebits);
                            
							//Step 3: create a list of ledger items for reconciliation and reconcile matched credit and debit ledgers
                            List<Ledger_Item__c> localReconcileList = new List<ledger_Item__c>();
                            localReconcileList.add(payments.get(ref));
                            localReconcileList.add(invoices.get(ref));
                            reconcileList.add(localReconcileList);
                        }
                    }
                }
            }
        }
        
        //Look for exact amount match if manual reconciliation
        //accountMap can be defined as given below
        // Map<accountId, Map<'credit', List<payments + creditnotes>>>
        // Map<accountId, Map<'debit', List<invoices + refunds>>>
        if(!creditIds.isEmpty() || !debitIds.isEmpty()) { // i.e manual reconciliation if selective matching
            for(Id accId: accountIds) {
                //system.debug('credit size is: ' + accountMap.get(accId));
                if(!accountMap.containsKey(accId)) {
                    continue;
                }
                for(Integer i=0; i < accountMap.get(accId).get('credit').size() ; i++) {
                    if(accountMap.get(accId).get('credit').isEmpty() || accountMap.get(accId).get('debit').isEmpty()) {
                        break;
                    }
                    Ledger_Item__c creditItem = accountMap.get(accId).get('credit').get(i);
                    for(Integer j=0; j < accountMap.get(accId).get('debit').size() ; j++) {
                        if(accountMap.get(accId).get('debit').isEmpty()) {
                            break;
                        }
                        Ledger_Item__c debitItem = accountMap.get(accId).get('debit').get(j);
                        if(debitItem.Amount__c == creditItem.Amount__c) {
                            //system.debug('Manual Reconciliation: Amount Matched');
                            //Step 1: deduct and update amount of matched payment/creditnotes and invoice/refunds from totalCredit and totalDebit
                            Decimal reconcileAmount = debitItem.Amount__c;
                            Decimal creditAmount = totalCredit.get(accId);
                            Decimal debitAmount = totalDebit.get(accId);
                            totalCredit.put(accId, creditAmount - reconcileAmount);
                            totalDebit.put(accId, debitAmount - reconcileAmount);
                            
                            //Step 2: remove matched payments/creditnotes and invoices/refunds from accountMap
                            accountMap.get(accId).get('credit').remove(i);
                            accountMap.get(accId).get('debit').remove(j);
                            
                            //Step 3: create a list of ledger items for reconciliation and reconcile matched credit and debit ledgers
                            List<Ledger_Item__c> localReconcileList = new List<ledger_Item__c>();
                            localReconcileList.add(debitItem);
                            localReconcileList.add(creditItem);
                            reconcileList.add(localReconcileList);
                            break;
                        }
                    }
                }
            }
        }
        
        for(Id accId: accountIds) {
            if(!accountMap.containsKey(accId)) {
                continue;
            }
            if(totalCredit.containsKey(accId) && totalDebit.containsKey(accId)) {
                if(totalCredit.get(accId) == 0.00 || totalDebit.get(accId) == 0.00) {
                    continue;
                }
                
                //Looping through Credits and matching everything in order from Debits
                //Since we are adding new split items into accountMap during looping though it
                //we have to use a while loop on top of for loop 
                //to make sure if we added anything back into the accountMap
                //then the while loop will send us back to for loop again.
                
                //VAR reconcileList - List<List<Ledger_Item__c>> which is a list to create reconciliations in bulk for every list of ledgers inside this list
                //VAR localReconcileList - List of ledger items to be added into VAR reconcileList
                //VAR splitLedger - The one we split off and add it back to accountMap for reconciliation
                //VAR debitLedger - split debitledger that we reconcile after splitting
				//All Ledgers are split-created/modified and later updated into the database in bulk
                while(!accountMap.get(accId).get('credit').isEmpty() && !accountMap.get(accId).get('debit').isEmpty()) {
                    for(Integer i=0 ; i<accountMap.get(accId).get('credit').size() ; i++) {
                        if(accountMap.get(accId).get('debit').isEmpty()) {
                            break;
                        }
                        Ledger_Item__c item = new Ledger_Item__c();
                        item = accountMap.get(accId).get('credit').remove(0);
                        if(item.Amount__c == accountMap.get(accId).get('debit')[0].Amount__c) {//exact match
                            //system.debug('Reconciliation: Amount Matched');
                            List<Ledger_Item__c> localReconcileList = new List<Ledger_Item__c>();
                            localReconcileList.add(item);
                            localReconcileList.add(accountMap.get(accId).get('debit').remove(0));
                            reconcileList.add(localReconcileList);
                        } else if(item.Amount__c < accountMap.get(accId).get('debit')[0].Amount__c) {//If credit less than debit - Split Debit
                            //system.debug('Reconciliation: Debit Split Amount Matched');
                            List<Ledger_Item__c> localReconcileList = new List<Ledger_Item__c>();
                            Ledger_Item__c splitLedger = new Ledger_Item__c();
                            Ledger_Item__c debitLedger = accountMap.get(accId).get('debit').remove(0);
                            splitLedger = debitLedger.clone(false, true, false, false);
                            splitLedger.Amount__c = splitLedger.Amount__c - item.Amount__c;
                            splitLedger.Draft__c = true;
                            debitLedger.Amount__c = item.Amount__c;
                            
                            if(accountMap.get(accId).get('debit').isEmpty()) {
                                accountMap.get(accId).get('debit').add(splitLedger);
                            } else {
                                accountMap.get(accId).get('debit').add(0,splitLedger);
                            }
                            
                            localReconcileList.add(item);
                            localReconcileList.add(debitLedger);
                            reconcileList.add(localReconcileList);
                        } else {//debit less than credit -Split Credit
                            //system.debug('Reconciliation: Credit Split Amount Matched');
                            List<Ledger_Item__c> localReconcileList = new List<Ledger_Item__c>();
                            Ledger_Item__c splitLedger = new Ledger_Item__c();
                            splitLedger = item.clone(false, true, false, false);
                            splitLedger.Amount__c = splitLedger.Amount__c - accountMap.get(accId).get('debit')[0].Amount__c;
                            splitLedger.Draft__c = true;
                            item.Amount__c = accountMap.get(accId).get('debit')[0].Amount__c;
                            
                            if(accountMap.get(accId).get('credit').isEmpty()) {
                                accountMap.get(accId).get('credit').add(splitLedger);
                            } else {
                                accountMap.get(accId).get('credit').add(0,splitLedger);
                            }
                            
                            localReconcileList.add(item);
                            localReconcileList.add(accountMap.get(accId).get('debit').remove(0));
                            reconcileList.add(localReconcileList);
                        }
                    }
                }
            }
        }
        
        //Create a list of new and split ledgers
        for(List<Ledger_Item__c> ledgerItems: reconcileList) {
            for(Ledger_Item__c item: ledgerItems) {
                if(item.Id == null) {
                    newLedgers.add(item);
                } else {
                    if(item.Draft__c) {
                        item.Draft__c = false;
                    }
                    splitLedgers.add(item);
                }
            }
        }
        
        //Extract any remaining credit/debit ledgers from account map which were left and not reconciled
        for(Id accId: accountMap.keySet()) {
            if(!accountMap.get(accId).get('credit').isEmpty()) {
                for(Ledger_Item__c item: accountMap.get(accId).get('credit')) {
                    if(item.Id == null) {
                        newLedgers.add(item);
                    } else {
                    	splitLedgers.add(item);
                    }
                }
            }
            
            if(!accountMap.get(accId).get('debit').isEmpty()) {
                for(Ledger_Item__c item: accountMap.get(accId).get('debit')) {
                    if(item.Id == null) {
                        newLedgers.add(item);
                    } else {
                    	splitLedgers.add(item);
                    }
                }
            }
        }

		//insert ledgers that were split-created during reconciliation process        
        insert newLedgers;
        
        //Set Draft false and update
        splitLedgers.addAll(newLedgers);
        for(Ledger_Item__c item: splitLedgers) {
            if(item.Draft__c == true){
                item.Draft__c = false;
            }
        }
        
        update splitLedgers;

		//Finally reconcile every thing        
        if(reconcileList.size() > 0) {
            return reconcileLedgerItems(reconcileList);
        }
        return new List<Reconciliation__c>();
    }
    
    public static List<Reconciliation__c> reconcileLedgerItems(Set<List<Ledger_Item__c>> reconcileList) {
        if(reconcileList.isEmpty()) {
            return new List<Reconciliation__c>();
        }
        
        List<Reconciliation__c> reconciliations = new List<Reconciliation__c>();
        List<Ledger_Item__c> reconciledLedgers = new List<Ledger_Item__c>();
        Map<Id, Decimal> totals = new Map<Id, Decimal>();
        
        
        Map<Id, List<Reconciliation__c>> reconciliationsMap = new Map<Id, List<Reconciliation__c>>();
        
        //STEP 1: Create all the reconciliations
        for(List<Ledger_Item__c> ledgerItems: reconcileList) {
            Id accountId = null;
            if(ledgerItems[0].Fiscal_Document__c != null) {
                accountId = ledgerItems[0].Fiscal_Document__r.Account__c;
            } else if (ledgerItems[0].Payment__c != null) {
                accountId = ledgerItems[0].Payment__r.Account__c;
            } else {
                accountId = ledgerItems[0].Refund__r.Payment__r.Account__c;
            }
            
            Reconciliation__c reconciliation = new Reconciliation__c(Account__c = accountId, Credits__c = 0.00, Debits__c = 0.00, Reconciled__c = false);
            reconciliations.add(reconciliation);
            
            if(reconciliationsMap.containsKey(accountId)) {
                List<Reconciliation__c> tmpList = new List<Reconciliation__c>();
                tmpList = reconciliationsMap.get(accountId);
                tmpList.add(reconciliation);
                reconciliationsMap.put(accountId, tmpList);
            } else {
                List<Reconciliation__c> tmpList = new List<Reconciliation__c>();
                tmpList.add(reconciliation);
                reconciliationsMap.put(accountId, tmpList);
            }
        }
        
        insert reconciliations;
        
        //STEP 2 
        //calculate credit/debit amount for every reconciliation
        //link ledgers with inserted reconciliations
        for(List<Ledger_Item__c> ledgerItems: reconcileList) {
            Id accountId = null;
            if(ledgerItems[0].Fiscal_Document__c != null) {
                accountId = ledgerItems[0].Fiscal_Document__r.Account__c;
            } else if (ledgerItems[0].Payment__c != null) {
                accountId = ledgerItems[0].Payment__r.Account__c;
            } else {
                accountId = ledgerItems[0].Refund__r.Payment__r.Account__c;
            }
            
            Decimal credit = 0.00;
            Decimal debit = 0.00;
            
            List<Reconciliation__c> tmpList = reconciliationsMap.get(accountId);
			Reconciliation__c tmpRecon = tmpList.remove(0);            
            for(Ledger_Item__c item: ledgerItems) {
				item.Reconciliation__c = tmpRecon.Id;
                reconciledLedgers.add(item);

                if(item.Fiscal_Document__c != null) {
                    if(item.Fiscal_Document__r.RecordType.DeveloperName == 'sales_invoice') {
                        debit += item.Amount__c;
                    } else {
                        credit += item.Amount__c;
                    }
                }
                
                if(item.Payment__c != null)  {
                    credit += item.Amount__c;
                }
                
                if(item.Refund__c != null) {
                    debit += item.Amount__c;
                }
                
            }
            totals.put(tmpRecon.Id, credit);
        }
        update reconciledLedgers;
        
        //STEP 3: Update credits/debits and set reconciled = true for every reconciliation
        for(Reconciliation__c reconciliation: reconciliations) {
            Id reconciliationId = reconciliation.Id;
            reconciliation.Credits__c = totals.get(reconciliationId);
            reconciliation.Debits__c = totals.get(reconciliationId);
            reconciliation.Reconciled__c = true;
        }
        update reconciliations;        
        return reconciliations;
    }
    
    public static void calculateParentAmountAllocated (List<Ledger_Item__c> ledgerItems) {
        if(ledgerItems.isEmpty()) {
            return;
        }
        
        //update amount allocated
        Set<Id> fiscalDocumentIds = new Set<Id>();
        Set<Id> paymentIds = new Set<Id>();
        Set<Id> refundIds = new Set<Id>();
        for(Ledger_Item__c item: ledgerItems) {
            if (item.Fiscal_Document__c != null) {
                fiscalDocumentIds.add(item.Fiscal_Document__c);
            }
            if (item.Payment__c != null) {
                paymentIds.add(item.Payment__c);
            }
            if (item.Refund__c != null) {
                refundIds.add(item.Refund__c);
            }
        }
        
        if (!fiscalDocumentIds.isEmpty()) {
            FiscalDocument.calculateAmountAllocated(fiscalDocumentIds);
        }
        if (!paymentIds.isEmpty()) {
            Payment.calculateAmountAllocated(paymentIds);
        }
        if (!refundIds.isEmpty()) {
            Refund.calculateAmountAllocated(refundIds);
        }
    }
    
    //For when reconciliations are deleted or payment failed
    public static void removeReconciliation(List<Id> objIds) { 
        if(objIds[0].getSObjectType().getDescribe().getName() == 'Fiscal_Document__c') {
            List<Fiscal_Document__c> fdList = [SELECT Id, Subtotal__c, (SELECT Id, Amount__c, Draft__c, Reconciled__c, Reconciliation__c, Fiscal_Document__c, Payment__c, Refund__c FROM Ledger_Items__r WHERE Reconciled__c = false) FROM Fiscal_Document__c WHERE Id IN :objIds];
            for(Fiscal_Document__c fd: fdList) {
                List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>(fd.Ledger_Items__r);
                if(ledgerItems.size() > 1) {
                    LedgerItem.unsplitItems(ledgerItems);
                } else {
                    ledgerItems[0].Reconciliation__c = null;
                    update ledgerItems;
                }
            }
        } else if(objIds[0].getSObjectType().getDescribe().getName() == 'Payment__c') {
            List<Payment__c> paymentList = [SELECT Id, Amount__c, (SELECT Id, Amount__c, Draft__c, Reconciled__c, Reconciliation__c, Payment__c, Refund__c, Fiscal_Document__c FROM Ledger_Items__r WHERE Reconciled__c = false) FROM Payment__c WHERE Id IN :objIds];
            for(Payment__c payment: paymentList) {
                List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>(payment.Ledger_Items__r);
                if(ledgerItems.size() > 1) {
                    LedgerItem.unsplitItems(ledgerItems);
                } else {
                    ledgerItems[0].Reconciliation__c = null;
                    update ledgerItems;
                }
            }
        } else if(objIds[0].getSObjectType().getDescribe().getName() == 'Refund__c') {
            List<Refund__c> refundList = [SELECT Id, Amount__c, (SELECT Id, Amount__c, Draft__c, Reconciled__c, Reconciliation__c, Refund__c, Payment__c, Fiscal_Document__c FROM Ledger_Items__r WHERE Reconciled__c = false) FROM Refund__c WHERE Id IN :objIds];
            for(Refund__c refund: refundList) {
                List<Ledger_Item__c> ledgerItems = new List<Ledger_Item__c>(refund.Ledger_Items__r);
                if(ledgerItems.size() > 1) {
                    LedgerItem.unsplitItems(ledgerItems);
                } else {
                    ledgerItems[0].Reconciliation__c = null;
                    update ledgerItems;
                }
            }
        }
    }
}