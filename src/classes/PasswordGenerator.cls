public class PasswordGenerator {
    
    static String charSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

    // the Actility password requires some digits
	public static String actiltyPolicyPassword() {
        return randomPassword(12) + randomNumber(99);
    }

    public static String randomPassword() {
        return randomPassword(12);
    }
    
    public static String randomPassword(final Integer size) {
		System.debug('charSet : ' + charSet);        
        String password = '';
        for (Integer i = 0; i < 12; i++) {
            Integer rnd = randomNumber(charSet.length());
            password += charSet.mid(rnd,1);
        }
        return password;
    }

    public static Integer randomNumber(Integer size) {
        return (math.random() * size).intValue();
    }
    
}