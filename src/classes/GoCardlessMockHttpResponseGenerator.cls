@isTest
global class GoCardlessMockHttpResponseGenerator implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
    	
    	HTTPResponse res = new HttpResponse();
    	
    	String accountId = '';
    	
    	if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customers/CU0001' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customers/CU0002' && req.getMethod() == 'GET') {
    		res.setStatusCode(404);
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customers' && req.getMethod() == 'POST') {
    		JSONParser parser = JSON.createParser(req.getBody());
			while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'company_name') {
                	accountId = parser.getText();
                	break;
                }
            }
    		
    		res.setStatusCode(201);
    		res.setBody('{"customers":{"id":"CU0001","created_at":"2018-04-28T23:33:27.810Z","email":null,"given_name":null,"family_name":null,"company_name":"' + accountId + '","address_line1":null,"address_line2":null,"address_line3":null,"city":null,"region":null,"postal_code":null,"country_code":null,"language":"en","swedish_identity_number":null,"danish_identity_number":null,"metadata":{}}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customers/CU0001' && req.getMethod() == 'POST') {
    		JSONParser parser = JSON.createParser(req.getBody());
			while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'company_name') {
                	accountId = parser.getText();
                	break;
                }
            }
    		
    		res.setStatusCode(200);
    		res.setBody('{"customers":{"id":"CU0001","created_at":"2018-04-28T23:33:27.810Z","email":null,"given_name":null,"family_name":null,"company_name":"' + accountId + '","address_line1":null,"address_line2":null,"address_line3":null,"city":null,"region":null,"postal_code":null,"country_code":null,"language":"en","swedish_identity_number":null,"danish_identity_number":null,"metadata":{}}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customer_bank_accounts?limit=4&customer=CU0001' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    		res.setBody('{"customer_bank_accounts":[{"id":"BA0001","created_at":"2018-01-28T11:59:27.453Z","account_number_ending":"11","account_holder_name":"BOB TEST","bank_name":"BARCLAYS BANK PLC","currency":"GBP","country_code":"GB","metadata":{},"enabled":true,"links":{"customer":"CU0001"}}],"meta":{"cursors":{"before":null,"after":null},"limit":4}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customer_bank_accounts/BA0001' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    		res.setBody('{"customer_bank_accounts":{"id":"BA0001","created_at":"2018-01-28T11:59:27.453Z","account_number_ending":"11","account_holder_name":"BOB TEST","bank_name":"BARCLAYS BANK PLC","currency":"GBP","country_code":"GB","metadata":{},"enabled":true,"links":{"customer":"CU0001"}}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/payments?limit=4&customer=CU0001' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    		res.setBody('{"payments":[{"id":"PM0001","created_at":"2018-04-22T19:40:46.376Z","charge_date":"2018-04-26","amount":2500,"description":"S/2018/APR/455","currency":"GBP","status":"confirmed","amount_refunded":0,"reference":null,"metadata":{},"links":{"mandate":"MD0001","creditor":"CR0001"}}],"meta":{"cursors":{"before":null,"after":null},"limit":4}}');
    	} else if (
    		(req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/mandates?limit=4&customer_bank_account=BA0001'
    		|| req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/mandates?limit=4&customer=CU0001') && req.getMethod() == 'GET'
    		) {
    		res.setStatusCode(200);
    		res.setBody('{"mandates":[{"id":"MD0001","created_at":"2018-04-22T19:40:46.376Z","next_possible_charge_date":"2018-04-26","payments_require_approval":false,"reference":"877A97Q","scheme":"bacs","status":"active","metadata":{}}],"meta":{"cursors":{"before":null,"after":null},"limit":4}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/payments' && req.getMethod() == 'POST') {
    		res.setStatusCode(201);
    		res.setBody('{"payments":{"id":"PM0001","created_at":"2018-04-29T16:37:56.810Z","charge_date":"2018-05-03","amount":2500,"description":null,"currency":"GBP","status":"pending_submission","amount_refunded":0,"reference":null,"metadata":{},"links":{"mandate":"MD0001","creditor":"CR0001"}}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/mandates?limit=4&customer=CU0002' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    		res.setBody('{"mandates":[],"meta":{"cursors":{"before":null,"after":null},"limit":4}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/refunds?limit=50&payment=PM0001' && req.getMethod() == 'GET') {
    		res.setStatusCode(200);
    		res.setBody('{"refunds":[{"id":"RF0002","amount":500,"created_at":"2018-04-20T16:54:32.836Z","reference":"Connexin","metadata":{},"currency":"GBP","links":{"payment":"PM0001","mandate":"MD0001"}}],"meta":{"cursors":{"before":null,"after":null},"limit":50}}');
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/refunds' && req.getMethod() == 'POST') {
    		if (req.getBody().contains('"payment":"PM0002"')) {
    			res.setStatusCode(400);
    		} else {
    			res.setStatusCode(201);
    			res.setBody('{"refunds":{"id":"RF0001","amount":2000,"created_at":"2018-04-30T06:48:02.032Z","reference":"Connexin","metadata":{},"currency":"GBP","links":{"payment":"PM0001","mandate":"MD0001"}}}');
    		}
    	} else if (req.getEndpoint() == Go_Cardless__c.getValues('default').Api_Url__c + '/customer_bank_accounts/BA0001/actions/disable' && req.getMethod() == 'POST') {
            res.setStatusCode(200);
            res.setBody('{"customer_bank_accounts":{"id":"BA0001","created_at":"2018-01-28T11:59:27.453Z","account_number_ending":"11","account_holder_name":"BOB TEST","bank_name":"BARCLAYS BANK PLC","currency":"GBP","country_code":"GB","metadata":{},"enabled":true,"links":{"customer":"CU0001"}}}');
        }
    	
    	return res;
    	
    }
}