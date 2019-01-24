public virtual class AbstractTestCase {

	public class TestFailException extends Exception {}
	public class AssumptionViolationException extends Exception {}

    public static void fail(final String message) {
        throw new TestFailException(message);
    }

    public static void assumeNotNull(final Object obj) {
        assumeNotNull(obj, 'AbstractTestCase:Given Object cannot be null.');
    }

    public static void assumeNotNull(final Object obj, final String message) {
        if (obj == null) {
            throw new AssumptionViolationException(message);
        }
    }

	public static void assumeTrue(final Boolean result) {
        assumeTrue(result, 'AbstractTestCase:Given expected True but was false.');
    }
    
	public static void assumeTrue(final Boolean result, final String message) {
        if (result == false) {
            throw new AssumptionViolationException(message);
        }
    }    

    public static void assertNotNull(final Object obj) {
        assertNotNull(obj, 'Object cannot be null');
    }

    public static void assertNotNull(final Object obj, final String message) {
        if (obj == null) {
            fail(message);
        }
    }

	public static void assertTrue(final Boolean result) {
        assertTrue(result, 'AbstractTestCase:Expected True but was false');
    }

	public static void assertTrue(final Boolean result, final String message) {
        if (result == false) {
            fail(message);
        }
    }

	public static void assertFalse(final Boolean result) {
        assertFalse(result, 'AbstractTestCase:Expected False but was true');
    }

	public static void assertFalse(final Boolean result, final String message) {
        if (result == true) {
        	fail(message);
        }
    }

    public static boolean verifyNotNull(final Object obj, final String message) {
        if (obj == null) {
            System.debug(message);
            return false;
        } else {
            return true;
        }
    }

    public static boolean verifyTrue(final Object obj, final String message) {
		if (obj == true) {
            return true;
        } else {
            System.debug(message);
            return false;
        }
    }    

    public static boolean verifyFalse(final Object obj, final String message) {
		if (obj == false) {
            return true;
        } else {
            System.debug(message);
            return false;
        }
    }    

    public static boolean verifyEqual(final Object expected, final Object actual, final String message) {
		if (actual.equals(expected)) {
            return true;
        } else {
            System.debug(message);
            return false;
        }
    }    

    public static boolean verifyDifferent(final Object expected, final Object actual, final String message) {
		if (actual.equals(expected) == false) {
            return true;
        } else {
            System.debug(message);
            return false;
        }
    }

    public static boolean verifyJson(final String jsonStr) {
        JSON.createParser(jsonStr);
		Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);
		assertNotNull(jsonData);
        System.debug('jsonData : ' + jsonData);
        return true;
    }    

	public static String asString(final Object obj) {
        assertNotNull(obj, 'Cannot convert a null object to String.');
        return JSON.serialize(obj);
    }

	public static String asString(final List<Object> collection) {
    	String str = '';
		for (Object item : collection) str += '\n' + (String) item;
        return str;
    }

	public static String asString(final Map<Object, Object> collection) {
    	String str = '';
		for (Object key : collection.keySet()) str += '\n' + (String) key + '=' + (String) collection.get(key) ;
        return str;
    }

	public static void log(final Object obj) {
        assertNotNull(obj, 'Cannot log a null object.');
        System.debug(asString(obj));
    }
}