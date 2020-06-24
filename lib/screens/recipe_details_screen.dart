import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;
  RecipeDetailsScreen({this.recipeId});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recipe = Provider.of<Recipes>(context).getRecipeById(widget.recipeId);
    final isFavorite =
        Provider.of<Recipes>(context).isRecipeFavorite(widget.recipeId);

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
              decoration:
                  InputDecoration(labelText: "isFavorite : $isFavorite"),
              onSubmitted: (String value) {
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            heroTag: null,
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
          FloatingActionButton(
            heroTag: null,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () => {
                Provider.of<Recipes>(context, listen: false)
                    .toggleFavorite(recipe.id),
              },
            ),
          ),
        ],
      ),
    );
  }
}
