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
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest private class ValidatorTest {

    @isTest public static void testIsParsable() {
        System.assert(Validator.isParsable(System.now().format()));        
        System.assert(Validator.isParsable(TimeStamp.fromPattern('dd/MM/YYYY HH:mm')));
        System.assert(Validator.isParsable('') == false);
        System.assert(Validator.isParsable('aabb') == false);
    }
    
    @isTest public static void testWithRegEx() {
        System.assert(Validator.withRegEx('a*b','aaab'));
        System.assert(Validator.withRegEx('a*b','aabb') == false);
    }
    
    @isTest public static void testIs24HourClock() {
		String timeStamp = TimeStamp.time();
        Boolean result = Validator.is24HourClock(timeStamp);
    	System.assert(result, timeStamp);
		// 00:00:00
		// 12:00
		// 12:01:01
		// 12:00:00
		// 00:00:60
		// 12:00:60
		// 00:59:59
		// 12:59:59
		// 00:60:59
		// 00:60:59
		// 12:60:60
		// 00:60:60
		// 01:00:00
		// 12:59:59
		// 23:59:59
		// 24:00:00
		// 24:59:59    	
    }

    @isTest public static void testIs12HourClock() {
		String timeStamp = TimeStamp.ukTime();
        Boolean result = Validator.is12HourClock(timeStamp);
    	System.assert(result, timeStamp);
		// 01:00
		// 11:59
		// 11:59 am
		// 11:59 pm
		// 11:59:00 AM
		// 11:59:00 PM
		// 12:00:00
		// 12:59:00
		// 00:00:00
		// 00:00:60
		// 00:59:59
		// 00:60:59
		// 00:60:60
		// 01:00:00
		// 12:59:59
		// 23:59:59
		// 24:00:00
		// 24:59:59
    }

    @isTest public static void testIsIsoDate() {
		String timeStamp = TimeStamp.isoDate();
        Boolean result = Validator.isIsoDate(timeStamp);
    	System.assert(result, timeStamp);
    }

	@isTest public static void testIsIsoTime() {
		String timeStamp = TimeStamp.isoTime();
        Boolean result = Validator.isIsoTime(timeStamp);
    	System.assert(result, timeStamp);
    }

    @isTest public static void testIsIso() {
        String isoDate = TimeStamp.iso();
        Boolean result = Validator.isIso(isoDate);
    	System.assert(result, isoDate);
    }

	@isTest public static void testIsUkDate() {
    	System.assert(Validator.isUkDate('10/08/1966'), '10/08/1966');
    	System.assert(Validator.isUkDate('01/01/2018'), '01/01/2018');
    	System.assert(Validator.isUkDate('31/12/2018'), '31/12/2018');
    	// System.assert(Validator.isUkDate('00/00/2018') == false);
    	// System.assert(Validator.isUkDate('29/03/2018') == false);
    	// System.assert(Validator.isUkDate('32/12/2018') == false);
    }

    @isTest public static void testIsEmail() {
		String email = 'local-part@example.com';
        Boolean result = Validator.isEmail(email);
    	System.assert(result, email);
		// somebody@conexin.co.uk
		// local@example.com
		// local@example.co.uk
		// local-part@example.com
		// local@example.com.foobar
		// foobar@local@example.com    	
    }

}