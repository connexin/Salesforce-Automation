public class PasswordGenerator {
    
    static String charSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

    // Create a pseudo random password that complies with 
    // the Actility password policy which requires two digits.
	public static String actiltyPolicyPassword() {
        return randomPassword() + randomNumber(99);
    }

    // Create a pseudo random password of 12 characters. 
    public static String randomPassword() {
        return randomString(12);
    }
    
    // Create a pseudo random string of N characters. 
    public static String randomString(final Integer size) {
		System.debug('charSet : ' + charSet);        
        String password = '';
        for (Integer i = 0; i < 12; i++) {
            Integer rnd = randomNumber(charSet.length());
            password += charSet.mid(rnd,1);
        }
        return password;
    }

    // Create a pseudo random number less than scale. 
    public static Integer randomNumber(Integer scale) {
        return (math.random() * scale).intValue();
    }
}