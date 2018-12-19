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
      
    @isTest public static void testIs24HourClock() {
    	System.assert(Validator.is24HourClock(TimeStamp.time()));
    }
    
    @isTest public static void testIs12HourClock() {
    	System.assert(Validator.is12HourClock(TimeStamp.date()) == false);
    }

    @isTest public static void testIsIsoDate() {
    	System.assert(Validator.isIsoDate(TimeStamp.date()));
    }

    @isTest public static void testIsIso() {
    	System.assert(Validator.isIso(TimeStamp.iso()));
    }

	@isTest public static void testIsUkDate() {
    	System.assert(Validator.isUkDate('10/08/1966'));
    	System.assert(Validator.isUkDate('01/01/2018'));
    	System.assert(Validator.isUkDate('31/12/2018'));
    	System.assert(Validator.isUkDate('00/00/2018'));
    	System.assert(Validator.isUkDate('29/03/2018') == false);
    	System.assert(Validator.isUkDate('32/12/2018') == false);
    }

    @isTest public static void testIsEmail() {
    	System.assert(Validator.isEmail('local-part@example.com'));
    }

    @isTest public static void testWrapRegEx() {
    	System.assertEquals('^*$', Validator.wrapRegEx('*'));    	
    }
    
}