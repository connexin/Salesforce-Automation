@RestResource(urlMapping='/ThingParkBillingService/LorawanProducts/*')
global with sharing class LorawanProductService {
    	static String regExp = '\\/ThingParkBillingService\\/LorawanProducts\\/(\\d+)';

	@HttpGet
    global static Product2[] doGet() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        if (System.Pattern.matches(regExp, request.requestURI)) {
	        String id = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
	        return [SELECT Id, Name, Description, Family, ProductCode, IsActive FROM Product2 WHERE id=:id AND Family = 'LORAWAN' AND IsActive = true];
        } else {
	        return [SELECT Id, Name, Description, Family, ProductCode, IsActive FROM Product2 WHERE Family = 'LORAWAN' AND IsActive = true];
        }
    }
}