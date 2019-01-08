public class ThingParkTenancyDto {
    public String id;
    public String name;
    public String accountId;
    public String actilitySubscriberId;
    public Integer dailyMaxAverage;
    public Integer totalDevices;
    public Integer overageRate;
    
    public String toJson() {
    	return JSON.serialize(this);
	}
}