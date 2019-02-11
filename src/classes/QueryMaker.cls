// Dumb helper for making URI queries by contatination.
// Performs no validation.
public class QueryMaker {

    private String str = '?';

    public QueryMaker add(final String keyValue) {
        if (keyValue.endsWith('&')) {
            str += keyValue;
        } else {
            str += keyValue + '&';
        }
        return this;
    }

    public QueryMaker add(final String key, final String value) {
        return add(key + '=' + value);
    }

    public String asString() {
        if (str.endsWith('&')) {
            return str.left(str.length()-1); // chop off final &
        } else {
            return str;
        }
    }    
}