<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>postcodeToUpperCase</fullName>
        <description>Automatically make a postcode upcase.</description>
        <field>Postcode__c</field>
        <formula>UPPER(Postcode__c)</formula>
        <name>Make Postcode upper case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
