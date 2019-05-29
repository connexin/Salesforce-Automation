public class GammaMobile_ReferenceData {
    public static String xsd_url {
        get {
            return 'TBC';
        }
    }
    
    public static Map<String, String> refBoltOn {
        get {
            return new Map<String, String>{ 
                	'2 GB Data PCM' => 'DATA_2GB',
                    '3 GB Data PCM' => 'DATA_3GB',
                    '5 GB Data PCM' => 'DATA_5GB',
                    '10 GB Data PCM' => 'DATA_10GB',
                    '20 GB Data PCM' => 'DATA_20GB',
                    'Business SMS 250' => 'SMS',
                    'Smart Business Pack (combining: Non-Geographic 250, MMS 50 & International SMS 50)' => 'SMART_BUSINESS_PACK',
                    'EU daily Business Traveller' => 'EU_DAILY_BUSINESS_TRAVELLER',
                    'ROW Business 7 day Traveller' => 'ROW_BUSINESS_TRAVELLER',
                    'Intl Voice Europe & North America' => 'INTERNATIONAL_VOICE_EUROPE_NORTH_AMERICA',
                    'Intl Voice Rest Of World' => 'INTERNATIONAL_VOICE_ROW',
                    'Worldwide Data 250MB' => 'WORLDWIDE_DATA',
                    'MultiNet' => 'MULTINET',
                    'Data Sharer Enabler' => 'DATA_SHARER_ENABLER'
            };
        }
    }
    
    public static Map<String, String> refBoltOn_Data {
        get {
            return new Map<String, String>{ 
                	'2 GB Data PCM' => 'DATA_2GB',
                    '3 GB Data PCM' => 'DATA_3GB',
                    '5 GB Data PCM' => 'DATA_5GB',
                    '10 GB Data PCM' => 'DATA_10GB',
                    '20 GB Data PCM' => 'DATA_20GB'
            };
        }
    }
    
    public static Map<String, String> refBoltOn_Business {
        get {
            return new Map<String, String>{ 
                    'Business SMS 250' => 'SMS',
                    'Smart Business Pack (combining: Non-Geographic 250, MMS 50 & International SMS 50)' => 'SMART_BUSINESS_PACK',
                    'EU daily Business Traveller' => 'EU_DAILY_BUSINESS_TRAVELLER',
                    'ROW Business 7 day Traveller' => 'ROW_BUSINESS_TRAVELLER',
                    'Intl Voice Europe & North America' => 'INTERNATIONAL_VOICE_EUROPE_NORTH_AMERICA',
                    'Intl Voice Rest Of World' => 'INTERNATIONAL_VOICE_ROW',
                    'Worldwide Data 250MB' => 'WORLDWIDE_DATA',
                    'MultiNet' => 'MULTINET',
                    'Data Sharer Enabler' => 'DATA_SHARER_ENABLER'
            };
        }
    }
    
    public static Map<String, String> refEuRoamingMaxCharge {
        get {
            return new Map<String, String>{
                '0.044p charged per MB roamed in EU' => 'MC_004_4', 
                '0.089p charged per MB roamed in EU' => 'MC_008_9', 
                '0.175p charged per MB roamed in EU' => 'MC_017_5'
            };
        }
    }
    
    public static Map<String, String> refAdvancedFundingType {
        get {
            return new Map<String, String>{
                'Level 1 hardware funding credit' => 'LEVEL_1',
                'Level 2 hardware funding credit' => 'LEVEL_2',
                'Level 3 hardware funding credit' => 'LEVEL_3'
            };
        }
    }
        
    public static Map<String, String> refMsisdnStatus {
        get {
            return new Map<String, String>{
            		'Free to use for a new service provision' => 'AVAILABLE',
                    'Assigned to a live Gamma service' => 'IN_USE',
                    'MSISDN has been quarantined on the Gamma network' => 'QUARANTINED',
                    'Being used for a Port In process' => 'RESERVED_FOR_PORT_IN',
                    'Port was cancelled, MSISDN back to normal usage' => 'PORT_CANCELLED'
            };    
        }
    }
    
    public static MAP<String, String> refNetworkBar {
        get {
            return new Map<String, String>{
                	'Voicemail' => 'VOICEMAIL',
                    'Receive incoming calls' => 'INCOMING_CALLS',
                    'Make outgoing calls' => 'OUTGOING_CALLS',
                    'Receive incoming SMS messages' => 'INCOMING_SMS',
                    'Send outgoing SMS messages' => 'OUTGOING_SMS',
                    'Receive incoming MMS messages' => 'INCOMING_MMS',
                    'Send outgoing MMS messages' => 'OUTGOING_MMS'
            };
        }
    }
    
    public static MAP<String, String> refNetworkService {
        get {
            return new Map<String, String>{
                	'Mobile Data' => 'DATA',
                    'Data Roaming' => 'DATA_WHEN_ROAMING',
                    'Premium Content' => 'PREMIUM_CONTENT',
                    'International Calling' => 'INTERNATIONAL_CALLING',
                    'International Roaming' => 'INTERNATIONAL_ROAMING',
                    'Adult Content Services' => 'ADULT_CONTENT',
                    '4G' => 'FOURTH_GENERATION'
            };
        }
    }
    
    public static MAP<String, String> refNotificationOption {
        get {
            return new Map<String, String>{
                	'Data Cap & Data Cap reached message' => 'DATA_CAP',
                    'Initial Data Notification message' => 'INITIAL_DATA',
                    '80% Data Cap reached message' => 'PERCENTAGE_LIMIT_REACHED'
            };
        }
    }
    
    public static Map<String, String> refOperator {
        get {
            return new Map<String, String>{
                	'Assigned to the Vodafone Network Operator' => 'VODAFONE',
                	'Assigned to the Gamma Network Operator' => 'GAMMA'
            };
        }
    }
    
    public static Map<String, String> refPortingStatus {
        get {
            return new Map<String, String>{
                	'No Port requested on service' => 'NO_PORT',
                    'Request to Close the port has been sent to MNP' => 'PORT_IN_CLOSED_SENT',
                    'Port Entry has been Locked on MNP' => 'PORT_IN_LOCKED',
                    'Port In has completed on all systems' => 'PORTED_IN',
                    'Service porting out as a PAC assigned to it' => 'PORT_OUT_PAC_ASSIGNED',
                    'Port Entry has been Closed on MNP' => 'PORT_OUT_CLOSED',
                    'Port Entry has been Locked on MNP' => 'PORT_OUT_LOCKED',
                    'Port Out has completed on all systems' => 'PORTED_OUT',
                    'Waiting to Port In' => 'AWAITING_PORT_IN',
                    'Send a Close request to MNP for Port In' => 'SEND_PORT_IN_CLOSED',
                    'Failure in the porting process' => 'PORTING_FAILED',
                    'Port has been cancelled' => 'PORT_CANCELLED',
                    'Port Out has been locked automatically on MNP' => 'PORT_OUT_AUTO_LOCKED',
                    'On Net Migration across VF network pending' => 'PENDING_VF_ON_NET_MIGRATION',
                    'On Net Migration across VF network failed' => 'FAILED_VF_ON_NET_MIGRATION',
                    'Export process pending' => 'PENDING_EXPORT',
                    'Export process completed' => 'EXPORTED',
                    'Port In process schedule failed on Redknee system' => 'FAILED_RK_PORT_IN_SCHEDULE',
                    'Port Out process schedule failed on Redknee system' => 'FAILED_RK_PORT_OUT_SCHEDULE'
            };
        }
    }
    
    public static Map<String, String> refRepaymentPeriod {
        get {
            return new Map<String, String>{
                	'12 months' => 'TWELVE_MONTHS',
                    '24 months' => 'TWENTY_FOUR_MONTHS',
                    '36 months' => 'THIRTY_SIX_MONTHS'
            };
        }
    }
    
    public static Map<String, String> refRequestStatus {
        get {
            return new Map<String, String>{
                	'Currently being processed' => 'PROCESSING',
                    'Waiting for a response' => 'PENDING',
                    'Completed correctly' => 'SUCCESSFUL',
                    'Did not pass validation checks for operation type' => 'VALIDATION_FAILED',
                    'Resource required could not be established' => 'NOT_FOUND',
                    'An issue has occurred which was unforeseen by the system' => 'UNHANDLED_EXCEPTION'
            };
        }
    }
    
    public static Map<String, String> refRowRoamingMaxCharge {
        get {
            return new Map<String, String>{
                	'£3.00 charged per MB roamed when outside EU (ROW)' => 'MC_300_0',
                    '£5.00 charged per MB roamed when outside EU (ROW)' => 'MC_500_0',
                    '£5.50 charged per MB roamed when outside EU (ROW)' => 'MC_550_0',
                    '£6.00 charged per MB roamed when outside EU (ROW)' => 'MC_600_0',
                    '£6.50 charged per MB roamed when outside EU (ROW)' => 'MC_650_0',
                    '£7.00 charged per MB roamed when outside EU (ROW)' => 'MC_700_0',
                    '£7.50 charged per MB roamed when outside EU (ROW)' => 'MC_750_0'
            };
        }
    }
    
    public static Map<String, String> refTariffStatus {
        get {
            return new Map<String, String>{
                	'Tariff is active' => 'ACTIVE',
                    'Tariff is no longer active' => 'CEASED'
            };
        }
    }
    
    public static Map<String, String> refTariffType {
        get {
            return new Map<String, String>{
                	'The Business Basic tariff' => 'BUSINESS_BASIC',
                    'The Business Extra Unlimited Voice & SMS tariff' => 'BUSINESS_EXTRA',
                    'The Mobile Broadband (data only) tariff' => 'MOBILE_BROADBAND'
            };
        }
    }
    
    public static Map<String, String> refServiceStatus {
        get {
            return new Map<String, String>{
                	'Service is set up, occurs after provisioning' => 'SETUP',
                    'Service is active on Gamma network' => 'ACTIVE',
                    'Service has been ceased on the Gamma network' => 'CEASED',
                    'Service is suspended on the Gamma network' => 'SUSPENDED',
                    'A request for this service is currently being processed' => 'PENDING',
                    'Service is being prepared for a backend process' => 'PENDING_BATCH_PROCESSING',
                    'Service has been requested for exporting' => 'PAC_REQUESTED',
                    'Active but processing port in currently' => 'ACTIVE_PENDING_PORT_IN'
            };
        }
    }
    
    public static Map<String, String> refUsimStatus {
        get {
            return new Map<String, String>{
                	'Free to use for a new service provision' => 'AVAILABLE',
                    'Assigned to a live Gamma service' => 'IN_USE',
                    'USIM has been quarantined on the Gamma network' => 'QUARANTINED',
                    'USIM has been ceased on the Gamma network' => 'CEASED'
            };
        }
    }
    
    public static Map<String, String> refUsimType {
        get {
            return new Map<String, String>{
                	'Original SIM card' => 'STANDARDSIM',
                    'Smaller version of a standard or mini SIM card' => 'MICROSIM',
                    'Smaller version of a micro SIM card' => 'NANOSIM',
                    'In some mobile devices two SIM cards can be used' => 'DUALSIM',
                    'In some mobile devices three SIM cards can be used' => 'TRIPLESIM'
            };
        }
    }
    
    public static Map<String, String> refCallForward {
        get {
            return new Map<String, String> {
                'Busy' => 'BUSY',
                'No Answer' => 'NO_REPLY',
                'Unreachable' => 'UNREACHABLE',
                'Always' => 'ALWAYS'
            };
        }
    }
}