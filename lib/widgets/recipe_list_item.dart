import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helperFunctions.dart';
import '../models/recipe.dart';
import '../providers/recipes.dart';

class RecipeListItem extends StatelessWidget {
  Function restartParent;
  Recipe recipe;
  String categoryColorCode;
  String categoryPhoto;

  RecipeListItem(@required this.recipe, @required this.categoryColorCode,
      this.restartParent, this.categoryPhoto);

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
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(categoryPhoto),
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
                  "${recipe.name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "${recipe.instructions}",
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
