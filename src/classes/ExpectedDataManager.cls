public class ExpectedDataManager extends AbstractThingParkTestCase {
    
    public Pricebook2 pricebook;
    public Product2 testProduct;
    public List<Product2> lorawanProducts;
    public Account account;
    public Contact primaryContact;
    public Contact altContact;
    public LoRaWAN_Tenancy__c lorawanTenancy;
    public LoRaWAN_Package__c lorawanPackage;
    public Tax__c vatRate;
    public RecordType invoiceRecordType;

	public User givenTestUser() {
        // Given Test User
		User testUser = [SELECT name, Id  FROM user LIMIT 1];
		assertNotNull(testUser, 'Expected user to be available for test.');
        System.debug('Running as : ' + testUser);
        return testUser;
    }
    
    // Given Pricebook2 with LoRaWAN products
    public Pricebook2 givenTestPriceBook() {
        if (pricebook == null) {
            pricebook = new Pricebook2(
                Name = 'Test Pricebook',
                IsActive = true);
            insert pricebook;
        }
        System.debug('Given pricebook : ' + pricebook);
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
        }
        System.debug('Given testProduct : ' + testProduct);
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
            Product2 testLorawanProduct00 = new Product2(
                Name = 'LoRaWan 0', 
                ProductCode = 'LORAWAN00',
                Description = 'LoRaWan without commitment. ' + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanProduct00;
            lorawanProducts.add(testLorawanProduct00);
        	System.debug('Given testLorawanProduct : ' + testLorawanProduct00);
            
            Product2 testLorawanProduct01 = new Product2(
                Name = 'LoRaWan 1', 
                ProductCode = 'LORAWAN01',
                Description = 'LoRaWan 1 year commitment. ' + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanProduct01;
            lorawanProducts.add(testLorawanProduct01);
        	System.debug('Given testLorawanProduct : ' + testLorawanProduct01);
            
            Product2 testLorawanProduct03 = new Product2(
                Name = 'LoRaWan 3',
                ProductCode = 'LORAWAN03',
                Description = 'LoRaWan 3 year commitment.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanProduct03;
            lorawanProducts.add(testLorawanProduct03);
        	System.debug('Given testLorawanProduct : ' + testLorawanProduct03);
            
            Product2 testLorawanProduct05 = new Product2(
                Name = 'LoRaWan 5',
                ProductCode = 'LORAWAN05',
                Description = 'LoRaWan 5 year commitment.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanProduct05;
            lorawanProducts.add(testLorawanProduct05);
        	System.debug('Given testLorawanProduct : ' + testLorawanProduct05);

            Product2 testLorawanOverage = new Product2(
                Name = 'LoRaWan Overage', 
                ProductCode = 'LORAWAN99',
                Description = 'LoRaWan Overage.'  + Timestamp.timestamp(),
                Family = 'LoRaWAN',
                IsActive = true);
            insert testLorawanOverage;
            lorawanProducts.add(testLorawanOverage);
        	System.debug('Given testLorawanProduct : ' + testLorawanOverage);
        }
        return lorawanProducts;
    }

    public Account givenThingParkCustomer() {
        if (account == null) {
            account = new Account(Name='LoRaWAN Test Customer ' + Timestamp.timestamp());
            insert account;
        }
		System.debug('Given account : ' + account);
        return account;
    }

    public Contact givenCustomerContacts() {
        if (account == null) {
            givenThingParkCustomer();
        }

        if (primaryContact == null) {
            String firstName = RandomData.randomForename();
            String surname = RandomData.randomSurname();
    
            primaryContact = new Contact(accountId = account.Id, 
                                         firstName = firstName, 
                                         lastname = surname, 
                                         email = firstName + '.' + surname + '@example.com' );
            insert primaryContact;
            System.debug('Given primary Contact : ' + primaryContact);
        }

		if (altContact == null) {        
            String altFirstName = RandomData.randomForename();
            String altSurname = RandomData.randomSurname();
            altContact = new Contact(accountId = account.Id, 
                                            firstName = altFirstName, 
                                            lastname = altSurname,
                                            email = altFirstName + '.' + altSurname + '@example.com' );
            insert altContact;
            System.debug('Given alternate altContact : ' + altContact);
            }
        
        return primaryContact;
    }

    public LoRaWAN_Tenancy__c givenThingParkTenancy() {
        return givenThingParkTenancyFor(givenCustomerContacts());
    }

    public LoRaWAN_Tenancy__c givenThingParkTenancyFor(final Contact contact) {
        if (lorawanTenancy == null) {
			// Mock Actility because of trigger on LoRaWAN_Tenancy__c
            createMock();

            lorawanTenancy = new LoRaWAN_Tenancy__c();
            lorawanTenancy.Account__c = account.id;
            lorawanTenancy.Contact__c = contact.id;
            lorawanTenancy.Name = 'Test-Tenancy ' + Timestamp.timeStamp();
            lorawanTenancy.Daily_Max_Average__c = 99;
            lorawanTenancy.Overage_Rate__c = 0.15;
            insert lorawanTenancy;
            System.debug('Given lorawanTenancy : ' + lorawanTenancy);
        }
        return lorawanTenancy;
    }
    
    public LoRaWAN_Package__c givenThingParkPackage() {
        return givenThingParkPackageFor(givenThingParkTenancy());
    }
    
    public LoRaWAN_Package__c givenThingParkPackageFor(final LoRaWAN_Tenancy__c tenancy) {
        if (lorawanPackage == null) {
			// Mock Actility because of trigger on LoRaWAN_Package__c
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
            System.debug('Given lorawanPackage : ' + lorawanPackage);
        }
        return lorawanPackage;
    }

    public Tax__c givenInvoiceVatRate() {
        if (vatRate == null) {
            vatRate = new Tax__c(Name = 'VAT Rate (Test)', Rate__c = 20 );
            insert vatRate;
            System.debug('Given vatRate : ' + vatRate);
        }
        return vatRate;
    }

    public RecordType givenInvoiceRecordType() {
        if (invoiceRecordType == null) {
            invoiceRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Fiscal_Document__c' AND DeveloperName = 'sales_invoice'];
            System.debug('Given invoiceRecordType : ' + invoiceRecordType);
        }
        return invoiceRecordType;
    }
}