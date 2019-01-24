public class RandomData {

    private static String charSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	private static List<String> maleNames = new List<String>{ 'Oliver', 'Harry', 'George', 'Noah', 'Jack', 'Jacob', 'Leo', 'Oscar', 'Charlie', 'Muhammad', 'Bob', 'John', 'Mark', 'Craig', 'Dan', 'Frank' };
	private static List<String> femaleNames = new List<String>{ 'Olivia', 'Amelia', 'Isla', 'Ava', 'Emily', 'Isabella', 'Mia', 'Poppy', 'Ellie', 'Ella', 'Lily', 'Alice', 'Carol', 'Eve', 'Sybil' };
	private static List<String> surnames = new List<String>{ 'Smith', 'Jones', 'Williams', 'Davies', 'Taylor', 'Brown', 'Evans', 'Thomas', 'Wilson', 'Roberts', 'Wright', 'Hughes', 'Johnson', 'Clark', 'Walker', 'Turner', 'Morgan', 'Lewis', 'Martin', 'James', 'Lee' };

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
    
    public static String randomForename() {
		List<String> names = new List<String>{};
		names.addAll(maleNames);
		names.addAll(femaleNames);
        return names.get(randomNumber(names.size()));
    }

    public static String randomSurname() {
        return surnames.get(randomNumber(surnames.size()));
    }
}