import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';
import '../widgets/recipe_list_item.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    print("Widget category: $category");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your ${category.name} meals"),
      ),
      body: FutureBuilder(
        future: Provider.of<Recipes>(context, listen: false)
            .getRecipesByCategoryId(category.id),
        builder: (ctx, snapshotRecipes) => snapshotRecipes.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Recipes>(
                child: Center(
                  child: const Text("you have no recipes in this category."),
                ),
                builder: (ctx, recipes, ch) => recipes.items.length <= 0
                    ? ch
                    : Column(
                        children: <Widget>[
                          Container(
                            height: 350,
                            child: Swiper(
                              onTap: (index) {
                                Navigator.of(context).pushNamed(
                                  RouterNames.RecipeDetailsScreen,
                                  arguments: recipes.items[index].id.toString(),
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return RecipeListItem(
                                  recipes.items[index],
                                  category.colorCode,
                                );
                              },
                              itemCount: recipes.items.length,
                              viewportFraction: 0.7,
                              scale: 0.8,
                            ),
                          ),
                          Divider(
                            thickness: 4,
                          ),
                          RaisedButton(
                            child: Text("Add a new Recipe"),
                            onPressed: () => Navigator.of(ctx)
                                .pushNamed(RouterNames.NewRecipeScreen),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
