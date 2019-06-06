public virtual class AbstractJsonTemplate {

    public class InvalidReplacementException extends Exception {}

    protected String jsonTemplate { get; set;}
    protected Boolean failOnError = true;
    
    protected AbstractJsonTemplate(final String newJsonTemplate) {
        this.jsonTemplate = newJsonTemplate;
    }
    
    protected AbstractJsonTemplate replace(final String target, final String replacement) {
        if (jsonTemplate == null) {
			errorHandler('jsonTemplate is undefined');
        } else {
            if (target == null) {
                final String message = 'target cannot be null for replacement ' + replacement + ' to be performed';
				errorHandler(message);
            } else {
                if (replacement == null) {
                    String message = 'replacement cannot be null for target :' + target ;
					errorHandler(message);
                } else {
                    if (jsonTemplate.contains(target)) {
                        jsonTemplate = jsonTemplate.replace(target, replacement);
                    } else {
                        String message = 'target :' + target + ' not found, replacement :' + replacement + ' cannot be perfomed.';
                        errorHandler(message);
                    }
                }
            }
        }
        return this;
    }

	// trivial helper for fluent semantics
    protected String with(final String withValue) {
        return withValue;
    }
    
    private void errorHandler(final String errorMessage) {
		if (failOnError) {
			throw new InvalidReplacementException(errorMessage);
		} else {
			System.debug('[WARNING] ' + errorMessage);
		}
    }
}