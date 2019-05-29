@isTest public class CloseWorkOrderTriggerTest {
    
    @isTest static void validateWO() {
        Case testCase = new Case();
        testCase.Origin ='Phone';
        testCase.Status ='New';
        insert(testCase);

        WorkOrder workOrder = new WorkOrder();
        workOrder.Subject = 'Test WorkOrder';
        workOrder.Status ='Closed';
        workOrder.CaseId = testCase.Id;
        insert(workOrder);
        update(workOrder);

        Case actualCase = [SELECT Status from Case where id= :testCase.Id];
        System.assertEquals('Closed', actualCase.Status);
    }
}