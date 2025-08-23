import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/recipes.dart';
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
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ImageHelper.getImageProvider(
                    recipe.photo!,
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
                  "${recipe.name}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                if (recipe.description.length > 100)
                  Text(
                    "${recipe.description.substring(0, 100)}",
                  )
                else
                  Text(
                    "${recipe.description}",
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
