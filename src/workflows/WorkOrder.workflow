<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Work_Order_City_to_Account_City</fullName>
        <field>City</field>
        <formula>Account.BillingCity</formula>
        <name>Set Work Order City to Account City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Work_Order_Country_to_Account_Countr</fullName>
        <field>Country</field>
        <formula>Account.BillingCountry</formula>
        <name>Set Work Order Country to Account Countr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Work_Order_State_to_Account_State</fullName>
        <field>State</field>
        <formula>Account.BillingState</formula>
        <name>Set Work Order State to Account State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Work_Order_Street_to_Account_Street</fullName>
        <field>Street</field>
        <formula>Account.BillingStreet</formula>
        <name>Set Work Order Street to Account Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Work_Order_Zip_to_Account_Zip</fullName>
        <field>PostalCode</field>
        <formula>Account.BillingPostalCode</formula>
        <name>Set Work Order Zip to Account Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Get Address from Account</fullName>
        <actions>
            <name>Set_Work_Order_City_to_Account_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Work_Order_Country_to_Account_Countr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Work_Order_State_to_Account_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Work_Order_Street_to_Account_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Work_Order_Zip_to_Account_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
 NOT( ISNULL( Account.BillingAddress) ),
 ISNULL(Address )
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
