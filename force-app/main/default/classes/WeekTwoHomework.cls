public with sharing class WeekTwoHomework {
    // Query for a List of contacts and return the Account Name and Industry as well.  
    // Use a loop to print the name of each Contact’s Account Name with System.debug.

    public static void childToParentRelationshipQueries() {
        List < Contact > contactList = [SELECT ID, Name, Account.Name, Account.Industry FROM Contact WHERE Contact.Account.AnnualRevenue >= 350000000];
        for(Contact con : contactList) {
            System.debug('Contact, ' + con.Name + ', belongs to the ' + con.Account.Name + ' account. The Industry is ' + con.Account.Industry + '.');
        }
    }
    
    //Same as above but instead use a SOQL For Loop Example
    public static void childToParentQuery() {
        for(Contact con : [SELECT ID, Name, Account.Name, Account.Industry FROM Contact WHERE Contact.Account.AnnualRevenue >= 350000000]) {
            System.debug('Contact, ' + con.Name + ', belongs to the ' + con.Account.Name + ' account. The Industry is ' + con.Account.Industry + '.');            
        }    
    }

    // A method that includes a query for a list of Accounts AND includes all their closed-won opportunities in a subquery. 
    // Use a loop to print out the name of each Account’s opportunity with System.debug.
    public static void accountsWithOpptysWon() {
       Account[] acctsWithOpptys = [SELECT Name, (SELECT Name FROM Opportunities WHERE StageName = 'Closed Won' ) FROM Account];
        for (Account acct : acctsWithOpptys) {
            for(Opportunity oppty : acct.Opportunities) {
                System.debug('The opportunity that was won on account ' + acct.Name + ' is ' + oppty.Name);
            }
        }
    }

    // A method that queries for Opportunity records that returns results in a map format.
    public static void returnOpptyInMap() {
    Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>([
        SELECT Name, StageName FROM Opportunity WHERE StageName = 'Closed Won'
    ]); 
        System.debug('opptyMap: ' + opptyMap);
    }

    // An aggregate results query that returns an integer equal to the total number of open opportunities in your org.
    public static void aggregateQuery() {
        Integer allOpenOpptys = [SELECT COUNT() FROM Opportunity WHERE IsWon = FALSE];
        System.debug('There are ' + allOpenOpptys + ' open opportunities');
    }
}
