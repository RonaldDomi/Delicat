import 'package:delicat/providers/recipes.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/Favorites/components/favorites_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  
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
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RouterNames.RecipeDetailsScreen,
                                arguments: recipe.id,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: FavoriteItem(recipe),
                          );
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
