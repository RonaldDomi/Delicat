import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/ingredient_checklist.dart';
import 'package:delicat/providers/cooking_today.dart';

class CleanupService {
  static Future<void> cleanupOrphanedData({
    required Recipes recipesProvider,
    required IngredientChecklist ingredientChecklistProvider,
    required CookingToday cookingTodayProvider,
  }) async {
    // Get all valid recipe IDs
    final validRecipeIds = recipesProvider.recipes.map((recipe) => recipe.id).toSet();
    
    // Clean up favorites (recipes whose categories were deleted)
    await recipesProvider.cleanupOrphanedFavorites();
    
    // Clean up cooking today list
    await cookingTodayProvider.cleanupOrphanedRecipes(validRecipeIds);
    
    // Clean up ingredient checklists
    await ingredientChecklistProvider.cleanupOrphanedRecipes(validRecipeIds);
  }
}