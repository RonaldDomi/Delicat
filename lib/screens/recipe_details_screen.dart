import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeId;
  RecipeDetailsScreen({this.recipeId});

  final TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(recipeId);
    print("Widget recipe: $recipe");

    _nameController.text = recipe.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(recipe.instructions),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Rename"),
              onSubmitted: (String value) {
                print("-");
                print("-");
                print("recipe: $recipe");
                print("-");
                print("-");
                Provider.of<Recipes>(context, listen: false).editRecipe(
                  Recipe(
                    name: value,
                    categoryId: recipe.categoryId,
                    instructions: recipe.instructions,
                    photo: recipe.photo,
                    id: recipe.id,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () => {
            Provider.of<Recipes>(context, listen: false)
                .removeRecipe(recipe.id),
            Navigator.of(context).pop()
          },
        ),
      ),
    );
  }
}
