public class ThingParkBilling {
    
    private ThingParkInvoice invoice;    
    private LoRaWAN_Tenancy__c lorawanTenancy;
    private LoRaWAN_Package__c lorawanPackage;
    
        // jsonData.accountId
        // jsonData.referencePeriod
        // jsonData.description
        // jsonData.actionDate
        // jsonData.tenancyId
        // jsonData.packageUsage
        // jsonData.messageUsage
        // jsonData.eolUsage
    public String process(final ThingParkUsageJson jsonData) {
        System.debug('ThingParkBilling.process(ThingParkUsageJson) : ' + jsonData);

        this.lorawanTenancy = getTenancy(jsonData.tenancyId);
        
        this.lorawanPackage = getPackage(jsonData.packageUsage.packageId);

        invoice = ThingParkInvoice.create(jsonData.accountId,
                                          jsonData.referencePeriod + ' ' + jsonData.description,
                                          jsonData.actionDate);

        addServiceCharges('service charges ' + jsonData.packageUsage.description,
                          jsonData.packageUsage.productId,
                          jsonData.packageUsage.packageId,
                          1);
        
        addDeviceCharges('device charges ' + jsonData.packageUsage.description,
                         jsonData.packageUsage.productId,
                         jsonData.packageUsage.packageId,
                         Decimal.valueOf(jsonData.packageUsage.activeDevices));
        
        addEndOfLifeCharges('eol charges ' + jsonData.packageUsage.description,
                            jsonData.packageUsage.productId,
                            jsonData.packageUsage.packageId,
                            Decimal.valueOf(jsonData.packageUsage.activeDevices));
        
        addOverageCharges('FUP overage charges ' + jsonData.packageUsage.description,
                          jsonData.messageUsage.productId,
                          jsonData.packageUsage.packageId,
                          Decimal.valueOf(jsonData.messageUsage.messageCount));
        
        return invoice.asJson();
    }
    
    // @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addServiceCharges(final String description, 
                                              final String productId, 
                                              final String packageId, 
                                              final Decimal qty) {
                                                  return invoice.addServiceCharges(description, productId, qty, 0.0);
                                              }
    
    // @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addDeviceCharges(final String description, 
                                             final String productId, 
                                             final String packageId, 
                                             final Decimal qty) {
                                                 return invoice.addDeviceCharges(description, 
                                                                                 productId, 
                                                                                 lorawanPackage.Quantity_Of_Devices__c,
                                                                                 lorawanPackage.Device_Rate__c);
                                             }
    
    // @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addEndOfLifeCharges(final String description, 
                                                final String productId, 
                                                final String packageId, 
                                                final Decimal qty) {
                                                    return invoice.addEndOfLifeCharges(description, 
                                                                                       productId, 
                                                                                       lorawanPackage.Quantity_Of_Devices__c, 
                                                                                       lorawanPackage.Device_Rate_after_commitment_end__c);
                                                }
    
    
    // @todo: Enhancement look up product description & charges from a pricebook.pricebookEntry.product
    public ThingParkInvoice addOverageCharges(final String description, 
                                              final String productId, 
                                              final String packageId, 
                                              final Decimal qty) {
                                                  Decimal messageAllowance = lorawanTenancy.Daily_Max_Average__c * lorawanTenancy.Total_Devices__c;
                                                  Decimal overage = qty - messageAllowance;
                                                  if (overage > 0) {
                                                      invoice.addOverageCharges(description, 
                                                                                   productId, 
                                                                                   overage, 
                                                                                   lorawanTenancy.Overage_Rate__c);
                                                  }
                                                  return invoice;
                                              }
    
    public void process(final ThingParkInvoiceJson jsonData) {
        System.debug('ThingParkBilling.process(ThingParkInvoiceJson) : ' + jsonData);
        
        ThingParkInvoice invoice = ThingParkInvoice.create(jsonData.accountId, 
                                                           jsonData.description, 
                                                           Date.parse(jsonData.actionDate));
        
        for(ThingParkInvoiceJson.Line invoiceLine : jsonData.lines) {
            System.debug('ThingParkBilling.process.invoiceLine : ' + invoiceLine);
            try {
                invoice.addLine(invoiceLine.description,
                                invoiceLine.productId,
                                Decimal.valueOf(invoiceLine.qty),
                                Decimal.valueOf(invoiceLine.unitPrice));
            } catch(Exception e) {
                system.debug('skipping : ' + e);
            }
        }
    }

    public Decimal unitPriceFor(final String packageId) {
        return Decimal.valueOf('0.00');
    }

    public LoRaWAN_Tenancy__c getTenancy(final String tenancyId) {
        List<LoRaWAN_Tenancy__c> lorawanTenancies = [
            SELECT
            	Id, Name, Account__c, Account__r.Id, Account__r.Name, Contact__c, 
             	Actility_Subscriber_ID__c, Push_to_Actility__c,
             	Daily_Max_Average__c, Overage_Rate__c, Total_Devices__c
            FROM LoRaWAN_Tenancy__c 
            WHERE id=:tenancyId
        	LIMIT 1];
        System.assert((lorawanTenancies.size() == 1));
        return lorawanTenancies.get(0);
    }

    public LoRaWAN_Package__c getPackage(final String packageId) {
        List<LoRaWAN_Package__c> lorawanPackages = [
            SELECT 
             	Id, Name, LoRaWAN_Tenancy__c, LoRaWAN_Tenancy__r.Id, LoRaWAN_Tenancy__r.Name, 
                Actility_Order_ID__c, Start_Date__c, Term__c, End_Date__c,
                Quantity_Of_Devices__c, Device_Rate__c, Device_Rate_after_commitment_end__c,
                is_Active__c, is_Cancelled__c, Status__c, Push_to_Actility__c
            FROM LoRaWAN_Package__c 
            WHERE id=:packageId
        	LIMIT 1];
        System.assert((lorawanPackages.size() == 1));
        return lorawanPackages.get(0);
    }
}