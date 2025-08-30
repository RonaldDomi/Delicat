import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/helpers/image_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  
  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    final categories = Provider.of<Categories>(context, listen: false);
    final category = categories.getCategoryById(recipe.categoryId);

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
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
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
                      padding: const EdgeInsets.all(16.0),
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
        ),
      ),
    );
  }
}
