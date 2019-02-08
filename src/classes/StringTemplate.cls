public class StringTemplate {

    public class InvalidReplacementException extends Exception {}
    protected String stringTemplate { get; set;}
    protected String workingTemplate { get; set;}
    protected Boolean failOnError = true;

    public StringTemplate(final String template) {
        this.stringTemplate = template;
        this.workingTemplate = stringTemplate;
    }
    
    public String replaceAll(final Map<String, String> replacementValues) {
        final String workingTemplate = stringTemplate;
        for(String target : replacementValues.keySet()) {
			final String replacement = replacementValues.get(target);
			if (workingTemplate.contains(target)) {
            	replace(workingTemplate, target, replacement);
            } else {
                String message = 'target :' + target + ' not found, replacement :' + replacement + ' cannot be perfomed.';
                errorHandler(message);                
            }
        }
        return workingTemplate;
    }    

    public StringTemplate replace(final String target, final String replacement) {
        if (workingTemplate == null) {
			errorHandler('stringTemplate is undefined');
        } else {
            if (target == null) {
                final String message = 'target cannot be null for replacement ' + replacement + ' to be performed';
				errorHandler(message);
            } else {
                if (replacement == null) {
                    String message = 'replacement cannot be null for target :' + target ;
					errorHandler(message);
                } else {
                    if (workingTemplate.contains(target)) {
                        workingTemplate = workingTemplate.replace(target, replacement);
                    } else {
                        String message = 'target :' + target + ' not found, replacement :' + replacement + ' cannot be perfomed.';
                        errorHandler(message);
                    }
                }
            }
        }
        return this;
    }

    private StringTemplate replace(String workingTemplate, final String target, final String replacement) {
        if (workingTemplate == null) {
			errorHandler('stringTemplate is undefined');
        } else {
            if (target == null) {
                final String message = 'target cannot be null for replacement ' + replacement + ' to be performed';
				errorHandler(message);
            } else {
                if (replacement == null) {
                    String message = 'replacement cannot be null for target :' + target ;
					errorHandler(message);
                } else {
                    if (workingTemplate.contains(target)) {
                        workingTemplate = workingTemplate.replace(target, replacement);
                    } else {
                        String message = 'target :' + target + ' not found, replacement :' + replacement + ' cannot be perfomed.';
                        errorHandler(message);
                    }
                }
            }
        }
        return this;
    }

	// simple helper for improved semantic
    public String tag(final String tagName) {
        return '{'+tagName+'}';
    }
    
	// simple helper for improved semantic
    public String with(final String withValue) {
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