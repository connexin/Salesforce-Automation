public class SortedStatement implements Comparable {

    public Date sortDate {get; set;}
    public Id objectId {get; set;}
    public String objectType {get; set;}
    
    public String reference {get; set;}
    public String status {get; set;}
    public Decimal debit_amount {get; set;}
    public Decimal credit_amount {get; set;}
    public Decimal total_amount {get; set;}
    public Decimal balance_amount {get; set;}
    public Decimal amount_allocated {get; set;}
    public Boolean disputed {get; set;}
    public String description {get; set;}
    public Boolean split {get; set;}
    public Decimal split_amount {get; set;}
    public Decimal outstanding_amount {get; set;}
    
    public SortedStatement (Date objDate, Id ObjId, String objType, String reference, String status, Decimal amount, Boolean in_dispute) {
        this.sortDate = objDate;
        this.objectId = objId;
        this.objectType = objType;

        this.reference = reference;
        this.status = status;
        this.debit_amount = 0.00;
        this.credit_amount = 0.00;
        this.total_amount = 0.00;
        if(objType == 'Payment' || objType == 'Credit Note') {
            this.credit_amount = amount.setScale(2);
        } else {
            this.debit_amount = amount.setScale(2);
        }
        this.disputed = in_dispute;
        this.amount_allocated = 0.00;
        this.split = false;
        this.split_amount = 0.00;
        this.outstanding_amount = 0.00;
    }
    
    public Integer compareTo(Object compareTo) {
        SortedStatement stmtDate = (SortedStatement)compareTo;
        
        if(sortDate == stmtDate.sortDate) return 0;
        if(sortDate > stmtDate.sortDate) return 1;
        return -1;
    }
}