/**
    Order {
        id (string, optional): Id of the order. ,
        ref (string, optional): Ref of the order. ,
        offerId (string): Id of the offer which is being subscribed. ,
        subscriberId (string): Id of the subscriber who is subscribing to the offer. ,
        state (string, optional): State of the order. 
        }
*/
public class ThingParkOrderJson {
    private String jsonTemplate { get; set; }
    private String id { get; set; }
    private String ref { get; set; }
    private String offerId { get; set; }
    private String subscriberId { get; set; }

	public ThingParkOrderJson() {
		ThingParkRestConfig config = new ThingParkRestConfig();
        jsonTemplate = config.orderJsonTemplate();
        System.debug('jsonTemplate :' + jsonTemplate);        
    }

	public ThingParkOrderJson(final String orderJsonTemplate) {
        jsonTemplate = orderJsonTemplate;
        System.debug('jsonTemplate :' + jsonTemplate);        
    }
    
    public String toJson() {
		String orderJson = jsonTemplate;
        if (offerId != null) {
        	orderJson = orderJson.replace('${offerId}', offerId);
        }
        if (subscriberId != null) {
        	orderJson = orderJson.replace('${subscriberId}', subscriberId);
        }
		return orderJson;
	}

    public String jsonFrom(LoRaWAN_Package__c pckage) {
  		offerId = 'connexin-vdr/test-offer';
		return toJson();
    }

}