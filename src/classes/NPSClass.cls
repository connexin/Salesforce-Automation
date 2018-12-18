public class NPSClass {

    @future(callout=true)
    private static void sendNPSSurvey(String email, String apiKey) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setEndpoint('https://api.delighted.com/v1/people.json');
        req.setHeader('Authorization', 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(apiKey)));
        req.setMethod('POST');
        req.setBody('email=' + email);
        
        http.send(req);
    }
    
    public static void sendNPSHomeSurvey(String email) {
    	NPSClass.sendNPSSurvey(email, '2OSG2l6yQnlALNWmLKPs5NDiD9rOdK7l');
    }
    
    public static void sendNPSBusinessSurvey(String email) {
    	NPSClass.sendNPSSurvey(email, 'M4Pgdhc9sX3XCCkU8aISqQ4iuuUmBYiz');
    }
    
}