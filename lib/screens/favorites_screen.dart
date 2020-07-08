import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';
import '../screen_scaffold.dart';

class FavoritesScreen extends StatelessWidget {
  // final List<Recipe> favoriteRecipes;

  // FavoritesScreen(this.favoriteRecipes);

  @override
  Widget build(BuildContext context) {
    // List<Recipe> favoriteRecipes = [];
    List<Recipe> favoriteRecipes =
        Provider.of<Recipes>(context).favoriteRecipes;
    if (favoriteRecipes.isEmpty) {
      return ScreenScaffold(
        child: Center(
          child: Text('You have no favorites yet - start adding some!'),
        ),
      );
    } else {
      return ScreenScaffold(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              color: Colors.grey,
              child: Text(favoriteRecipes[index].name),
            );
          },
          itemCount: favoriteRecipes.length,
        ),
      );
    }
  }
}
