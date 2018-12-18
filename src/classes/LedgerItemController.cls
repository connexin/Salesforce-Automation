public class LedgerItemController {
	private ApexPages.StandardController standardController;
	
    public LedgerItemController(ApexPages.StandardController controller) {
        this.standardController = controller;
    }
    
    public PageReference cancelItem() {
        return standardController.cancel();   
    }
}