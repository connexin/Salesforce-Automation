/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.extends AbstractTestCase 
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest private class ValidatorTest extends AbstractTestCase {

    @isTest public static void testIsParsable() {
        assertTrue(Validator.isParsable(System.now().format()));
        assertTrue(Validator.isParsable(TimeStamp.fromPattern('dd/MM/YYYY HH:mm')));
        assertFalse(Validator.isParsable(''));
        assertFalse(Validator.isParsable('aabb'));
    }

    @isTest public static void testWithRegEx() {
        assertTrue(Validator.withRegEx('a*b','aaab'));
        assertFalse(Validator.withRegEx('a*b','aabb'));
    }

    @isTest public static void testIs24HourClock() {
		String timeStamp = TimeStamp.time();
        assertTrue(Validator.is24HourClock(timeStamp), 'Invalid format :' + timeStamp);
        String[] valid = new String[] { '',
            '00:00:00','00:00:60','00:59:59','00:60:59','00:60:60',
            '12:00','12:01:01','12:00:00','12:00:60','12:59:59',
            '12:60:60','01:00:00','12:59:59','23:59:59','24:00:00','24:59:59'};
    }

    @isTest public static void testIs12HourClock() {
		String timeStamp = TimeStamp.ukTime();
        assertTrue(Validator.is12HourClock(timeStamp), 'Invalid format : ' + timeStamp);
        String[] valid = new String[] { '', '01:00', '11:59', '11:59 am', '11:59 pm', '11:59:00 AM', 
            '11:59:00 PM', '12:00:00', '12:59:00', '00:00:00', '00:00:60', '00:59:59', '00:60:59', 
            '00:60:60', '01:00:00', '12:59:59', '23:59:59', '24:00:00', '24:59:59'};
    }

    @isTest public static void testIsIsoDate() {
		String timeStamp = TimeStamp.isoDate();
        assertTrue(Validator.isIsoDate(timeStamp));
    }

	@isTest public static void testIsIsoTime() {
		String timeStamp = TimeStamp.isoTime();
        assertTrue(Validator.isIsoTime(timeStamp));
    }

    @isTest public static void testIsIso() {
        String isoDate = TimeStamp.iso();
        assertTrue(Validator.isIso(isoDate));
    }

	@isTest public static void testIsUkDate() {
    	assertTrue(Validator.isUkDate('10/08/1966'), '10/08/1966');
    	assertTrue(Validator.isUkDate('01/01/2018'), '01/01/2018');
    	assertTrue(Validator.isUkDate('31/12/2018'), '31/12/2018');
    	assertTrue(Validator.isUkDate('29/03/2018'), '29/03/2018');
    	assertFalse(Validator.isUkDate('00/00/2018'), '00/00/2018');
    	assertFalse(Validator.isUkDate('32/12/2018'), '32/12/2018');
    }

    @isTest public static void testIsEmail() {
        Map<String, Boolean> emails = new map<String, Boolean> { 
            'somebody@conexin.co.uk' => true,
            'somebody@conexin.co.uk' => true,
            'local@example.com' => true,
            'local@example.co.uk' => true,
            'local-part@example.com' => true,
            'local@example.com.foobar' => true,
            'foobar@local@example.com' => false };
		for(String email : emails.keySet()) {
            if (emails.get(email)) {
				assertTrue(Validator.isEmail(email));
            } else {
				assertFalse(Validator.isEmail(email));
            }
        }
    }

    @isTest public static void testIsUrl() {
        Map<String, Boolean> urls = new map<String, Boolean> {
            'somebody@conexin.co.uk' => false,
                'http://connexin.co.uk' => true,
                'http://www.connexin.co.uk' => true,
                'https://connexin.co.uk' => true,
                'https://www.connexin.co.uk'  => true,
                'example.com'  => true,
                'example.net'  => true,
                'www.example.com'  => true };                    
		for(String url : urls.keySet()) {
            if (urls.get(url)) {
				assertTrue(Validator.isUrl(url), 'Expected true, but was false for : ' + url);
            } else {
				assertFalse(Validator.isUrl(url), 'Expected false but was true for : ' + url);
            }
        }
    }

	@isTest public static void testIsIp4() {
        Map<String, Boolean> ips = new map<String, Boolean> {
            '0.0.0.0' => true, 
                '4.4.4.4' => true,
                '127.0.0.1'=> true,
                '10.0.0.0'=> true,
                '172.16.0.0'=> true,
                '192.16.0.0'=> true,
                '255.255.255.255'=> true,
                '256.256.256.256'=> false,
                '255.255.255.999'=> false };
		for(String ip : ips.keySet()) {
            if (ips.get(ip)) {
	        	assertTrue(Validator.isIp4(ip), 'Expected true, but was false for : ' + ip);
            } else {
	        	assertFalse(Validator.isIp4(ip), 'Expected false but was true for : ' + ip);
            }
        }
    }
}