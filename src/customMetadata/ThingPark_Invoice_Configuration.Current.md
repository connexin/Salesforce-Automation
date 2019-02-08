<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Current</label>
    <protected>true</protected>
    <values>
        <field>Devices_line__c</field>
        <value xsi:type="xsd:string">Devices ${lorawanDevices}</value>
    </values>
    <values>
        <field>Messages_line__c</field>
        <value xsi:type="xsd:string">Messages ${lorawanMessages}</value>
    </values>
    <values>
        <field>Overage_line__c</field>
        <value xsi:type="xsd:string">Overage Services ${lorawanOverage}</value>
    </values>
    <values>
        <field>Services_line__c</field>
        <value xsi:type="xsd:string">Services ${lorawanPackageName}</value>
    </values>
    <values>
        <field>Version__c</field>
        <value xsi:type="xsd:string">v1</value>
    </values>
</CustomMetadata>
