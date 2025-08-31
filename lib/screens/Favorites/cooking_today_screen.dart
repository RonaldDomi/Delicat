import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/cooking_today.dart';
import 'package:delicat/providers/ingredient_checklist.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/helpers/image_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CookingTodayScreen extends StatelessWidget {
  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    final categories = Provider.of<Categories>(context, listen: false);
    
    // Safe category lookup - return null if category doesn't exist
    late final category;
    try {
      category = categories.getCategoryById(recipe.categoryId);
    } catch (e) {
      // Category was deleted, skip this recipe
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouterNames.RecipeDetailsScreen,
          arguments: recipe.id,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    image: recipe.photo != null && recipe.photo!.isNotEmpty
                        ? DecorationImage(
                            image: ImageHelper.getImageProvider(recipe.photo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: recipe.photo == null || recipe.photo!.isEmpty
                        ? hexToColor(category.colorCode)
                        : null,
                  ),
                  child: recipe.photo == null || recipe.photo!.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                      : null,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8B7355),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: hexToColor(category.colorLightCode),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.today,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No recipes planned',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add recipes you plan to cook\nto create your meal plan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Text(
                '💡 Tip: Open any recipe and use the menu (⋮) to add it to your cooking today list',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffF6C2A4),
              Color(0xffEED0BE),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Column(
                children: [
                  const Text(
                    'Cooking Today',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer2<CookingToday, Recipes>(
                    builder: (context, cookingToday, recipes, child) {
                      final plannedCount = cookingToday.count;
                      return Text(
                        plannedCount == 0 
                          ? 'Plan your meals for easy shopping'
                          : '$plannedCount recipe${plannedCount == 1 ? '' : 's'} planned',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer2<CookingToday, Recipes>(
                builder: (context, cookingToday, recipes, child) {
                  if (cookingToday.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  // Get the actual recipe objects from the recipe IDs and clean up orphaned ones
                  final plannedRecipes = <Recipe>[];
                  final recipeIdsToRemove = <String>[];
                  
                  for (String recipeId in cookingToday.cookingTodayRecipes) {
                    try {
                      final recipe = recipes.getRecipeById(recipeId);
                      
                      // Check if category still exists
                      try {
                        Provider.of<Categories>(context, listen: false).getCategoryById(recipe.categoryId);
                        plannedRecipes.add(recipe);
                      } catch (e) {
                        // Category was deleted, mark recipe for removal
                        recipeIdsToRemove.add(recipeId);
                      }
                    } catch (e) {
                      // Recipe doesn't exist, mark for removal
                      recipeIdsToRemove.add(recipeId);
                    }
                  }
                  
                  // Clean up orphaned recipes
                  if (recipeIdsToRemove.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      for (String recipeId in recipeIdsToRemove) {
                        await cookingToday.removeRecipe(recipeId);
                        await Provider.of<IngredientChecklist>(context, listen: false)
                            .resetRecipeIngredients(recipeId);
                      }
                    });
                  }
                  
                  return Column(
                    children: [
                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(RouterNames.ShoppingListScreen);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xffF6C2A4),
                                  elevation: 4,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text(
                                  'Shopping List',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () async {
                                // Show confirmation dialog
                                final shouldReset = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Reset Cooking Today'),
                                    content: const Text('Are you sure you want to remove all recipes from your cooking today list?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Reset'),
                                      ),
                                    ],
                                  ),
                                );
                                
                                if (shouldReset == true) {
                                  await cookingToday.clearAll();
                                  await Provider.of<IngredientChecklist>(context, listen: false).clearAllData();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xffF6C2A4),
                                elevation: 4,
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.clear_all),
                              label: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Recipe grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: plannedRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = plannedRecipes[index];
                              return _buildRecipeCard(context, recipe);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ],
          ),
      ),
    );
  }
}
