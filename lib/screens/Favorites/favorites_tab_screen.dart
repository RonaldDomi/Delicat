import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/ingredient_checklist.dart';
import 'package:delicat/providers/cooking_today.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/helpers/image_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesTabScreen extends StatelessWidget {
  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    final categories = Provider.of<Categories>(context, listen: false);
    final recipesProvider = Provider.of<Recipes>(context, listen: false);
    final ingredientChecklist = Provider.of<IngredientChecklist>(context, listen: false);
    final cookingToday = Provider.of<CookingToday>(context, listen: false);
    
    // Safe category lookup - clean up orphaned recipe if category doesn't exist
    late final category;
    try {
      category = categories.getCategoryById(recipe.categoryId);
    } catch (e) {
      // Category was deleted, remove this orphaned recipe from favorites
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        recipesProvider.toggleFavorite(recipe.id); // Remove from favorites
        await cookingToday.removeRecipe(recipe.id); // Remove from cooking today if it's there
        await ingredientChecklist.resetRecipeIngredients(recipe.id); // Clean up ingredients
      });
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
          child: Stack(
            children: [
              Column(
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
                                color: Color(0xff8B7355),
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
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<CookingToday>(
                  builder: (context, cookingToday, child) {
                    final isInCookingToday = cookingToday.isRecipeInCookingToday(recipe.id);
                    return GestureDetector(
                      onTap: () async {
                        await cookingToday.toggleRecipe(recipe.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isInCookingToday 
                                ? 'Removed from cooking today' 
                                : 'Added to cooking today',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isInCookingToday 
                            ? Colors.green.withOpacity(0.9)
                            : Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isInCookingToday ? Icons.today : Icons.today_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    );
                  },
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
                Icons.favorite_border,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap the heart icon on any recipe\nto add it to your favorites',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Your Favorites',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<Recipes>(
                  builder: (context, recipes, child) {
                    final favoriteCount = recipes.favoriteRecipes.length;
                    return Text(
                      favoriteCount == 0 
                        ? 'Your favorite recipes will appear here'
                        : '$favoriteCount recipe${favoriteCount == 1 ? '' : 's'} saved',
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
          Consumer<Recipes>(
            builder: (context, recipes, child) {
              if (recipes.favoriteRecipes.isEmpty) {
                return _buildEmptyState();
              }
              
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: recipes.favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes.favoriteRecipes[index];
                      return _buildRecipeCard(context, recipe);
                    },
                  ),
                ),
              );
            },
            ),
          ],
        ),
    );
  }
}
