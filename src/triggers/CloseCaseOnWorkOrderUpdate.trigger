trigger CloseCaseOnWorkOrderUpdate on WorkOrder (after update) {
    
    // Query all the cases whose work order ID is the incoming work order
    List<Case> casesToUpdate = [select Id, Status 
                                from Case 
                                where Id IN (select caseId 
                                             from WorkOrder 
                                             where Id IN :Trigger.newMap.keySet() 
                                             and Status ='closed')];             
    // Set the case status to closed 
    for (Case aCase : casesToUpdate) {
        aCase.status = 'closed';
    }

    update casesToUpdate;
}