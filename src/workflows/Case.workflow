<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Case_Resolution_Email</fullName>
        <description>Send Case Resolution Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>support@connexin.co.uk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/Case_Resolution</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Case_Owner_to_Will</fullName>
        <field>OwnerId</field>
        <lookupValue>wk@connexin.co.uk</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Case Owner to Will</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auto Close Spam</fullName>
        <active>false</active>
        <formula>OR(
  FIND(&quot;envision.co.id&quot;, SuppliedEmail) &lt;&gt; 0,
  FIND(&quot;vdc.com.vn&quot;, SuppliedEmail) &lt;&gt; 0,
  FIND(&quot;kelesleroto.com&quot;, SuppliedEmail) &lt;&gt; 0
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Cityfibre to Will</fullName>
        <actions>
            <name>Change_Case_Owner_to_Will</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@cityfibre.com</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Customer Email on Case Resolution</fullName>
        <actions>
            <name>Send_Case_Resolution_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Send_Case_Closed_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
