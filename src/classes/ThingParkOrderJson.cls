/**
Order {
id (string, optional): Id of the order. ,
ref (string, optional): Ref of the order. ,
offerId (string): Id of the offer which is being subscribed. ,
subscriberId (string): Id of the subscriber who is subscribing to the offer. ,
state (string, optional): State of the order. 
}
*/
public class ThingParkOrderJson extends AbstractJsonTemplate {
    private ThingParkRestConfig config;
    public String offerId { get; set; }
    public String subscriberId { get; set; }

    public ThingParkOrderJson() {
        this.config = ThingParkRestConfig.selectCurrent();
    }

    public ThingParkOrderJson(final String offerId, final String subscriberId) {
        this.config = ThingParkRestConfig.selectCurrent();
        System.debug('config :' + this.config);
        this.offerId = offerId;
        this.subscriberId = subscriberId;
    }

    public String toJson() {
        jsonTemplate = config.orderJsonTemplate();
        
        replace('${offerId}', offerId);
        replace('${subscriberId}', subscriberId);
        
        return jsonTemplate;
    }
}