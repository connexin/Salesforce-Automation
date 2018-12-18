public class StripeAPI {
    
    public static StripeCharge createCharge(Integer amount, String token, String description) {
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setMethod('POST');
        req.setEndpoint(Stripe__c.getValues('default').Api_Url__c + '/charges');
        req.setHeader('Authorization', 'Bearer ' + Stripe__c.getValues('default').Api_Key__c);
        req.setHeader('Stripe-Version', Stripe__c.getValues('default').Api_Version__c);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Idempotency-Key', StripeAPI.getIdempotentKey());
        req.setBody('amount=' + String.valueOf(amount) + '&currency=' + Stripe__c.getValues('default').Currency__c + '&source=' + token + '&description=' + description);
        
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) {
        	//Add Debug Code for Errors
        	StripeCharge charge = new StripeCharge('', 0, 0);
            charge.error = true;
            charge.error_desc = 'Stripe Error: ' + res.getStatusCode() + ' - Payment Request Failed';
            return charge;
        }
        
        //Charge Creation Successful
        StripeCharge charge;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
        	if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
        		charge = (StripeCharge)parser.readValueAs(StripeCharge.class);
        		parser.skipChildren();
        	}
        }
        charge.error = false;
        charge.error_desc = '';
        return charge;
    }
    
    public static StripeCharge createRefund(Decimal amount, String chargeId) {
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setMethod('POST');
        req.setEndpoint(Stripe__c.getValues('default').Api_Url__c + '/refunds');
        req.setHeader('Authorization', 'Bearer ' + Stripe__c.getValues('default').Api_Key__c);
        req.setHeader('Stripe-Version', Stripe__c.getValues('default').Api_Version__c);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Idempotency-Key', StripeAPI.getIdempotentKey());
        req.setBody('amount=' + String.valueOf(amount) + '&charge=' + chargeId + '&reason=requested_by_customer');
        
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) {
        	//Add Debug Code for Errors
        	StripeCharge refund = new StripeCharge('', 0, 0);
            refund.error = true;
            refund.error_desc = 'Stripe Error: ' + res.getStatusCode() + ' - Refund Request Failed';
            return refund;
        }
        
        //Charge Creation Successful
        StripeCharge refund;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
        	if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
        		refund = (StripeCharge)parser.readValueAs(StripeCharge.class);
        		parser.skipChildren();
        	}
        }
        refund.error = false;
        refund.error_desc = '';
        return refund;
    }
    
    public static String getPublicAPIKey() {
        return Stripe__c.getValues('default').Public_Api_Key__c;
    }
    
    public static String getIdempotentKey() {
        return  String.valueOf(Crypto.getRandomInteger());
        /*String idempotentKey = this.payment.Amount__c + '-' + this.payment.Account__c;
        if(this.documentId != null) {
            if(this.payment.Description__c != null) {
                idempotentKey = this.payment.Amount__c + '-' + this.payment.Description__c;
            } else {
            	Fiscal_Document__c fd = [SELECT Reference__c FROM Fiscal_Document__c WHERE Id = :this.documentId];
                idempotentKey = this.payment.Amount__c + '-' + fd.Reference__c;
            }
        } 
        return idempotentKey;*/
    }
}