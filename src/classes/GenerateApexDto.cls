public class GenerateApexDto extends AbstractJsonTemplate {
    
    public GenerateApexDto() {
        super('SELECT FIELDS FROM TABLE WHERE CONDITION');
    }

    public GenerateApexDto(final String template) {
        super(template);
    }
    
}