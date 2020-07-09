import 'package:delicat/helperFunctions.dart';
import 'package:delicat/widgets/favorites_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';
import '../routeNames.dart';
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
    }
    ;
    return ScreenScaffold(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: hexToColor("#EED0BE"),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Your Favorites",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<Recipes>(
                child: Center(
                  child: const Text("you have no cats on your profile."),
                ),
                builder: (ctx, recipes, ch) => recipes.recipes.length <= 0
                    ? ch
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 2.5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        padding: const EdgeInsets.all(15),
                        itemCount: recipes.recipes.length,
                        itemBuilder: (ctx, i) => InkWell(
                          onTap: () {
                            // REROUTE TO RECIPELIST
                            Navigator.of(context).pushNamed(
                                RouterNames.RecipeListScreen,
                                arguments: recipes.recipes[i].id);
                          },
                          child: FavoriteItem(recipes.recipes[i]),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
