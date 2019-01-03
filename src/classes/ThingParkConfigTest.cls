@isTest public class ThingParkConfigTest {

    @isTest static void testLatest() {
        Test.startTest();

        System.assert(ThingParkConfig.selectLatest() != null);

        Test.stopTest();        
    }
    
    @isTest static void testStable() {
        Test.startTest();
        
        System.assert(ThingParkConfig.selectStable() != null);        

        Test.stopTest();        
    }

}