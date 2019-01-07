@isTest public class PasswordGeneratorTest {
    
    @isTest static public void testRandom() {
        for(Integer i=0; i<10; i++) {
            Integer rnd = PasswordGenerator.randomNumber(99);
            System.debug('rnd : ' + rnd);
            System.assert (rnd > 0 && rnd < 100);
        }
    }

    @isTest static public void testPassword() {
        List<String> passwords = new List<String>();
        for(Integer i=0; i<100; i++) {
            String password = PasswordGenerator.randomPassword();
            System.debug('password : ' + password);
            System.assert(passwords.contains(password) == false);
            passwords.add(password);
        }
    }

    @isTest static public void testActiltyPolicyPassword() {
        List<String> passwords = new List<String>();
        for(Integer i=0; i<100; i++) {
            String password = PasswordGenerator.actiltyPolicyPassword();
            System.debug('password : ' + password);
            System.assert(passwords.contains(password) == false);
            passwords.add(password);
        }
    }    
}