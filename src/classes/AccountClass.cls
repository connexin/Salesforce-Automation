public class AccountClass {
	
    public static List<SortedStatement> getSortedStatement (Date startDate, Date endDate, Id accountId, Boolean outstandingOnly) {
        if(accountId == null) return null;
        if(startDate == null) startDate = Date.today().addDays(-30);
        if(endDate == null) endDate = Date.today();

        List<Payment__c> payments = new List<Payment__c>();
        List<Fiscal_Document__c> invoices = new List<Fiscal_Document__c>();
        List<Fiscal_Document__c> creditnotes = new List<Fiscal_Document__c>();
        List<Refund__c> refunds = new List<Refund__c>();
        if(outstandingOnly) {
            payments.addAll([SELECT Id, Actual_Date__c, Amount__c, Amount_Allocated__c,  Reference__c, Status__c, Description__c FROM Payment__c WHERE Account__c = :accountId AND Actual_Date__c >= :startDate AND Actual_Date__c <= :endDate AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Status__c NOT IN ('Paid - Allocated')]);
            invoices.addAll([SELECT Id, Date__c, RecordType.Name, Subtotal__c, Amount_Allocated__c, Reference__c, Status__c, Description__c, Dispute__c FROM Fiscal_Document__c WHERE Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND RecordType.DeveloperName = 'sales_invoice' AND Draft__c = false AND Status__c NOT IN ('Paid')]);
            creditnotes.addAll([SELECT Id, Date__c, RecordType.Name, Subtotal__c, Amount_Allocated__c, Reference__c, Status__c, Description__c, Dispute__c FROM Fiscal_Document__c WHERE Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND RecordType.DeveloperName = 'credit_note'AND Draft__c = false AND Status__c NOT IN ('Allocated')]);
            refunds.addAll([SELECT Id, Name, Amount__c, Amount_Allocated__c, Payment__c, Reference__c, Date__c, Status__c FROM Refund__c WHERE Payment__r.Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND Draft__c = false AND Status__c NOT IN ('Confirmed - Allocated') AND Payment_Failed__c = false]);
        } else {
        	payments.addAll([SELECT Id, Actual_Date__c, Amount__c, Amount_Allocated__c, Reference__c, Status__c, Description__c FROM Payment__c WHERE Account__c = :accountId AND Actual_Date__c >= :startDate AND Actual_Date__c <= :endDate AND Draft__c = false AND Confirmed__c = true AND Failed__c = false]);
            invoices.addAll([SELECT Id, Date__c, RecordType.Name, Subtotal__c, Amount_Allocated__c, Reference__c, Status__c, Description__c, Dispute__c FROM Fiscal_Document__c WHERE Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND RecordType.DeveloperName = 'sales_invoice' AND Draft__c = false]);
            creditnotes.addAll([SELECT Id, Date__c, RecordType.Name, Subtotal__c, Amount_Allocated__c, Reference__c, Status__c, Description__c, Dispute__c FROM Fiscal_Document__c WHERE Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND RecordType.DeveloperName = 'credit_note'AND Draft__c = false]);
            refunds.addAll([SELECT Id, Name, Amount__c, Amount_Allocated__c, Payment__c, Reference__c, Date__c, Status__c FROM Refund__c WHERE Payment__r.Account__c = :accountId AND Date__c >= :startDate AND Date__c <= :endDate AND Draft__c = false AND Confirmed__c = true AND Failed__c = false AND Payment_Failed__c = false]);
        }
        
        List<SortedStatement> sortedList = new List<SortedStatement>();
        
        for(Payment__c payment: payments) {
        	SortedStatement stmt = new SortedStatement(payment.Actual_Date__c, payment.Id, 'Payment', payment.Reference__c, payment.Status__c, payment.Amount__c, false);
            stmt.amount_allocated = payment.Amount_Allocated__c;
            stmt.outstanding_amount = stmt.credit_amount - stmt.amount_allocated;
            sortedList.add(stmt);
        }
        
        for(Fiscal_Document__c invoice: invoices) {
            SortedStatement stmt = new SortedStatement(invoice.Date__c, invoice.Id, 'Sales Invoice', invoice.Reference__c, invoice.Status__c, invoice.Subtotal__c, invoice.Dispute__c);
            stmt.amount_allocated = invoice.Amount_Allocated__c;
            stmt.outstanding_amount = stmt.debit_amount - stmt.amount_allocated;
            sortedList.add(stmt);
        }
        
        for(Fiscal_Document__c creditnote: creditnotes) {
            SortedStatement stmt = new SortedStatement(creditnote.Date__c, creditnote.Id, 'Credit Note', creditnote.Reference__c, creditnote.Status__c, creditnote.Subtotal__c, creditnote.Dispute__c);
            stmt.amount_allocated = creditnote.Amount_Allocated__c;
            stmt.outstanding_amount = stmt.credit_amount - stmt.amount_allocated;
            sortedList.add(stmt);
        }
        
        for(Refund__c refund: refunds) {
            DateTime dt = refund.Date__c;
            SortedStatement stmt = new SortedStatement(Date.newInstance(dt.year(), dt.month(), dt.day()), refund.Id, 'Refund', refund.Name, refund.Status__c, refund.Amount__c, false);
            stmt.amount_allocated = refund.Amount_Allocated__c;
            stmt.outstanding_amount = stmt.debit_amount - stmt.amount_allocated;
            sortedList.add(stmt);
        }
        sortedList.sort();
        return sortedList;
    }
    
    public static List<SortedDebtorsList> getSortedDebtorsList(Boolean includeDisputedInvoices, String customerType, Boolean includeOpenInvoices, Date invoiceCutoffDate) {
        return AccountClass.getSortedDebtorsList(includeDisputedInvoices, customerType, includeOpenInvoices, invoiceCutoffDate, true);
    }
    
    public static List<SortedDebtorsList> getSortedDebtorsList(Boolean includeDisputedInvoices, String customerType, Boolean includeOpenInvoices, Date invoiceCutoffDate, Boolean includePendingPayments) {
        List<SortedDebtorsList> sortedDebtors = new List<SortedDebtorsList>();
        String soql;
        
        soql = 'SELECT Id, Name, Debtor__c, Type FROM Account';
        if(customerType != null && customerType != 'All') {
            soql = soql + ' WHERE Type = :customerType' ;
        } 
        
        List<Account> accounts = new List<Account>();
        for(sObject s: Database.query(soql)) {
            accounts.add((Account)s);
        }
        
        Map<Id, Decimal> invoiceMap = new Map<Id, Decimal>();
        Map<Id, Decimal> creditnoteMap = new Map<Id, Decimal>();
        Map<Id, Decimal> paymentMap = new Map<Id, Decimal>();
        Map<Id, Decimal> refundMap = new Map<Id, Decimal>();
        
        soql = 'SELECT Account__c, Subtotal__c, Date__c, Payment_Term__c, Status__c FROM Fiscal_Document__c WHERE Draft__c = false AND RecordType.DeveloperName = \'sales_invoice\'';
        if(!includeDisputedInvoices) {
            soql = soql + ' and Dispute__c = false' ;
        }
        
        if(!includeOpenInvoices) {
            soql = soql + ' AND Status__c != \'Open\'';
        }
        
        for(sObject s: Database.query(soql)) {
            Fiscal_Document__c fd = (Fiscal_Document__c)s;
            if(invoiceCutoffDate != null) {
                //Date tmpDate = fd.Date__c;
                //tmpDate = tmpDate.addDays((Integer)fd.Payment_Term__c);
                if(invoiceCutoffDate < fd.Date__c ) {
                    continue;
                }
            }
            
            if(invoiceMap.containsKey(fd.Account__c)) {
                Decimal totalAmount = invoiceMap.get(fd.Account__c);
                totalAmount += fd.Subtotal__c;
                invoiceMap.put(fd.Account__c, totalAmount);
            } else {
                invoiceMap.put(fd.Account__c, fd.Subtotal__c);
            }
        }
        
        for(Fiscal_Document__c fd: [SELECT Account__c, Subtotal__c, Date__c FROM Fiscal_Document__c WHERE Draft__c = false AND RecordType.DeveloperName = 'credit_note' AND Dispute__c = false]) {
            
            if(invoiceCutoffDate != null) {
                if(invoiceCutoffDate < fd.Date__c ) {
                    continue;
                }
            }
            
            if(creditnoteMap.containsKey(fd.Account__c)) {
                Decimal totalAmount = creditnoteMap.get(fd.Account__c);
                totalAmount += fd.Subtotal__c;
                creditnoteMap.put(fd.Account__c, totalAmount);
            } else {
                creditnoteMap.put(fd.Account__c, fd.Subtotal__c);
            }
        }
        
        soql = 'SELECT Account__c, Amount__c, Actual_Date__c FROM Payment__c WHERE Draft__c = false AND ';
        if (!includePendingPayments) {
            soql += 'Confirmed__c = true AND ';
        }
        soql += 'Failed__c = false';
        for(Payment__c payment: Database.query(soql)) {
            
            if(invoiceCutoffDate != null) {
            	if(invoiceCutoffDate < payment.Actual_Date__c) {
                	continue;
                }
            }
            
            if(paymentMap.containsKey(payment.Account__c)) {
                Decimal totalAmount = paymentMap.get(payment.Account__c);
                totalAmount += payment.Amount__c;
                paymentMap.put(payment.Account__c, totalAmount);
            } else {
                paymentMap.put(payment.Account__c, payment.Amount__c);
            }
        }
        
        for(Refund__c refund: [SELECT Payment__r.Account__c, Amount__c, Date__c FROM Refund__c WHERE Draft__c = false and Confirmed__c = true AND Failed__c = false AND Payment_Failed__c = false]) {
            
            if(invoiceCutoffDate != null) {
                if(invoiceCutoffDate < refund.Date__c ) {
                    continue;
                }
            }
            
            if(refundMap.containsKey(refund.Payment__r.Account__c)) {
                Decimal totalAmount = refundMap.get(refund.Payment__r.Account__c);
                totalAmount += refund.Amount__c;
                refundMap.put(refund.Payment__r.Account__c, totalAmount);
            } else {
                refundMap.put(refund.Payment__r.Account__c, refund.Amount__c);
            }
        }
        
        for(Account acc: accounts) {
            SortedDebtorsList debtor = new SortedDebtorsList(acc.Id, acc.Name, acc.Debtor__c, acc.Type, invoiceMap.containsKey(acc.Id) && invoiceMap.get(acc.Id) != null ? invoiceMap.get(acc.Id) : 0.00, creditnoteMap.containsKey(acc.Id) && creditnoteMap.get(acc.Id) != null ? creditnoteMap.get(acc.Id) : 0.00, paymentMap.containsKey(acc.Id) && paymentMap.get(acc.Id) != null ? paymentMap.get(acc.Id) : 0.00 , refundMap.containsKey(acc.Id) && refundMap.get(acc.Id) != null ? refundMap.get(acc.Id) : 0.00);
            sortedDebtors.add(debtor);
        }
        sortedDebtors.sort();
        return sortedDebtors;
    }
    
    public static List<SortedStatement> getReconciliationItems (Id accountId, String itemType) {
        if(accountId == null || itemType == null) return null;
        
        List<Ledger_Item__c> invoices = new List<Ledger_Item__c>();
        List<Ledger_Item__c> creditnotes = new List<Ledger_Item__c>();
        List<Ledger_Item__c> payments = new List<Ledger_Item__c>();
        List<Ledger_Item__c> refunds = new List<Ledger_Item__c>();
        
        List<SortedStatement> sortedList = new List<SortedStatement>();
        if(itemType == 'credit') {
            //credits
            for(Ledger_Item__c item: [SELECT Id, Reconciled__c, Amount__c, Payment__c, Payment__r.Date__c, Payment__r.Reference__c, Payment__r.Status__c, Payment__r.Amount_Allocated__c, Payment__r.Amount__c, Payment__r.Description__c, Fiscal_Document__c, Fiscal_Document__r.Date__c, Fiscal_Document__r.Subtotal__c, Fiscal_Document__r.Reference__c, Fiscal_Document__r.Status__c, Fiscal_Document__r.Amount_Allocated__c, Fiscal_Document__r.Dispute__c, Fiscal_Document__r.Description__c FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Payment__r.Draft__c = false AND Payment__r.Confirmed__c = true AND Payment__r.Failed__c = false) OR (Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.Dispute__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'credit_note')) AND (Payment__r.Account__c = :accountId OR Fiscal_Document__r.Account__c = :accountId)]) {
                if(item.Payment__c != null) {
                    SortedStatement stmt = new SortedStatement(item.Payment__r.Date__c, item.Id, 'Payment', item.Payment__r.Reference__c, item.Payment__r.Status__c, item.Amount__c, false);
                    stmt.amount_allocated = item.Payment__r.Amount_Allocated__c;
                    stmt.description = item.Payment__r.Description__c;
                    stmt.split_amount = item.Amount__c;
                    stmt.split = false;
                    stmt.outstanding_amount = item.Payment__r.Amount__c - item.Payment__r.Amount_Allocated__c;
                    stmt.total_amount = item.Payment__r.Amount__c;
                    sortedList.add(stmt);
                } else {
                    SortedStatement stmt = new SortedStatement(item.Fiscal_Document__r.Date__c, item.Id, 'Credit Note', item.Fiscal_Document__r.Reference__c, item.Fiscal_Document__r.Status__c, item.Amount__c, false);
                    stmt.amount_allocated = item.Fiscal_Document__r.Amount_Allocated__c;
                    stmt.description = item.Fiscal_Document__r.Description__c;
                    stmt.split_amount = item.Amount__c;
                    stmt.split = false;
                    stmt.outstanding_amount = item.Fiscal_Document__r.Subtotal__c - item.Fiscal_Document__r.Amount_Allocated__c;
                    stmt.total_amount = item.Fiscal_Document__r.Subtotal__c;
                    sortedList.add(stmt);
                }   
            }
        } else {
            //debits
            for(Ledger_Item__c item: [SELECT Id, Reconciled__c, Amount__c, Refund__c, Refund__r.Date__c, Refund__r.Name, Refund__r.Status__c, Refund__r.Amount__c, Refund__r.Amount_Allocated__c, Fiscal_Document__c, Fiscal_Document__r.Date__c, Fiscal_Document__r.Subtotal__c, Fiscal_Document__r.Reference__c, Fiscal_Document__r.Status__c, Fiscal_Document__r.Amount_Allocated__c, Fiscal_Document__r.Dispute__c, Fiscal_Document__r.Description__c FROM Ledger_Item__c WHERE Draft__c = false AND Reconciled__c = false AND ((Refund__r.Draft__c = false AND Refund__r.Confirmed__c = true AND Refund__r.Failed__c = false AND Refund__r.Payment_Failed__c = false) OR (Fiscal_Document__r.Draft__c = false AND Fiscal_Document__r.Dispute__c = false AND Fiscal_Document__r.RecordType.DeveloperName = 'sales_invoice')) AND (Refund__r.Payment__r.Account__c = :accountId OR Fiscal_Document__r.Account__c = :accountId)]) {
                if(item.Refund__c != null) {
                    DateTime dt = item.Refund__r.Date__c;
                    SortedStatement stmt = new SortedStatement(Date.newInstance(dt.year(), dt.month(), dt.day()), item.Id, 'Refund', (String)item.Refund__r.Name, item.Refund__r.Status__c, item.Amount__c, false);
                    stmt.amount_allocated = item.Refund__r.Amount_Allocated__c;
                    stmt.description = null;
                    stmt.split_amount = item.Amount__c;
                    stmt.split = false;
                    stmt.outstanding_amount = item.Refund__r.Amount__c - item.Refund__r.Amount_Allocated__c;
                    stmt.total_amount = item.Refund__r.Amount__c;
                    sortedList.add(stmt);
                } else {
                    SortedStatement stmt = new SortedStatement(item.Fiscal_Document__r.Date__c, item.Id, 'Sales Invoice', item.Fiscal_Document__r.Reference__c, item.Fiscal_Document__r.Status__c, item.Amount__c, false);
                    stmt.amount_allocated = item.Fiscal_Document__r.Amount_Allocated__c;
                    stmt.description = item.Fiscal_Document__r.Description__c;
                    stmt.split_amount = item.Amount__c;
                    stmt.split = false;
                    stmt.outstanding_amount = item.Fiscal_Document__r.Subtotal__c - item.Fiscal_Document__r.Amount_Allocated__c;
                    stmt.total_amount = item.Fiscal_Document__r.Subtotal__c;
                    sortedList.add(stmt);
                }   
            }
        }
        sortedList.sort();
        return sortedList;
    }
    
    /*public static void emailInvoice(Set<Id> invoiceIds) {
        //add code when invoice template is available
    }*/
    
}