@RestResource(urlMapping='/ThingParkBillingService/LorawanInvoice/*')
global with sharing class LorawanInvoiceService {
    
    @HttpGet
    global static Fiscal_Document__c[] doGet() {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);
        Integer idStart = request.requestURI.lastIndexOf('/')+1;
        String id = request.requestURI.substring(idStart);
        Fiscal_Document__c[] results = [SELECT Id, Name, Description__c, Account__c, Total_Value__c FROM Fiscal_Document__c];
        System.debug('Fiscal_Document__c' + results);
        return results;
    }
    
    @HttpPost
    global static String doPost(String name) {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);
        System.debug('request.params : ' + request.params);

		final String accountId = request.params.get('id');
        final String description = '';
        final String priceBookId = '';

		ThingParkInvoice invoice = ThingParkInvoice.create(accountId, description, priceBookId);

		final String productId = '';
        final Decimal totalDevices = 100;
        final Decimal deviceRate = 0.05;
		invoice.addDeviceCharges(accountId, productId, totalDevices, deviceRate);

        final Decimal qty = 60;
        final Decimal rate = 0.01;
		invoice.addServiceCharges(accountId, productId, qty, rate);

        final Decimal dailyMaxAverage = 60;
        final Decimal totalMsgs = 100;
        final Decimal overageRate = 0.05;
        final Decimal chargedMsgs = totalMsgs - dailyMaxAverage;
		invoice.addOverageCharges(accountId, productId, chargedMsgs, overageRate);

        final Decimal deviceRateAfterCommitment = 0.10;
		invoice.addEndOfLifeCharges(accountId, productId, totalDevices, deviceRateAfterCommitment);

        // Integer idStart = request.requestURI.lastIndexOf('/')+1;
        // String id = request.requestURI.substring(idStart);
        // System.debug('request.requestURI : ' + request.requestURI);
        
        // LoRaWAN_Subscriber__c subscriber = new LoRaWAN_Subscriber__c();
        // Name, Device_Rate__c, Account__c, Message_Rate__c, Commitment__c, Overage_Rate__c, Fair_Usage_Limit__c
        // subscriber.Name = name;
        // insert subscriber;
        // return subscriber.Id;

        return name;
    }

    @HttpDelete
    global static void doDelete() {
        RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);

        // Integer idStart = request.requestURI.lastIndexOf('/')+1;
        // String id = request.requestURI.substring(idStart);
        // System.debug('request.requestURI : ' + request.requestURI);

        // LoRaWAN_Subscriber__c subscriber = [SELECT Id, Name FROM LoRaWAN_Subscriber__c WHERE Id = :id];
        // System.debug('delete : ' + subscriber);
        // delete subscriber;
    }
}