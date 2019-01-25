@isTest public class MockTestCase extends AbstractTestCase {

    @isTest static void testFailException() {
        try {
        	fail('Expected Failure');
        } catch(Exception expectedException) {
            System.debug('expectedException');
            return;
        }
        fail('Unexpected outcome for : fail("Expected Failure")');
    }

	@isTest static void testAssertNotNull() {
        assertNotNull('Not Null');
    }

	@isTest static void testAssertNotNullWithNull() {
        try {
        	Object obj = null;
        	assertNotNull(obj);
        	// System.assert(obj != null, 'Object cannot be null');            
        } catch(Exception expectedException) {
            System.debug('expectedException');
        }
    }
}