public virtual class AbstractThingParkTestCase extends AbstractTestCase {
	public static ThingParkRestMock createMock() {
        // Create the mock response based on a static resource
        ThingParkRestMock mock = new ThingParkRestMock();
        Test.setMock(HttpCalloutMock.class, mock);
        return mock;
    }
}