@isTest
global class NPSSurveyMockHTTPGenerator implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        System.assertEquals('https://api.delighted.com/v1/people.json', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        System.assertEquals('email=test@test.com', req.getBody());
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
		return res;
    }
}