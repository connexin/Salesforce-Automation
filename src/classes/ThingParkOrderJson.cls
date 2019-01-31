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
    public String offerId { get; set; }
    public String subscriberId { get; set; }
    private ThingParkRestConfig config;

    public ThingParkOrderJson() {
        this.config = ThingParkRestConfig.selectCurrent();
    }
    
    public ThingParkOrderJson(String scopeLabel) {
        this.config = ThingParkRestConfig.selectScope(scopeLabel);
    }

    public ThingParkOrderJson(final String offerId, final String subscriberId) {
        this.config = ThingParkRestConfig.selectCurrent();
        this.offerId = offerId;
        this.subscriberId = subscriberId;
    }

    public String toJson() {
        jsonTemplate = config.orderJsonTemplate();
        System.debug('jsonTemplate.replace(${offerId}, offerId) : ' + offerId);
        System.debug('jsonTemplate.replace(${offerId}).with(offerId) : ' + with(offerId));
        replace('${offerId}', with(offerId));
        replace('${subscriberId}', with(subscriberId));
        return jsonTemplate;
    }

    public String verify() {
        failOnError = false;
        jsonTemplate = config.orderJsonTemplate();
        System.debug('jsonTemplate before replacement : ' + jsonTemplate);
        System.debug('jsonTemplate after replacement : ' + toJson());
        return jsonTemplate;
    }
}