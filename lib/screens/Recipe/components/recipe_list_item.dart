import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/cooking_today.dart';
import 'package:delicat/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final String categoryColorCode;
  final Function restartParent;

  RecipeListItem(this.recipe, this.categoryColorCode,
      this.restartParent);

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        Provider.of<Recipes>(context).isRecipeFavorite(recipe.id);
    return Card(
      elevation: 6,
      color: hexToColor(categoryColorCode),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          if (recipe.photo != null)
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ImageHelper.getImageProvider(
                      recipe.photo!,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RawMaterialButton(
                        onPressed: () {
                          Provider.of<Recipes>(context, listen: false)
                              .removeRecipe(recipe.id);
                          restartParent();
                        },
                        fillColor: Color(0xffF6C2A4),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        shape: CircleBorder(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<CookingToday>(
                        builder: (context, cookingToday, child) {
                          final isInCookingToday = cookingToday.isRecipeInCookingToday(recipe.id);
                          return RawMaterialButton(
                            onPressed: () async {
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
                            fillColor: isInCookingToday ? Colors.green : Color(0xffF6C2A4),
                            child: Icon(
                              isInCookingToday ? Icons.today : Icons.today_outlined,
                              color: Colors.white,
                            ),
                            shape: CircleBorder(),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: RawMaterialButton(
                        onPressed: () {
                          // recipe.isFavorite = !recipe.isFavorite;
                          Provider.of<Recipes>(context, listen: false)
                              .toggleFavorite(recipe.id);
                        },
                        fillColor: Color(0xffF6C2A4),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "${recipe.name}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      recipe.description.length > 80
                          ? "${recipe.description.substring(0, 80)}..."
                          : recipe.description,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
