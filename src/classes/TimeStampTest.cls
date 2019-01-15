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
@isTest private class TimeStampTest extends AbstractTestCase {

    @isTest public static void testTimeStampDate() {
		String timeStamp = TimeStamp.date();
        Boolean result = Validator.isIsoDate(timeStamp);
    	System.assert(result, timeStamp);
    }

    @isTest public static void testTimeStampTime() {
		String timeStamp = TimeStamp.time();
        Boolean result = Validator.is24HourClock(timeStamp);
    	System.assert(result, timeStamp);
    }

    @isTest public static void testTimeStampTimeStamp() {
		String timeStamp = TimeStamp.timeStamp();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);
        System.debug('timeStamp = ' + timeStamp);
        // Boolean result = Validator.isIso(timeStamp);
    	// System.assert(result, timeStamp);
    	// System.assert(Validator.isIso(TimeStamp.timeStamp()));
    }
    
    @isTest public static void testTimeStampIso() {
		String timeStamp = TimeStamp.iso();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('timeStamp = ' + timeStamp);
    }

    @isTest public static void testTimeStampIsoDate() {
		String timeStamp = TimeStamp.isoDate();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('isoDate = ' + timeStamp);
        // System.assert(Validator.isIsoDate(TimeStamp.isoDate()));
    }

    @isTest public static void testTimeStampIsoTime() {
		String timeStamp = TimeStamp.isoTime();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('isoTime = ' + timeStamp);
    	// System.assert(Validator.isIsoTime(TimeStamp.isoTime()));
    }

    @isTest public static void testTimeStampUkDate() {
		String timeStamp = TimeStamp.ukDate();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('isoDate = ' + timeStamp);
        // System.assert(Validator.isIsoDate(TimeStamp.isoDate()));
    }

    @isTest public static void testTimeStampUkShortDate() {
		String timeStamp = TimeStamp.ukShortDate();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('isoDate = ' + timeStamp);
        // System.assert(Validator.isIsoDate(TimeStamp.isoDate()));
    }

    @isTest public static void testTimeStampUkTime() {
		String timeStamp = TimeStamp.ukTime();
		System.assert(String.isNotEmpty(timeStamp), timeStamp);        
        System.debug('isoTime = ' + timeStamp);
    	// System.assert(Validator.isIsoTime(TimeStamp.isoTime()));
    }
    
}