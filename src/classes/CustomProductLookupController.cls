public with sharing class CustomProductLookupController {
  public List<PricebookEntry> results {get;set;}
  public string searchString {get;set;}
  
  public CustomProductLookupController() {
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }

  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }

  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 

  // run the search and return the records found. 
  private List<PricebookEntry> performSearch(string searchString) {

    String soql = 'Select Product2Id, Product2.Name, Product2.ProductCode, Product2.Description, PricebookEntry.UnitPrice FROM PricebookEntry WHERE';// WHERE Pricebook2Id = \'01s41000007ahHYAAY\'';
    if (searchString != '' && searchString != null) {
        soql = soql +  ' (Product2.Name LIKE \'%' + searchString + '%\' OR Product2.ProductCode LIKE \'%' + searchString + '%\' OR Product2.Description LIKE \'%' + searchString + '%\') AND';
    }
    soql = soql + ' Pricebook2Id = \'' + System.currentPageReference().getParameters().get('priceBookId') + '\' LIMIT 25';
    return database.query(soql); 

  }

  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }

  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}