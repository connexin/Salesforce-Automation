public virtual class AbstractTestCase {

    public static void assertNotNull(final Object obj) {
        System.assert(obj != null, 'Object cannot be null');
    }

    public static void assertNotNull(final Object obj, final String message) {
        System.assert(obj != null, message);
    }

    public static boolean verifyNotNull(final Object obj, final String message) {
        if (obj == null) {
            System.debug(message);
            return false;
        } else {
            return true;
        }
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