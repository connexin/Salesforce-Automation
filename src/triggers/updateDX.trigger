// TODO: Redundant, remove when appropriate.
trigger updateDX on LoRaWAN_Subscriber__c (after insert, after update) {
	
	System.debug('Record count : ' + Trigger.New.size());

    if (Trigger.isInsert) {    
        for (LoRaWAN_Subscriber__c item : Trigger.New) {
            System.debug('LoRaWAN Subscriber (new)  :' + item);
        }
    }        

    if (Trigger.isUpdate) {    
        for (LoRaWAN_Subscriber__c item : Trigger.Old) {
        	System.debug('LoRaWAN Subscriber (old) :' + item);
        }
    }
}