public class ThingParkTenancyDto {
    String id;
    String name;
    String accountId;
    String actilitySubscriberId;
    Integer dailyMaxAverage;
    Integer totalDevices;
    Integer overageRate;
    
    public String toJson() {
        return JSON.serialize(this);
        }
}