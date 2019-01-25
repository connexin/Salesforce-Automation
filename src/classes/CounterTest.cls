@isTest public class CounterTest extends AbstractTestCase {
    @isTest static void testCounter() {
		Test.startTest();
		System.assertEquals(1, Counter.visits);
		System.assertEquals(2, Counter.visits);
		Test.stopTest();
    }
}