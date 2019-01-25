public virtual class AbstractJsonTemplate {
    
    protected String jsonTemplate { get; set;}
    
    protected AbstractJsonTemplate replace(final String target, final String replacement) {
        System.debug('target :' + target);
        System.debug('replacement :' + replacement);
        System.assert((target != null), 'replacement target cannot be null.');
        System.assert((replacement != null), 'replacement value cannot be null for :' + target);
        jsonTemplate = jsonTemplate.replace(target, replacement);
        return this;
    }
    
    protected String with(final String withValue) {
        return withValue;
    }
}