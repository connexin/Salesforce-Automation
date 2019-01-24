public virtual class AbstractThingParkTestCase extends AbstractTestCase {
    private static ThingParkRestMock mock;
    public static ThingParkRestMock createMock() {
        if (mock == null) {
            // Create the mock response based on a static resource
            mock = new ThingParkRestMock();
            Test.setMock(HttpCalloutMock.class, mock);
        }
        return mock;
    }
}