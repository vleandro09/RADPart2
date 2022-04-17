@isTest
private class RecipeTriggerHandler_Test {
    @isTest
    static void testRequiredValuesPositive() {
        Recipe__c recipe = new Recipe__c(
            Name = 'TestRecipe'
        );
        Test.startTest();
            insert recipe;
        Test.stopTest();
    
    Recipe__c insertedRecipe = [SELECT Id, Draft__c FROM Recipe__c WHERE Name = 'TestRecipe' LIMIT 1];

    System.assertEquals(true, insertedRecipe.Draft__c, 'Recipe is missing required fields and must be a Draft');

    }


    @isTest
    static void testComplexityPositive() {
        List<Recipe__c> testRecipes = new list<Recipe__c>();
        Recipe__c rec1 = new Recipe__c (
            Name = 'SimpleTestRecipe',
            Active_Time__c = 1,
            Active_Time_Units__c = 'Minutes',
            Description__c = 'SimpleTestRecipe Description',
            Servings__c = 4
        );
        testRecipes.add(rec1);

        Recipe__c rec2 = new Recipe__c (
            Name = 'ModerateTestRecipe',
            Active_Time__c = 1,
            Active_Time_Units__c = 'Minutes',
            Description__c = 'ModerateTestRecipe Description',
            Servings__c = 8
        );
        testRecipes.add(rec2);
        
        Recipe__c rec3 = new Recipe__c (
            Name = 'DifficultTestRecipe',
            Active_Time__c = 3,
            Active_Time_Units__c = 'Hours',
            Description__c = 'DifficultTestRecipe Description',
            Servings__c = 8
        );
        testRecipes.add(rec3);

        Test.startTest();
            insert testRecipes;                      
        Test.stopTest();

        List<Recipe__c> insertedRecipes = [SELECT Id, Complexity__c FROM Recipe__c];
        System.assertEquals(3, insertedRecipes.size(), 'Three recipes should have been created with Complexity field not null');
       
        
        List<Recipe__c> recipes = [SELECT Id, Name, Complexity__c FROM Recipe__c];
        
        for(Recipe__c rec : recipes) {
            if(rec.Name == 'SimpleTestRecipe') {
                System.assertEquals('Simple', rec.Complexity__c, 'Recipe should be Simple');
            } else if (rec.Name == 'ModerateTestRecipe') {
                System.assertEquals('Moderate', rec.Complexity__c, 'Recipe should be Moderate');
            } else if (rec.Name == 'DifficultTestRecipe') {
                System.assertEquals('Difficult', rec.Complexity__c, 'Recipe should be Difficult');
            }
        }
    }
 
    @isTest
    static void testRequiredValuesNegative(){
        //If a recipe is inserted with all required values, it should should not be marked as draft
        Recipe__c recipe = new Recipe__c (
            Name = 'TestRecipeNotDraft',
            Active_Time__c = 1,
            Active_Time_Units__c = 'Minutes',
            Description__c = 'Test Description',
            Servings__c = 4
        );
        Test.startTest();
            insert recipe;
        Test.stopTest();

        // Query for the Recipe record
        Recipe__c insertedRecipe = [SELECT Id, Draft__c FROM Recipe__c WHERE Name = 'TestRecipe' LIMIT 1];
        System.assertEquals(false, insertedRecipe.Draft__c, 'Record with all required fields should not be marked as a Draft.');
    }

    @isTest
    static void testReviewTaskPositive() {
        Cookbook__c book = new Cookbook__c(Name = 'TestCookbook');
        insert book;

        Recipe__c recipe = new Recipe__c (
            Name = 'TestRecipe',
            Active_Time__c = 3,
            Active_Time_Units__c = 'Hours',
            Description__c = 'TestRecipe Description',
            Servings__c = 8
        );
        insert recipe;
        
        Recipe_Usage__c usage = new Recipe_Usage__c (
            Cookbook__c = book.Id,
            Recipe__c = recipe.Id
        );
        insert usage;

        recipe.Contains_Allergins__c = true;
        test.startTest();
            update recipe;
        test.stopTest();

        List<Task> taskList = [SELECT Id, WhatId, ActivityDate FROM Task];

        System.assertEquals(1, taskList.size(), 'There should be one task to review the cookbook.');
        System.assertEquals(book.Id, TaskList[0].WhatId, 'The taask should be on the Cookbook reccord.');
        System.assertEquals(System.today().addDays(7), taskList[0].ActivityDate, 'The task should be due in 7 days.');
    }
}