public with sharing class TimeStamp {

    public static String date() {
    	String timeStamp = Datetime.now().format('YYYY-MM-dd');
    	System.debug(timeStamp);
    	return timeStamp;
    }

    public static String time() {
    	String timeStamp = Datetime.now().format('HH:mm:ss');
    	System.debug(timeStamp);
    	return timeStamp;
    }

    public static String iso() {
    	String timeStamp = Datetime.now().format('YYYY-MM-dd HH:mm:ss');
    	System.debug(timeStamp);
    	return timeStamp;
    }

}