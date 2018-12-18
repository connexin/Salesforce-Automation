@isTest
global class StripeMockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
    	
    	HTTPResponse res = new HttpResponse();
    	
    	if (req.getEndpoint() == Stripe__c.getValues('default').Api_Url__c + '/charges' && req.getMethod() == 'POST') {
    		if (req.getBody().contains('source=test2')) {
    			res.setStatusCode(400);
    		} else {
    			res.setStatusCode(200);
    			res.setBody('{"id": "ch_CloemWv7bty5tG", "amount": 2500, "amount_refunded": 0}');
    		}
    	} else if (req.getEndpoint() == Stripe__c.getValues('default').Api_Url__c + '/refunds' && req.getMethod() == 'POST') {
    		if (req.getBody().contains('charge=test2')) {
    			res.setStatusCode(400);
    		} else {
    			res.setStatusCode(200);
    			res.setBody('{"id": "re_CjDGMLDjpoLBIS"}');
    		}
    	}
    	
    	return res;
    	
    }
}