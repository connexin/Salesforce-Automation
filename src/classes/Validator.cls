public with sharing class Validator {

	// Backslashes in the RegEx patterns must be escaped with double backslash for APEX.
	// the wrapRegEx function with add the ^ & $ for start and end of string.
	static final String TIME_24_PATTERN = '(0[0-9]|1[0-9]|2[0-3])(\\:)(0[0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])(\\:)(0[0-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])';
	static final String TIME_12_PATTERN = '(1[0-2]|0?[1-9]):[0-5][0-9](:[0-5][0-9])?(\\s?(am|AM|pm|PM|))?';
	static final String UK_DATE_PATTERN = '(((0[1-9]|(1|2)[0-9]|3[0-1])\\/(0(1|3|5|7|8)|1(0|2)))|((0[1-9]|(1|2)[0-9]|30)\\/(0(4|6|9)|11))|((0[1-9]|(1|2)[0-9])\\/02))\\/[0-9]{4}';
	static final String DATE_PATTERN = '((0[1-9])|(1\\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30)))))';    
	static final String ISO_DATE_PATTERN = '(20\\d{2})-(\\d{2})-(\\d{2})';
	static final String ISO_PATTERN = '(20\\d{2})-(\\d{2})-(\\d{2})[\\sT](\\d{2}):(\\d{2})(:\\d{2})?([:.]\\d{3})?([zZ+-]\\d{4})?';
    static final String EMAIL_PATTERN = '[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})';
    static final String URL_PATTERN = '(http(s)?://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ;,./?%&=]*)?';
    static final String IP4_PATTERN = '(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])';

    public static Boolean isParsable(final String candidate) {
        try {
            Datetime dt = DateTime.parse(candidate);
            // System.debug(candidate + ' is parsable to :' + dt);
			return true;
        } catch(TypeException expected) {
            System.debug(candidate + ' is not parsable.');
			return false;
		}
    }

    public static Boolean is24HourClock(final String candidate) {
    	return isIsoTime(candidate);
    }
    
    public static Boolean is12HourClock(final String candidate) {
    	return withRegEx(TIME_12_PATTERN, candidate);
    }

    public static Boolean isIsoDate(final String candidate) {
    	return withRegEx(ISO_DATE_PATTERN, candidate);
    }

    public static Boolean isIsoTime(final String candidate) {
    	return withRegEx(TIME_24_PATTERN, candidate);
    }

    public static Boolean isIso(final String candidate) {
    	return withRegEx(ISO_PATTERN, candidate);
    }
    
    public static Boolean isUkDate(final String candidate) {
    	return withRegEx(UK_DATE_PATTERN, candidate);
    }
    
    public static Boolean isEmail(final String candidate) {
    	return withRegEx(EMAIL_PATTERN, candidate);
    }

    public static Boolean isUrl(final String candidate) {
    	return withRegEx(URL_PATTERN, candidate);
    }

    public static Boolean isIp4(final String candidate) {
    	return withRegEx(IP4_PATTERN, candidate);
    }

    public static Boolean withRegEx(final String regExpStr, final String candidate) {
		Pattern regExp = Pattern.compile(regExpStr);
    	return withRegEx(regExp, candidate);
    }

    public static Boolean withRegEx(final Pattern regExp, final String candidate) {
    	Matcher matcher = regExp.matcher(candidate);
    	return matcher.matches();
    }
}