public class CreateWorkOrderLineItem {
    
    public WorkOrderLineItem createWorkOrderLineItem() {
        WorkOrder workOrder = new WorkOrder();
        workOrder.subject ='Residential Broadband Installation';
        insert workOrder;

        WorkOrderLineItem workOrderLineItem = new WorkOrderLineItem();
        workOrderLineItem.workOrderId = workOrder.Id;
        workOrderLineItem.description = 'abcd';

        return workOrderLineItem;
    }
}