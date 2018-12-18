@isTest
private class LedgerItemControllerTestClass {
    static testMethod void testStandardController() {
        LedgerItemController controller = new LedgerItemController(new ApexPages.StandardController(new Ledger_Item__c()));
        controller.cancelItem();
    }
}