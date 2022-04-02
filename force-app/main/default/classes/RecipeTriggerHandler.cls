public with sharing class RecipeTriggerHandler {
    
    // Checks to see if the RecipeTriggerHandler has already executed
    // public static Boolean hasExecuted = false;

    // Trigger handler class variables
    List<Recipe__c> newRecipes;
    Map<ID, Recipe__c> oldRecipes;

    // Constructor to pass through the records processed by the trigger and store
    // them in our class variables
    public RecipeTriggerHandler(List<Recipe__c> newRecipes, Map<ID, Recipe__c> oldRecipes) {
        this.newRecipes = newRecipes;
        this.oldRecipes = oldRecipes;
    }

    // Process records just before insertion or updates
    public void handleBeforeInsertUpdate() {
        // Loop through trigger context variable that contains new records
        // Evaluate if any of the fields register as FALSE; if yes, set Draft__c to TRUE
        for(Recipe__c recipe : newRecipes) {
            if(recipe.Name == null ||
               recipe.Active_Time__c == null ||
               recipe.Description__c == null ||
               recipe.Active_Time_Units__c == null ||
               recipe.Servings__c == null) {
                   recipe.Draft__c = true;
               }
            
            // Check the complexity of a recipe before it's inserted or updated
            if(HelperFunctions.rateRecipeComplexity(recipe) == 1) {
                recipe.Complexity__c = 'Simple';
            } if (HelperFunctions.rateRecipeComplexity(recipe) == 2) {
                recipe.Complexity__c = 'Moderate';
            } if (HelperFunctions.rateRecipeComplexity(recipe) == 3) {
                recipe.Complexity__c = 'Difficult';
            }
        }
   }

   // Process records after update
   public void handleAfterIsertUpdate() {
       List<Task> newTasks = new List<Task>();
       System.Debug('List newTasks: ' + newTasks);

       // Retrieve records where usage records exist for Recipes
       // Query parent records to pull in the data needed to create a task for review
       List<Recipe_Usage__c> recipeUsage = [SELECT Id, Recipe__r.Id, Name, Cookbook__r.Id 
                                            FROM Recipe_Usage__c
                                            WHERE Recipe__r.Draft__c = FALSE AND Recipe__r.Id IN :newRecipes];
        System.debug('List recipeUsage: ' + recipeUsage);

        // Loop through recipe records retrieved
        for(Recipe_Usage__c rec : recipeUsage) {
            // Add information to new Tasks and store in a list
            newTasks.add(new Task (Subject = 'Review required',
                                   Priority = 'High',           
                                   WhatId = rec.Cookbook__r.Id,
                                   ActivityDate = system.today().addDays(7)));
            System.debug('List newTasks: ' + newTasks);
        }

        //Insert Tasks
        insert newTasks;
   }
}
