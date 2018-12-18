public class SortedDebtorsList implements Comparable{

    public Id accountId {get; set;}
    public String accountName {get; set;}
    public Decimal invoiceAmount {get; set;}
    public Decimal creditnoteAmount {get; set;}
    public Decimal paymentAmount {get; set;}
    public Decimal refundAmount {get; set;}
    public Decimal balanceAmount {get; set;}
    public Boolean Debtor {get; set;}
    public string customerType {get; set;}
    
    public sortedDebtorsList(Id accId, String accName, Boolean debtorFlag, String cType, Decimal invAmount, Decimal cnAmount, Decimal pmAmount, Decimal rfAmount) {
        this.invoiceAmount = 0.00;
        this.creditnoteAmount = 0.00;
        this.paymentAmount = 0.00;
        this.refundAmount = 0.00;
        this.accountId = null;
        this.accountName = '';
        this.balanceAmount = 0.00;
        
        this.invoiceAmount = invAmount;
        this.creditnoteAmount = cnAmount;
        this.paymentAmount = pmAmount;
        this.refundAmount = rfAmount;
        this.accountId = accId;
        this.accountName = AccName;
        this.balanceAmount =  (invAmount + rfAmount) - (cnAmount + pmAmount);
        this.debtor = debtorFlag;
        this.customerType = cType;
    }
    
    public Integer compareTo(Object compareTo) {
        SortedDebtorsList sortedBalance = (SortedDebtorsList)compareTo;
        
        if(balanceAmount == sortedBalance.balanceAmount) return 0;
        if(balanceAmount < sortedBalance.balanceAmount) return 1;
        return -1;
    }
    
}