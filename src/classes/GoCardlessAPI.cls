public class GoCardlessAPI {
    
    public static HttpRequest createAPIRequest(String endpoint, String method) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Go_Cardless__c.getValues('default').Api_Url__c + endpoint);
        req.setHeader('Authorization', 'Bearer ' + Go_Cardless__c.getValues('default').Api_Token__c);
        req.setHeader('GoCardless-Version', Go_Cardless__c.getValues('default').Api_Version__c);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod(method);
        
        return req;
    }
    
    public static GoCardlessCustomerBankAccount getBankAccount(String bankAccountId) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customer_bank_accounts/' + bankAccountId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody().replace('currency', 'currency_code'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'customer_bank_accounts') {
                    parser.nextToken();
                    return (GoCardlessCustomerBankAccount)parser.readValueAs(GoCardlessCustomerBankAccount.class);
                }
            }
        }
        
        return null;
    }
    
    public static GoCardlessCustomerBankAccount[] getCustomerBankAccounts(String customerId) {
        GoCardlessCustomerBankAccount[] bank_accounts = new GoCardlessCustomerBankAccount[]{};
        
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customer_bank_accounts?limit=4&customer=' + customerId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody().replace('currency', 'currency_code'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'customer_bank_accounts') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            if (parser.getCurrentName() == null) {
                                bank_accounts.add((GoCardlessCustomerBankAccount)parser.readValueAs(GoCardlessCustomerBankAccount.class));
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
        }
        
        return bank_accounts;
    }
    
    public static GoCardlessPayment[] getCustomerPayments(String customerId) {
        GoCardlessPayment[] payments = new GoCardlessPayment[]{};
        
        HttpRequest req = GoCardlessAPI.createAPIRequest('/payments?limit=4&customer=' + customerId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody().replace('currency', 'currency_code'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'payments') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            if (parser.getCurrentName() == null) {
                                payments.add((GoCardlessPayment)parser.readValueAs(GoCardlessPayment.class));
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
        }
        
        return payments;
    }
    
    public static GoCardlessRefund[] getCustomerRefunds(String paymentId) {
        GoCardlessRefund[] refunds = new GoCardlessRefund[]{};
        
        HttpRequest req = GoCardlessAPI.createAPIRequest('/refunds?limit=50&payment=' + paymentId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody().replace('currency', 'currency_code'));
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'refunds') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            if (parser.getCurrentName() == null) {
                                refunds.add((GoCardlessRefund)parser.readValueAs(GoCardlessRefund.class));
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
        }
        
        return refunds;
    }
    
    
    public static GoCardlessMandate[] getCustomerBankAccountMandates(String customerBankAccountId) {
        GoCardlessMandate[] mandates = new GoCardlessMandate[]{};
        
        HttpRequest req = GoCardlessAPI.createAPIRequest('/mandates?limit=4&customer_bank_account=' + customerBankAccountId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'mandates') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            if (parser.getCurrentName() == null) {
                                mandates.add((GoCardlessMandate)parser.readValueAs(GoCardlessMandate.class));
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
        }
        return mandates;
    }
    
    public static GoCardlessMandate[] getCustomerMandates(String customerId) {
        GoCardlessMandate[] mandates = new GoCardlessMandate[]{};
        
        HttpRequest req = GoCardlessAPI.createAPIRequest('/mandates?limit=4&customer=' + customerId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'mandates') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            if (parser.getCurrentName() == null) {
                                mandates.add((GoCardlessMandate)parser.readValueAs(GoCardlessMandate.class));
                                parser.skipChildren();
                            }
                        }
                    }
                }
            }
        }
        
        return mandates;
    }
    
    public static boolean isValidGoCardlessID(String customerId) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customers/' + customerId, 'GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 404) {
            return false;
        }
        
        return true;
    }
    
    public static GoCardlessPayment createCustomerPayment(String customerId, Integer amount, String description, Date charge_date) {
        String mandateId;
        if(charge_date == null) {
            Charge_date = Date.today();
        }
        
        for (GoCardlessMandate mandate : GoCardlessAPI.getCustomerMandates(customerId)) {
            if (mandate.status == 'active') {
                mandateId = mandate.id;
                if (mandate.next_possible_charge_date > charge_date) {
                    charge_date = mandate.next_possible_charge_date;
                }
                break;
            }
        }
        
        if (mandateId != null) {
            return GoCardlessAPI.createPayment(mandateId, amount, description, charge_date);
        }
        
        return null;
    }
    
    public static GoCardlessPayment createPayment(String mandateId, Integer amount, String description, Date charge_date) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/payments', 'POST');
        
        GoCardlessPayment payment = new GoCardlessPayment();
        payment.amount = amount;
        payment.currency_code = 'GBP';
        payment.description = description;
        payment.links = new GoCardlessObjectLinks();
        payment.links.mandate = mandateId;
        if(charge_date != null) {
            payment.charge_date = charge_date;
        }
        
        req.setBody('{"payments":' + JSON.serialize(payment, true).replace('"currency_code":', '"currency":') + '}');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            JSONParser parser = JSON.createParser(res.getBody().replace('"currency:', '"currency_code":'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'payments') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            return(GoCardlessPayment)parser.readValueAs(GoCardlessPayment.class);
                        }
                    }
                }
            }
        }
        
        return null;
    }
    
    public static GoCardlessRefund createCustomerRefund(String paymentId, Integer amount, String reference) {
        Decimal totalExistingRefundAmount = 0.00;
        
        for (GoCardlessRefund refund : GoCardlessAPI.getCustomerRefunds(paymentId)) {
            totalExistingRefundAmount += refund.amount;
        }
        
        if (paymentId != null) {
            return GoCardlessAPI.createRefund(amount, totalExistingRefundAmount, paymentId, reference);
        }
        
        return null;
    }
    
    public static GoCardlessRefund createRefund(Decimal amount, Decimal total_amount_confirmation, String paymentId, String reference) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/refunds', 'POST');
        
        GoCardlessRefund refund = new GoCardlessRefund();
        refund.amount = amount;
        refund.total_amount_confirmation = Integer.valueOf(total_amount_confirmation) + refund.amount;
        refund.reference = 'Connexin';
        refund.links = new GoCardlessObjectLinks();
        refund.links.payment = paymentId;
        
        req.setBody('{"refunds":' + JSON.serialize(refund, true).replace('"currency_code":', '"currency":') + '}');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            JSONParser parser = JSON.createParser(res.getBody().replace('"currency:', '"currency_code":'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'refunds') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            refund = (GoCardlessRefund)parser.readValueAs(GoCardlessRefund.class);
                            refund.error = false;
                            refund.error_desc = null;
                        }
                    }
                }
            }
        } else {
            refund.error = true;
            refund.error_desc = 'GoCardless Error: ' + res.getStatusCode() + ' - Refund Failed';
        }
        return refund;
    }
    
    public static GoCardlessCustomer createCustomer(Id accountId) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customers', 'POST');
        
        GoCardlessCustomer customer = new GoCardlessCustomer();
        customer.company_name = String.valueOf(accountId);
        
        req.setBody('{"customers":' + JSON.serialize(customer, true) + '}');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 201) {
            JSONParser parser = JSON.createParser(res.getBody());
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'customers') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            return(GoCardlessCustomer)parser.readValueAs(GoCardlessCustomer.class);
                        }
                    }
                }
            }
        }
        
        return null;
    }
    
    public static GoCardlessCustomer updateCustomer(GoCardlessCustomer customer) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customers/' + customer.id, 'POST');
        
        customer.id = null;
        req.setBody('{"customers":' + JSON.serialize(customer, true) + '}');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody());
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'customers') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            return(GoCardlessCustomer)parser.readValueAs(GoCardlessCustomer.class);
                        }
                    }
                }
            }
        }
        
        return null;
    }
    
    public static GoCardlessCustomerBankAccount disableCustomerBankAccount(String bankAccountId) {
        HttpRequest req = GoCardlessAPI.createAPIRequest('/customer_bank_accounts/' + bankAccountId + '/actions/disable', 'POST');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(res.getBody().replace('currency', 'currency_code'));
            
            while (parser.nextToken() != null) {
                if (parser.getCurrentName() == 'customer_bank_accounts') {
                    while (parser.nextToken() != null) {
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            return (GoCardlessCustomerBankAccount)parser.readValueAs(GoCardlessCustomerBankAccount.class);
                        }
                    }
                }
            }
        }
        
        return null;
    }
    
}