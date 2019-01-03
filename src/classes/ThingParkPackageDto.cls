public class ThingParkPackageDto {
    String id;
    String name;
    String actilitySubscriptionId;
    String tenancy;
    Date startDate;
    Integer term;
    Date endDate;
    Integer quantityOfDevices;
    Integer  deviceRate;
    Integer  deviceRateAfterCommitmentEnd;
    String status;
    Boolean active;
    Boolean cancelled;
    
    public String toJson() {
        return JSON.serialize(this);
        }    
}