@RestResource(urlMapping='/ThingParkBillingService/LorawanInvoice/*')
global with sharing class LorawanInvoiceService {
    
    @HttpGet
    global static Fiscal_Document__c[] doGet() {
        System.debug('LorawanInvoiceService.doGet');
        final RestRequest request = RestContext.request;
        System.debug('request : ' + request);
        System.debug('request.requestURI : ' + request.requestURI);
        final Integer idStart = request.requestURI.lastIndexOf('/')+1;
        final String id = request.requestURI.substring(idStart);
        final Fiscal_Document__c[] results = [SELECT Id, Name, Description__c, Account__c, Total_Value__c FROM Fiscal_Document__c];
        System.debug('Fiscal_Document__c' + results);
        return results;
    }
    
    @HttpPost
    global static String doPost() {
        System.debug('LorawanInvoiceService.doPost : ');
        final RestRequest request = RestContext.request;
        System.debug('LorawanInvoiceService.request : ' + request);
        System.debug('LorawanInvoiceService.request.requestURI : ' + request.requestURI);
        System.debug('LorawanInvoiceService.request.params : ' + request.params);
        System.debug('LorawanInvoiceService.request.requestBody : ' + request.requestBody);

		//final String accountId = request.params.get('accountId');
        //System.debug('accountId : ' + accountId);

        //final String description = request.params.get('description');
        //System.debug('description : ' + description);

        //final String invoiceDate = request.params.get('invoice_date');
        //System.debug('invoiceDate : ' + invoiceDate);
        
        //final String dueDate = request.params.get('due_date');
        //System.debug('dueDate : ' + dueDate);        
        
        //final String lines = request.params.get('lines');
        //System.debug('lines : ' + lines);

		Map<String, Object> invoiceData = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.toString());
        for(String fieldName : invoiceData.keySet()) {
            System.debug('' + fieldName + ' = ' + invoiceData.get(fieldName));
        }

        final String accountId = '001n000000TylkYAAR';
		final String description = 'LoranwanInvoice Service';
		ThingParkInvoice invoice = ThingParkInvoice.create(accountId, description);

		final String productId = '';
        final Decimal totalDevices = 100;
        final Decimal deviceRate = 0.05;
		invoice.addDeviceCharges(productId, totalDevices, deviceRate);

        final Decimal qty = 60;
        final Decimal rate = 0.01;
		invoice.addServiceCharges(productId, qty, rate);

        final Decimal dailyMaxAverage = 60;
        final Decimal totalMsgs = 100;
        final Decimal overageRate = 0.05;
        final Decimal chargedMsgs = totalMsgs - dailyMaxAverage;
		invoice.addOverageCharges(productId, chargedMsgs, overageRate);

        final Decimal deviceRateAfterCommitment = 0.10;
		invoice.addEndOfLifeCharges(productId, totalDevices, deviceRateAfterCommitment);

        // Integer idStart = request.requestURI.lastIndexOf('/')+1;
        // String id = request.requestURI.substring(idStart);
        // System.debug('request.requestURI : ' + request.requestURI);
        
        // LoRaWAN_Subscriber__c subscriber = new LoRaWAN_Subscriber__c();
        // Name, Device_Rate__c, Account__c, Message_Rate__c, Commitment__c, Overage_Rate__c, Fair_Usage_Limit__c
        // subscriber.Name = name;
        // insert subscriber;
        // return subscriber.Id;

        return('{"status":"success"}');
    }

    @HttpDelete
    global static void doDelete() {
        final RestRequest request = RestContext.request;
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