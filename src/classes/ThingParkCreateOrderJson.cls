/**
    Order {
        id (string, optional): Id of the order. ,
        ref (string, optional): Ref of the order. ,
        offerId (string): Id of the offer which is being subscribed. ,
        subscriberId (string): Id of the subscriber who is subscribing to the offer. ,
        state (string, optional): State of the order. 
        }
*/
public class ThingParkCreateOrderJson {
    public String id;
    public String name;
    public String actilitySubscriptionId;
    public String tenancy;
    public Date startDate;
    public Integer term;
    public Date endDate;
    public Integer quantityOfDevices;
    public Integer  deviceRate;
    public Integer  deviceRateAfterCommitmentEnd;
    public String status;
    public Boolean active;
    public Boolean cancelled;

    public String toJson() {
        return JSON.serialize(this);
        }

}