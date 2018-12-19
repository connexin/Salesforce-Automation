trigger updateDX on LoRaWAN_Subscriber__c (after insert, after update) {
    for (LoRaWAN_Subscriber__c sub : trigger.new) {
        System.debug('LoRaWAN Subscriber  :' + sub);
    }
}