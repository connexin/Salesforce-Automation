public with sharing class TimeStamp {
    
    public static String date() {
        return Datetime.now().format('yyyy-MM-dd');
    }
    
    public static String ukDate() {
        return Datetime.now().format('E, dd MMM yyyy');
    }
    
    public static String ukShortDate() {
        return Datetime.now().format('dd/MM/yyyy');
    }
    
    public static String time() {
        return Datetime.now().format('HH:mm:ss');
    }
    
    public static String ukTime() {
        return Datetime.now().format('hh:mm:ss a');
    }
    
    public static String timeStamp() {
        return timeStamp('YYYY-MM-dd HH:mm:ss:SSS');
    }
    
    public static String timeStamp(String pattern) {
        return Datetime.now().format(pattern);
    }
    
    public static String isoDate() {
        return Datetime.now().format('YYYY-MM-dd');
    }
    
    public static String isoTime() {
        return Datetime.now().format('HH:mm:ss');
    }
    
    public static String iso() {
        String pattern = 'YYYY-MM-dd HH:mm:ss.SSSZZZ';
        return Datetime.now().format(pattern);
    }
    
    public static String fromPattern(final String pattern) {
        return Datetime.now().format(pattern);
    }
}