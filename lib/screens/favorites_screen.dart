import 'package:flutter/material.dart';

import '../models/recipe.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> favoriteRecipes;

  FavoritesScreen(this.favoriteRecipes);

  @override
  Widget build(BuildContext context) {
    if (favoriteRecipes.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          return Container(
            child: Text(favoriteRecipes[index].name),
          );
        },
        itemCount: favoriteRecipes.length,
      );
    }
  }
}
