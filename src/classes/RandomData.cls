public class RandomData {

    static String charSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

    // the Actility password policy requires two numeric digits
	public static String actiltyPolicyPassword() {
        return randomPassword() + randomNumber(9) + randomNumber(9);
    }

    public static String randomPassword() {
        return randomString(12);
    }
    
    public static String randomString(final Integer size) {
        String password = '';
        for (Integer i = 0; i < 12; i++) {
            Integer rnd = randomNumber(charSet.length());
            password += charSet.mid(rnd,1);
        }
        return password;
    }

    // not actually guanteed to be unique,
    // but the chance of collision is extremely low.
    public static String unique() {
        Blob cryptoKey = crypto.generateAesKey(256);
        return EncodingUtil.convertToHex(cryptoKey );
    }

    public static Integer randomNumber(Integer size) {
        return (math.random() * size).intValue();
    }
}