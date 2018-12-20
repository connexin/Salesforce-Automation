trigger updateDX on LoRaWAN_Subscriber__c (after insert, after update) {
	
	if (Trigger.isInsert) {
        System.debug('Record count : ' + Trigger.New.size());
		// EmailManager.sendMail(	'martin.spamer@connexin.co.uk',
		// 						'Create LoRaWan Subscriber', 
        //             			recordCount + 'records(s) inserted.');        
    }

    for (LoRaWAN_Subscriber__c sub : trigger.new) {
        System.debug('LoRaWAN Subscriber  :' + sub);
    }

}