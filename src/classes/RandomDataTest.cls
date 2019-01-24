@isTest public class RandomDataTest extends AbstractTestCase {
    
    @isTest static public void testRandomNumber() {
        Integer[] distribution = new Integer[100];
        for(Integer i=0; i<1000 ; i++) {
            // the real data actual comes from elsewhere;
            // this just simulates it with random numbers.
            Integer num = (math.random() * 100).intValue();
            System.assert(num >= 0 && num < 100, 'Value out of expected range : ' + num);
            if (distribution[num] == null) {
                distribution[num] = 1;
            } else {
                distribution[num]++;
            }
        }
        
        // produce bar graph
        String barGraph = '\n';
        for(Integer num=0; num<100 ; num++) {
            barGraph += '' + num + ') ';
            for(integer i=0 ; i<distribution[num] ; i++) { barGraph += '+'; }
            barGraph += '\n';
        }
        System.Debug( barGraph );
    }
    
    @isTest static public void testRandomPassword() {
        Set<String> previous = new Set<String>();
        for(Integer i=0; i<100; i++) {
            String password = RandomData.randomPassword();
            System.assert(String.isNotBlank(password));
            System.assert(password.isAlphanumeric());
            System.assert(password.length() == 12);
            System.assert(previous.contains(password) == false, 'Unexpected duplicate password : ' + password + ' found in : ' + asString(previous));
            previous.add(password);
        }
    }
    
    @isTest static public void testActiltyPolicyPassword() {
        Set<String> previous = new Set<String>();
        for(Integer i=0; i<100; i++) {
            String password = RandomData.actiltyPolicyPassword();
            System.assert(String.isNotBlank(password));
            System.assert(password.isAlphanumeric());
            System.assert(password.length() == 14);
            System.debug('password : ' + password);
            System.assert(previous.contains(password) == false, 'Unexpected duplicate password : ' + password + ' found in : ' + asString(previous));
            previous.add(password);
        }
    }
    
    @isTest static public void testRandomString() {
        Set<String> previous = new Set<String>();
        for(Integer i=0; i<100; i++) {
            String rndStr = RandomData.randomString(12);
            System.assert(String.isNotBlank(rndStr));
            System.assert(rndStr.isAlphanumeric());
            System.assert(rndStr.length() == 12);
            System.assert(previous.contains(rndStr) == false, 'Unexpected duplicate random string :' + rndStr + 'found in :' + asString(previous));
            previous.add(rndStr);
        }
    }
    
    @isTest static public void testUnique() {
        Set<String> previous = new Set<String>();
        for(Integer i=0; i<10; i++) {
            String rndStr = RandomData.unique();
            System.assert(String.isNotBlank(rndStr));
            System.assert(rndStr.isAlphanumeric());
            System.assert(rndStr.length() == 64);
            System.debug('Unique string : ' + rndStr);
            System.assert(previous.contains(rndStr) == false, 'Unexpected duplicate unique value :' + rndStr + 'found in :' + asString(previous));
            previous.add(rndStr);
        }
    }

    @isTest static public void testRandomName() {
        for(Integer i=0; i<10; i++) {
            String randomName = RandomData.randomForename();
            System.assert(String.isNotBlank(randomName));
            System.assert(randomName.length() > 0);
            System.assert(randomName.isAlphanumeric());
        }
    }

    @isTest static public void testRandomSurname() {
        for(Integer i=0; i<10; i++) {
            String randomName = RandomData.randomSurname();
            System.assert(String.isNotBlank(randomName));
            System.assert(randomName.length() > 0);
            System.assert(randomName.isAlphanumeric());
        }
    }
}