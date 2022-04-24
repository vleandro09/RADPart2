//Test Factory example from Trailhead: https://trailhead.salesforce.com/en/content/learn/modules/unit-testing-on-the-lightning-platform/generate-data-for-tests

@isTest
public class TestFactory {

    // Original TestFactory Methods
    public static Account getAccount(String name, Boolean doInsert){
        Account a = new Account(name = name);
        if(doInsert){
            insert a;
        }
        return a;
    }

    public static Contact getContact(Id accountId, String fname, String lname, Boolean doInsert){
        Contact c = new Contact(firstName = fname, lastName = lname, accountId = accountId);
        if(doInsert){
            insert c;
        }
        return c;
    }

    public static void generateAccountWithContacts(Integer numContacts){
        Account a = getAccount('default account ltd', true);
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numContacts; i++){
            String contactName = 'contact' + i;
            contacts.add(getContact(a.id, contactName, contactName, false));
        }
        insert contacts;
    }

    public static Opportunity[] generateOppsForAccount(id accountId, Decimal amount, Integer numOpps){
        List<Opportunity> opps = new List<Opportunity>();
        for(Integer i = 0; i < numOpps; i++){
            Opportunity o = new Opportunity();
            o.name = 'Account ' + i;
            o.accountId = accountid;
            o.amount = amount;
            o.closeDate = Date.today().addDays(5);
            o.stageName = 'Prospecting';
            opps.add(o);
        }
        return opps;
    }
    
    public static User generateUser(String profileName){
        UserRole userRole = new UserRole(DeveloperName = 'TestingTeam', Name = 'Testing Team');
        insert userRole;
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id,
            LastName = 'last',
            Email = 'Cpt.Awesome@awesomesauce.com',
            Username = 'Cpt.Awesome@awesomesauce.com',
            CompanyName = 'Testing Co',
            Title = 'Captian',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = userRole.Id
        );
        insert u;
        return u;
    }
//************BEGINNING OF PROJECT 2 OF FINAL PROJECT FOR RAD WOMEN PART 2************/
// Final Project Part 2: Method 1 - Create and return a list of Ingredient SObject records with dummy data
    public static List<Ingredient__c> ReturnListofIngredients(Integer numberOfIngredientsReturned) {
        List<Ingredient__c> ingredientList = new List<Ingredient__c>();
        for(Integer i = 0; i < numberOfIngredientsReturned; i++) {
            Ingredient__c ing = new Ingredient__c(Name = 'Ingredient ' + i);
            ingredientList.add(ing);
        }
        return ingredientList;
    }

// Final Project Part 2: Method 2 - Creates, inserts, and returns Ingredient SObjects
    public static List<Ingredient__c> InsertListIngredients(Integer numberIngredientsCreatedReturned) {
        Recipe__c testRecipe = new Recipe__c ( Name = 'Method2Recipe',
                                               Description__c = 'Sample Recipe',
                                               Active_Time__c = 55,
                                               Active_Time_Units__c = 'Minutes',
                                               Servings__c = 2);
        insert testRecipe;

        List<Ingredient__c> ingredientsList2 = new List<Ingredient__c>();
        for(Integer i = 0; i < numberIngredientsCreatedReturned; i++) {
            Ingredient__c ing = new Ingredient__c(Name = 'Method2Ingredient ' + i, Recipe__c = testRecipe.Id);
        ingredientsList2.add(ing);
        }
        insert ingredientsList2;
        System.debug('ingredientsList2: ' + ingredientsList2);
        return ingredientsList2;
    }

// Final Project Part 2: Method 3 - Creates, inserts, and returns a list of Recipve SObjects records with dummy data
    public static List<Recipe__c> InsertListRecipe(Integer numberOfRecipesReturned) {
        List<Recipe__c> recipeList = new List<Recipe__c>();
        for(Integer i = 0; i < numberOfRecipesReturned; i++) {
            Recipe__c rec = new Recipe__c(Name = 'Method3Recipe ' + i, 
                                          Description__c = 'Sample Recipe',
                                          Active_Time__c = 55,
                                          Active_Time_Units__c = 'Minutes',
                                          Servings__c = 2);
            recipeList.add(rec);
        }
        insert recipeList;
        System.debug('Recipe List: ' + recipeList);

        List<Ingredient__c> ingredientList = ReturnListofIngredients(numberOfRecipesReturned);
        List<Ingredient__c> ingredientList2 = InsertListIngredients(numberOfRecipesReturned);
        for(Integer r = 0, i = 0; r < numberOfRecipesReturned; r++) {
            ingredientList[i].recipe__c = recipeList[r].id;
            ingredientList2[i].recipe__c = recipeList[r].id;
            i = i++;
        }

        insert ingredientList;
        insert ingredientList2;
        System.debug('IngredientList[3].recipe__c ' + ingredientList[3].recipe__c);
        System.debug('IngredientList2[3].recipe__c ' + ingredientList2[3].recipe__c);
        System.debug('recipeList[3].id ' + recipeList[3].id);
        return recipeList;
    }
}
