import 'package:flutter/material.dart';
import '../helperFunctions.dart';
import '../models/recipe.dart';

class RecipeListItem extends StatelessWidget {
  Recipe recipe;
  String categoryColorCode;

  RecipeListItem(@required this.recipe, @required this.categoryColorCode);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 6,
        color: hexToColor(categoryColorCode),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "${recipe.name} \n index: ${recipe.id}",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
    ;
  }
}
