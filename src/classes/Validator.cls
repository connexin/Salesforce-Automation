public with sharing class Validator {

	// Backslashes in the RegEx patterns must be escaped with double backslash for APEX.
	static final String TIME_PATTERN_24 = '^(0[0-9]|1[0-9]|2[0-3])(\\:)(0[0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])(\\:)(0[0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])$';
	static final String TIME_PATTERN_12 = '^$';
	static final String YEAR_PATTERN = '((((19|20)(([02468][048])|([13579][26]))-02-29))|((20[0-9][0-9])|(19[0-9][0-9]))';
	static final String MONTH_PATTERN = '((((0[1-9])|(1[0-2]))';
	static final String UK_DATE_PATTERN = '(((0[1-9]|(1|2)[0-9]|3[0-1])\\/(0(1|3|5|7|8)|1(0|2)))|((0[1-9]|(1|2)[0-9]|30)\\/(0(4|6|9)|11))|((0[1-9]|(1|2)[0-9])\\/02))\\/[0-9]{4}';
	static final String DATE_PATTERN = '((0[1-9])|(1\\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30)))))';
	static final String ISO_DATE_PATTERN = YEAR_PATTERN + '-' + MONTH_PATTERN + '-' + DATE_PATTERN;
	static final String ISO_PATTERN = YEAR_PATTERN + '-' + MONTH_PATTERN + '-' + DATE_PATTERN + '[\\w|T]' + TIME_PATTERN_24;
    static final String EMAIL_PATTERN = '\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}';	

    public static Boolean is24HourClock(final String candidate) {
		Pattern regEx = Pattern.compile(wrapRegEx(TIME_PATTERN_24));    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }
    
    public static Boolean is12HourClock(final String candidate) {
		Pattern regEx = Pattern.compile(wrapRegEx(TIME_PATTERN_12));    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }

    public static Boolean isIsoDate(final String candidate) {
		Pattern regEx = Pattern.compile(wrapRegEx(ISO_DATE_PATTERN));    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }

    public static Boolean isIso(final String candidate) {
		Pattern regEx = Pattern.compile(wrapRegEx(ISO_PATTERN));    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }
    
    public static Boolean isUkDate(final String candidate) {
		Pattern regEx = Pattern.compile(wrapRegEx(UK_DATE_PATTERN));    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }
    
    public static Boolean isEmail(final String candidate) {
    	String emailPattern = '^\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}$';
		Pattern regEx = Pattern.compile(emailPattern);    	
    	Matcher matcher = regEx.matcher(candidate);
    	return matcher.matches();
    }

    public static String wrapRegEx(final String pattern) {
    	return '^' + pattern + '$';
    }
    
}