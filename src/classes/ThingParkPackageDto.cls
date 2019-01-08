public class ThingParkPackageDto {
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