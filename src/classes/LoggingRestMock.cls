@isTest public class LoggingRestMock implements HttpCalloutMock {
    protected Integer statusCode;
    protected String statusString;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;

    public LoggingRestMock() {
        this.statusCode = Null;
        this.statusString = Null;
        this.bodyAsString = Null;
        this.bodyAsBlob = Null;
        this.responseHeaders = Null;
    }

    public LoggingRestMock(Integer statusCode, 
                           String statusString, 
                           String body,
                           Map<String, String> responseHeaders) {
                               this.statusCode = statusCode;
                               this.statusString = statusString;
                               this.bodyAsString = body;
                               this.bodyAsBlob = null;
                               this.responseHeaders = responseHeaders;
                           }

    public LoggingRestMock(Integer statusCode,
                           String statusString,
                           Blob body,
                           Map<String, String> responseHeaders) {
                               this.statusCode = statusCode;
                               this.statusString = statusString;
                               this.bodyAsBlob = body;
                               this.bodyAsString = null;
                               this.responseHeaders = responseHeaders;
                           }

    public HTTPResponse respond(HTTPRequest request) {        
        System.debug('Request' + request);
        HttpResponse response = new HttpResponse();
        if (statusCode != null) {
            response.setStatusCode(statusCode);
        }
        if (statusString != null) {
            response.setStatus(statusString);
        }
        if (bodyAsBlob != null) {
            response.setBodyAsBlob(bodyAsBlob);
        }
        if (bodyAsString != null) {
            response.setBody(bodyAsString);
        }        
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                response.setHeader(key, responseHeaders.get(key));
            }
        }
        return response;
    }
}