import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeId;
  RecipeDetailsScreen({this.recipeId});

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(recipeId);
    print("Widget recipe: $recipe");

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Center(
        child: Text(recipe.instructions),
      ),
    );
  }
}
