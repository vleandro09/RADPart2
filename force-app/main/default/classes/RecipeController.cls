public inherited sharing class RecipeController {
    
    // Part 1 #2 generateGroceryList
    @AuraEnabled
    public static List<Ingredient__c> generateGroceryList(Id recipeId) {
        //load the ingredients from the database and return them
        List<Ingredient__c> ingredients = new List<Ingredient__c>();
        ingredients = [SELECT Id, Name, Measurement__c, Measurement_Type__c, Notes__c FROM Ingredient__c WHERE Recipe__c = :recipeId];
        System.debug('Here is the grocery list: ' + ingredients);
        return ingredients; 
    }
    
    
    // Part 1 #1 addIngredient
    @AuraEnabled
    public static void addIngredient(String ingredientName, Integer measurementAmount, String measurementType,
                                     ID recipeId) {
    // Create an Ingredient SObject in memory and add an ingredient
    // The LWCs manage the fact that Name, Amount, Type and Recipe ID cannot be null
    Ingredient__c ing = new Ingredient__c(
        Recipe__c = recipeId,    
        Name = ingredientName,
        Measurement__c = measurementAmount,
        Measurement_Type__c = measurementType
    );
    System.debug('Add new ingredient ' + ing);
    insert ing;
    }
    
    // Part 1 #3 scaleRecipeForServings
    @AuraEnabled
    public static List<Ingredient__c> scaleRecipeForServings(ID recipeId, Decimal desiredServings) {
        //Scale the recipe and return the list of scaled ingredients
        List<Ingredient__c> updatedIngredients = [SELECT Id, Name, Measurement__c, Measurement_Type__c, Recipe__r.Id, Recipe__r.Servings__c, Recipe__r.Name
                                                 FROM Ingredient__c
                                                 WHERE Recipe__c =: recipeId];
        for(Ingredient__c ing : updatedIngredients) {
            Decimal measurementConversion = ing.Measurement__c / ing.Recipe__r.Servings__c;
            ing.Measurement__c = desiredServings * measurementConversion;
            System.debug(' Scaled Recipe for Servings: New Measurement ' + ing.Name + ing.Measurement__c + ' ' + ing.Measurement_Type__c);
        }
        return updatedIngredients;
       /* try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return scaledRecipe;
        */
    }


    // This begins what was originally in the RecipeController
    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] searchRecipes(String searchTerm) {
        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            System.debug('returning: '+getAllRecipes());
            return getAllRecipes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            WHERE Name LIKE :searchTerm
            ORDER BY Name
            LIMIT 50
        ];
    }
}