// This is a pretty dumb helper for making URI queries,
// by contatination and performs no validation.
public class QueryMaker {
    
    private String str = '?';

    public QueryMaker add(final String keyValue) {
        str += keyValue + '&';
        return this;
    }

    public QueryMaker add(final String key, final String value) {
        return add(key + '=' + value);
    }

    public String asString() {
        return str.left(str.length()-1);
    }
    
}