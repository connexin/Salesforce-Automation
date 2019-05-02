# ThingPark-Billing module for SalesForce

## Business Requirements

	On creation of a LORAWAN Tenancy in Salesforce, create a Subscriber in ThingPark
	On update of a LORAWAN Tenancy in Salesforce, update the Subscriber in ThingPark
	On Delete of LORAWAN Tenancy in Salesforce, Delete Subscriber in ThingPark
	
	On Creation of a of LORAWAN Package in Salesforce, create an Order in ThingPark
	On Update of a of LORAWAN Package in Salesforce, update an Order in ThingPark
	On Activate of a of LORAWAN Package in Salesforce, activate an Order  in ThingPark
	On Cancellation of a of LORAWAN Package in Salesforce, cancel an Order in ThingPark
	On Delete of a of LORAWAN Package in Salesforce. Delete an Order in ThingPark

	On overage of ThingPark usage, bill for excess messages

## Stories from Business Requirements

### Feature: Connexin can create, update and delete Subscribers in Salesforce

	As Connexin I want to:
		create, update & delete Subscribers in Salesforce
		create, update & delete Devices used by Subscribers in Salesforce
	So that:
		we can invoice for the service provided

### Feature: Connexin can create, update and delete a Subscriber's Devices in Salesforce

	As Connexin I want to:
		create, update & delete Subscriber's Tenancies in ThingPark
		create, update & delete Tenancy's Devices in ThingPark
	So that:
		we can account for a Subscriber's usage

### Feature: Connexin can bill customers for data usage

	As Connexin I want to:
		bill Subscribers for devices using the LoRaWAN network/ThingPark
		bill Subscribers for data using the LoRaWAN network/ThingPark
	So that:
		we get paid for the service provided

	create/update/delete Tenancies in ThingPark for Subscribers	
	create Tenancy in ThingPark


#### Scenario: Retrieve Usage Detail Records from Actility for billing 
	GIVEN the Month end billing point
	AND a SFTP connection is established to Actility
	AND Usage Data Records are available on Actility
	AND a SalesForce connection is available
	WHEN the Usage Data Records for a ThingPark Subscriber are processed
	THEN SalesForce will generate an invoice for each ThingPark Subscriber 
	AND each SalesForce invoice will include an line item for each tenancy 

#### Scenario: We bill monthly customers with a 5 years commitment 
	GIVEN a ThingPark Subscriber has a 5 years commitment 
	WHEN a month end occurs
	THEN the monthly invoice includes 1.00 £ month charge per device
	AND invoice includes Downlink messages charged @ 0.05 £ each

#### Scenario: We bill monthly customers with a 3 years commitment 
	GIVEN a ThingPark Subscriber has a 3 years commitment 
	WHEN a month end occurs
	THEN the monthly invoice includes 1.25 £ per month per device
	AND the invoice includes Downlink messages charged @ £0.05 £ each

#### Scenario: We bill monthly customers with a 1 years commitment 
	GIVEN a ThingPark Subscriber has a 1 years commitment 
	WHEN a month end occurs
	THEN the monthly invoice includes 1.50 £ per month per device
	AND the invoice includes Downlink messages charged @ 0.05 £ each

#### Scenario: We bill monthly customers with no commitment 
	GIVEN a ThingPark Subscriber has No commitment
	WHEN a month end occurs
	THEN the monthly invoice includes 2.00 £ per month per device 
	AND the invoice includes Downlink messages charged @ 0.05 £ each

#### Scenario: We do not bill customers that comply with our fair usage policy (FUP) 
	GIVEN the fair usage policy (FUP)
	AND messages are below or equal to 60 PPS/day
	WHEN a month end occurs
	THEN the monthly invoice includes no additional charges for devices
	AND the monthly invoice includes no additional message charges

#### Scenario: We bill customers that exceed our fair usage policy (FUP) 
	GIVEN the fair usage policy
	AND messages are above 60 PPS/day
	WHEN a month end occurs
	THEN the monthly invoice includes no additional charge for devices
	AND the monthly invoice includes overage to be charged at £0.05 a message above the 60 PPS/day for the month

#### Scenario: We bill customers that exceed our fair usage policy (FUP)
	GIVEN a customer has free of charge (FOC) tenancy
	WHEN a month end occurs
	THEN the monthly invoice includes no charge for devices
	AND the monthly invoice includes no charge for messages

### Feature: Manage ThingPark subscribers in SalesForce
	As Connexin
	I want to create/update/delete ThingPark Subscribers in Salesforce
	So that ...

#### Scenario: Create a new ThingPark Subscriber
	GIVEN a new ThingPark Subscriber
	WHEN ...
	THEN ...

#### Scenario: Update an existing ThingPark Subscriber
	GIVEN an existing  ThingPark Subscriber
	WHEN ...
	THEN ...

#### Scenario: Cancel an existing ThingPark Subscriber
	GIVEN an existing  ThingPark Subscriber
	WHEN ...
	THEN ...
	
### Feature: Manage ThingPark subscribers in SalesForce
	As Connexin
	I want to associate ThingPark Subscribers with Salesforce Customer Accounts
	So that ThingPark Subscribers are billed for their service

### Feature: Short describe of feature
	As Connexin
	I want to configure the data rates for a ThingPark Subscriber
	So that ThingPark Subscribers are correctly charged for their usage

### Feature: Short describe of feature
	As Connexin
	I want to configure FOC tenancies for a ThingPark Subscriber
	So that usage for (internal purposed?|promotions?) are accounted for

### Feature: Short describe of feature
	As a ThingPark Subscriber
	I want to provision an end user tenancy
	So that ... (business benefit?)

### Feature: Short describe of feature
	As a ThingPark Subscriber
	I want to configure an end user tenancy
	So that ... (business benefit?)

### Feature: Short describe of feature
	As a ThingPark Subscriber (implied necessary ?)
	I want to decommission an end user tenancy
	So that ... (business benefit?)
