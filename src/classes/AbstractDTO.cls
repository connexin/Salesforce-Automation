public virtual class AbstractDTO {

	public SObject asSObject(Type objectType) {
    	return (SObject)JSON.deserialize(this.asJson(), objectType);
	}

    public String asJson() {
        return JSON.serialize(this);
    }

    public void toLog() {
        System.debug(asJson());
    }

}