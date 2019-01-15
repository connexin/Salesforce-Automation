public class ExpectedDataManager extends AbstractThingParkTestCase {
    
    public Pricebook2 pricebook;
    public Product2 testProduct;
    public List<Product2> lorawanProducts;
    public Account account;
    public LoRaWAN_Tenancy__c lorawanTenancy;
    public LoRaWAN_Package__c lorawanPackage;
    public Tax__c vatRate;
    public RecordType invoiceRecordType;
    
    // Given Pricebook2 with LoRaWAN products
    public Pricebook2 givenTestPriceBook() {
        if (pricebook == null) {
            pricebook = new Pricebook2(
                Name = 'Test Pricebook',
                IsActive = true);
            insert pricebook;
            
            System.debug('Pricebook2 : ' + pricebook);
        }
        return pricebook;
    }
    
    public Product2 givenTestProduct() {    
        if (testProduct == null) {
            testProduct = new Product2(
                Name = 'Test Product',
                Family = 'Test',
                ProductCode = 'Test ' + RandomData.unique(),
                Description = 'Test Product ' + Timestamp.timestamp(),
                IsActive = true);
            insert testProduct;
            
            System.debug('Product2 : ' + testProduct);
        }
        return testProduct;
    }
    
    // Given LoRaWAN products
    // LoRaWan 0	LoRaWan without commitment.	LoRaWAN	LORAWAN00	true
    // LoRaWan 1	LoRaWan 1 year commitment.	LoRaWAN	LORAWAN01	true
    // LoRaWan 3	LoRaWan 3 year commitment.	LoRaWAN	LORAWAN03	true
    // LoRaWan 5	LoRaWan 5 year commitment.	LoRaWAN	LORAWAN05	true
    public List<Product2> givenThingParkProducts() {
        if (lorawanProducts == null) {
            lorawanProducts = new List<Product2>();
            Product2 testLorawan00Product = new Product2(
                Name = 'LoRaWan 0', 
                ProductCode = 'LORAWAN00',
                Description = 'LoRaWan without commitment. ' + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawan00Product;
            lorawanProducts.add(testLorawan00Product);
            
            Product2 testLorawan01Product = new Product2(
                Name = 'LoRaWan 1', 
                ProductCode = 'LORAWAN01',
                Description = 'LoRaWan 1 year commitment. ' + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawan01Product;
            lorawanProducts.add(testLorawan01Product);
            
            Product2 testLorawan03Product = new Product2(
                Name = 'LoRaWan 3',
                ProductCode = 'LORAWAN03',
                Description = 'LoRaWan 3 year commitment.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawan03Product;
            lorawanProducts.add(testLorawan03Product);
            
            Product2 testLorawan05Product = new Product2(
                Name = 'LoRaWan 5',
                ProductCode = 'LORAWAN05',
                Description = 'LoRaWan 5 year commitment.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawan05Product;
            lorawanProducts.add(testLorawan05Product);
            
            Product2 testLorawanOverage = new Product2(
                Name = 'LoRaWan Overage', 
                ProductCode = 'LORAWAN99',
                Description = 'LoRaWan Overage.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanOverage;
            lorawanProducts.add(testLorawanOverage);
            System.debug('lorawanProducts : ' + lorawanProducts);
        }
        return lorawanProducts;
    }
    
    public Account givenThingParkCustomer() {
        if (account == null) {
            account = new Account(Name='LoRaWAN Test Customer ' + Timestamp.timestamp());
            insert account;
            
            System.debug('Account : ' + account);
        }
        return account;
    }
    
    public LoRaWAN_Tenancy__c givenThingParkTenancy() {
        return givenThingParkTenancyFor(givenThingParkCustomer());
    }
    
    public LoRaWAN_Tenancy__c givenThingParkTenancyFor(final Account account) {
        if (lorawanTenancy == null) {
            createMock();
            
            lorawanTenancy = new LoRaWAN_Tenancy__c();
            lorawanTenancy.Account__c = account.Id;
            lorawanTenancy.Name = 'Test-Tenancy ' + Timestamp.timeStamp();
            lorawanTenancy.Daily_Max_Average__c = 99;
            lorawanTenancy.Overage_Rate__c = 0.15;
            insert lorawanTenancy;
            
            System.debug('LoRaWAN_Tenancy__c : ' + lorawanTenancy);
        }
        return lorawanTenancy;
    }
    
    public LoRaWAN_Package__c givenThingParkPackage() {
        return givenThingParkPackageFor(givenThingParkTenancy());
    }
    
    public LoRaWAN_Package__c givenThingParkPackageFor(final LoRaWAN_Tenancy__c tenancy) {
        if (lorawanPackage == null) {
            createMock();
            
            lorawanPackage = new LoRaWAN_Package__c();
            lorawanPackage.LoRaWAN_Tenancy__c = tenancy.Id;
            lorawanPackage.Actility_Subscription_ID__c = tenancy.Actility_Subscriber_ID__c;
            lorawanPackage.Name = 'Test-Package ' + Timestamp.timeStamp();
            lorawanPackage.Device_Rate__c = 0.05;
            lorawanPackage.Device_Rate_after_commitment_end__c = 0.10;
            lorawanPackage.Start_Date__c = System.today();
            lorawanPackage.Term__c = 12;
            lorawanPackage.Quantity_Of_Devices__c = 99;
            insert lorawanPackage;
            
            System.debug('LoRaWAN_Package__c : ' + lorawanPackage);
        }
        return lorawanPackage;
    }
    
    public Tax__c givenInvoiceVatRate() {
        if (vatRate == null) {
            vatRate = new Tax__c(Name = 'VAT Rate (Test)', Rate__c = 20 );
            insert vatRate;
            
            System.debug('vatRate : ' + vatRate);
        }
        return vatRate;
    }
    
    public RecordType givenInvoiceRecordType() {
        if (invoiceRecordType == null) {
            invoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
            System.debug('invoiceRecordType : ' + invoiceRecordType);
        }
        return invoiceRecordType;
    }
}