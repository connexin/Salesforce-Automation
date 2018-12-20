public with sharing class TimeStamp {

    public static String date() {
    	String timeStamp = Datetime.now().format('yyyy-MM-dd');
    	System.debug('yyyy-MM-dd = ' + timeStamp);
    	return timeStamp;
    }

	public static String ukDate() {
    	String timeStamp = Datetime.now().format('E, dd MMM yyyy');
    	System.debug('YYYY-MM-dd = ' + timeStamp);
    	return timeStamp;
    }

	public static String ukShortDate() {
    	String timeStamp = Datetime.now().format('dd/MM/yyyy');
    	System.debug('YYYY-MM-dd = ' + timeStamp);
    	return timeStamp;
    }

    public static String time() {
    	String timeStamp = Datetime.now().format('HH:mm:ss');
    	System.debug('HH:mm:ss = ' + timeStamp);
    	return timeStamp;
    }

    public static String ukTime() {
    	String timeStamp = Datetime.now().format('hh:mm:ss a');
    	System.debug('HH:mm:ss = ' + timeStamp);
    	return timeStamp;
    }

    public static String timeStamp() {
    	return timeStamp('YYYY-MM-dd HH:mm:ss:SSS');
    }

    public static String timeStamp(String pattern) {
    	String timeStamp = Datetime.now().format(pattern);
    	System.debug('timeStamp(' + pattern + ') = ' + timeStamp);
    	return timeStamp;
    }
    
    public static String isoDate() {
    	String timeStamp = Datetime.now().format('YYYY-MM-dd');
     	System.debug('YYYY-MM-dd = ' + timeStamp);
   	return timeStamp;
    }

    public static String isoTime() {
    	String timeStamp = Datetime.now().format('HH:mm:ss');
    	System.debug('HH:mm:ss = ' + timeStamp);
    	return timeStamp;
    }

	public static String iso() {
        String pattern = 'YYYY-MM-dd HH:mm:ss.SSSZZZ';
    	String timeStamp = Datetime.now().format(pattern);
    	System.debug(pattern + ' = ' + timeStamp);
    	return timeStamp;
    }

	public static String fromPattern(final String pattern) {
    	String timeStamp = Datetime.now().format(pattern);
    	System.debug(pattern + ' = ' + timeStamp);
    	return timeStamp;
    }
    
}