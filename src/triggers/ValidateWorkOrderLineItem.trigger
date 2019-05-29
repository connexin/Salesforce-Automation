trigger ValidateWorkOrderLineItem on WorkOrder (before update) {
    
    // Create a map of work order Id to work orders where status is closed
    Map<String, WorkOrder> mapWoToId = new Map<String, WorkOrder>();
    for(WorkOrder wordOrder : Trigger.New) {
        if (wordOrder.Status =='Closed') {
            mapWoToId.put(wordOrder.Id, wordOrder);
        }
    }
    
    // Select the work order line items which are not closed for the list of work orders
    List<WorkOrderLineItem> woLineItemList = [select woli.Status, woli.workOrderId
                                              from WorkOrderLineItem woli 
                                              where woli.WorkOrderId IN :mapWoToId.keySet() 
                                              and woli.Status != 'Closed'];
    
    // Set the error message for the parent work order    
    for(WorkOrderLineItem wordOrderLineItem : woLineItemList) {
        WorkOrder parentWO = mapWoToId.get(wordOrderLineItem.workOrderId);
        String message = 'You cannot close work order until all lines are closed.' + wordOrderLineItem.Description;
        parentWO.addError(message);
    } 
}