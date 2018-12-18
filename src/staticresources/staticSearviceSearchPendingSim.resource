<?xml version="1.0" encoding="UTF-8"?>
<collection xmlns:ns2="http://www.gamma.co.uk/mobile/api/domain" xmlns:ns3="http://www.gamma.co.uk/mobile/api/connect" xmlns:ns4="http://www.gamma.co.uk/mobile/api/bespoke">
   <ns2:service id="221350" externalIdentifier="12345">
      <status>PENDING</status>
      <msisdn id="477646">
         <value>447458074900</value>
         <status>IN_USE</status>
         <portingStatus>NO_PORT</portingStatus>
         <portData />
         <channelPartner id="2469">
            <name>Connexin Ltd</name>
         </channelPartner>
         <operator>GAMMA</operator>
         <startDate>2016-01-28T12:59:19.417Z</startDate>
      </msisdn>
      <usim id="597205">
         <iccid>8944391000002170726</iccid>
         <status>IN_USE</status>
         <type>TRIPLESIM</type>
         <homeImsi>234390000317072</homeImsi>
         <roamingImsi>240075610317072</roamingImsi>
         <channelPartner id="2469">
            <name>Connexin Ltd</name>
         </channelPartner>
         <operator>GAMMA</operator>
         <startDate>2018-06-14T10:55:14.600+01:00</startDate>
         <pin1>0000</pin1>
         <pin2>1234</pin2>
         <puk1>86532433</puk1>
         <puk2>19053079</puk2>
      </usim>
      <handset>
         <imei>000000000000000</imei>
         <blacklisted>false</blacklisted>
      </handset>
      <tariff xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns2:tariff">
         <status>ACTIVE</status>
         <startDate>2018-07-17T10:57:09.630+01:00</startDate>
         <type>BUSINESS_EXTRA</type>
      </tariff>
      <configuration>
         <networkServices>
            <networkService>DATA</networkService>
            <networkService>FOURTH_GENERATION</networkService>
            <networkService>INTERNATIONAL_CALLING</networkService>
            <networkService>INTERNATIONAL_ROAMING</networkService>
			<networkService>DATA_WHEN_ROAMING</networkService>
			<networkService>PREMIUM_CONTENT</networkService>
         </networkServices>
         <networkBars>
            <networkBar>VOICEMAIL</networkBar>
			<networkBar>INCOMING_CALLS</networkBar>
			<networkBar>OUTGOING_CALLS</networkBar>
			<networkBar>INCOMING_SMS</networkBar>
			<networkBar>OUTGOING_SMS</networkBar>
			<networkBar>INCOMING_MMS</networkBar>
			<networkBar>OUTGOING_MMS</networkBar>
         </networkBars>
         <boltOns>
            <boltOn>DATA_2GB</boltOn>
            <boltOn>SMS</boltOn>
			<boltOn>SMART_BUSINESS_PACK</boltOn>
			<boltOn>EU_DAILY_BUSINESS_TRAVELLER</boltOn>
			<boltOn>ROW_BUSINESS_TRAVELLER</boltOn>
			<boltOn>INTERNATIONAL_VOICE_EUROPE_NORTH_AMERICA</boltOn>
			<boltOn>INTERNATIONAL_VOICE_ROW</boltOn>
			<boltOn>WORLDWIDE_DATA</boltOn>
			<boltOn>MULTINET</boltOn>
			<boltOn>DATA_SHARER_ENABLER</boltOn>
         </boltOns>
         <roamingConfiguration>
            <notificationOptions>
               <notificationOption>DATA_CAP</notificationOption>
			   <notificationOption>INITIAL_DATA</notificationOption>
			   <notificationOption>PERCENTAGE_LIMIT_REACHED</notificationOption>
            </notificationOptions>
            <euRoamingMaxCharge>MC_017_5</euRoamingMaxCharge>
            <rowRoamingMaxCharge>MC_550_0</rowRoamingMaxCharge>
         </roamingConfiguration>
      </configuration>
      <startDate>2018-07-17T10:58:01.560+01:00</startDate>
   </ns2:service>
</collection>