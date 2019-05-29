@isTest
global class SlackClassMockHTTPGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        System.assertEquals('https://hooks.slack.com/services/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', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
		return res;
    }
}