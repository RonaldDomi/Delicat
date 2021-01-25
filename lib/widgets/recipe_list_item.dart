import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../other/helperFunctions.dart';
import '../models/recipe.dart';
import '../providers/recipes.dart';

class RecipeListItem extends StatelessWidget {
  Recipe recipe;
  String categoryColorCode;
  Function restartParent;

  RecipeListItem(@required this.recipe, @required this.categoryColorCode,
      this.restartParent);

  @override
  Widget build(BuildContext context) {
    recipe = Recipe();
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
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    recipe.photo,
                  ),
                  // image: AssetImage(
                  //   recipe.photo,
                  // ),
                ),
              ),
            ),
          SizedBox(height: 20),
          Container(
            width: 170,
            child: Column(
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Expanded(flex: 2, child: SizedBox()),
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
                Text(
                  "hello",
                  // "${recipe.name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (0 > 100)
                  // if (recipe.description.length > 100)
                  Text(
                    "${recipe.description.substring(0, 100)}",
                  )
                else
                  Text(
                    // "${recipe.description}",
                    "recipe.description",
                  )
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
