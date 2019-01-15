public class ExpectedDataManager extends AbstractThingParkTestCase {
    
    // Given Pricebook2 with LoRaWAN products
    public static Pricebook2 givenTestPriceBook() {    
        Pricebook2 testPricebook = new Pricebook2(
            Name = 'Test Pricebook', 
            IsActive = true);
        insert testPricebook;
        return testPricebook;
    }
    
    public static Product2 givenTestProduct() {    
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            Family = 'Test',
            ProductCode = 'Test ' + RandomData.unique(),
            Description = 'Test Product ' + Timestamp.timestamp(),
            IsActive = true);
        insert testProduct;
        return testProduct;
    }
    
    // Given LoRaWAN products
    // LoRaWan 0	LoRaWan without commitment.	LoRaWAN	LORAWAN00	true
    // LoRaWan 1	LoRaWan 1 year commitment.	LoRaWAN	LORAWAN01	true
    // LoRaWan 3	LoRaWan 3 year commitment.	LoRaWAN	LORAWAN03	true
    // LoRaWan 5	LoRaWan 5 year commitment.	LoRaWAN	LORAWAN05	true
    public static List<Product2> givenThingParkProducts() {
        List<Product2> lorawanProducts = new List<Product2>();
        Product2 testLorawan00Product = new Product2(
            Name = 'LoRaWan 0', 
            ProductCode = 'LORAWAN00',
            Description = 'LoRaWan without commitment.',
            Family = 'LoRaWAN',
            IsActive = true);
        insert testLorawan00Product;
        lorawanProducts.add(testLorawan00Product);
        
        Product2 testLorawan01Product = new Product2(
            Name = 'LoRaWan 1', 
            ProductCode = 'LORAWAN01',
            Description = 'LoRaWan 1 year commitment.',
            Family = 'LoRaWAN',
            IsActive = true);
        insert testLorawan01Product;
        lorawanProducts.add(testLorawan01Product);
        
        Product2 testLorawan03Product = new Product2(
            Name = 'LoRaWan 3',
            ProductCode = 'LORAWAN03',
            Description = 'LoRaWan 3 year commitment.',
            Family = 'LoRaWAN',
            IsActive = true);
        insert testLorawan03Product;
        lorawanProducts.add(testLorawan03Product);
        
        Product2 testLorawan05Product = new Product2(
            Name = 'LoRaWan 5',
            ProductCode = 'LORAWAN05',
            Description = 'LoRaWan 5 year commitment.',
            Family = 'LoRaWAN',
            IsActive = true);
        insert testLorawan05Product;
        lorawanProducts.add(testLorawan05Product);
        
        Product2 testLorawanOverage = new Product2(
            Name = 'LoRaWan Overage', 
            ProductCode = 'LORAWAN99',
            Description = 'LoRaWan Overage.',
            Family = 'LoRaWAN',
            IsActive = true);
        insert testLorawanOverage;
        lorawanProducts.add(testLorawanOverage);
        
        System.debug('lorawanProducts : ' + lorawanProducts);
        
        return lorawanProducts;
    }
    
    public static Account givenThingParkCustomer() {
        Account account = new Account(Name='LoRaWAN Test Customer ' + Timestamp.timestamp());
        insert account;

        System.debug('Account : ' + account);
        
        return account;
    }
    
    public static LoRaWAN_Tenancy__c givenThingParkTennancy() {
        return givenThingParkTennancyFor(givenThingParkCustomer());
    }
    
    public static LoRaWAN_Tenancy__c givenThingParkTennancyFor(final Account account) {
        
        createMock();
        
        LoRaWAN_Tenancy__c tenancy = new LoRaWAN_Tenancy__c();
        tenancy.Account__c = account.Id;
        tenancy.Name = 'Test-' + Timestamp.timeStamp();
        tenancy.Daily_Max_Average__c = 99;
        tenancy.Overage_Rate__c = 0.05;
        insert tenancy;

        System.debug('LoRaWAN_Tenancy__c : ' + tenancy);
        
        return tenancy;
    }
    
    public static LoRaWAN_Package__c givenThingParkPackage() {
        return givenThingParkPackageFor(givenThingParkTennancy());
    }
    
    public static LoRaWAN_Package__c givenThingParkPackageFor(final LoRaWAN_Tenancy__c tenancy) {
        
        createMock();
        
        LoRaWAN_Package__c pckage = new LoRaWAN_Package__c();
        pckage.LoRaWAN_Tenancy__c = tenancy.Id;
        pckage.Actility_Subscription_ID__c = tenancy.Actility_Subscriber_ID__c;
        pckage.Name = 'Test-Package' + Timestamp.timeStamp();
        pckage.Device_Rate__c = 0.05;
        pckage.Device_Rate_after_commitment_end__c = 0.10;
        pckage.Start_Date__c = System.today();
        pckage.Term__c = 12;
        pckage.Quantity_Of_Devices__c = 99;
        
        insert pckage;

        System.debug('LoRaWAN_Package__c : ' + pckage);
        
        return pckage;
    }
    
    public static Tax__c givenInvoiceVatRate() {
        Tax__c vatRate = new Tax__c(Name = 'VAT Test Rate', Rate__c = 20 );
        insert vatRate;
        System.debug('vatRate : ' + vatRate);
        
        return vatRate;
    }    
}