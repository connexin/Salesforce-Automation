public interface ConfigurationInterface {
    
    ConfigurationInterface selectCurrent();
    
    ConfigurationInterface selectStable();

    ConfigurationInterface selectLatest();

	String asString();

	void toLog();

}