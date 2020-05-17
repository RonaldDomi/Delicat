import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';

class RecipeListScreen extends StatelessWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  //we need to get categoryId by route argument and pass it to fetchAndSetRecipesByCategory(categoryId)
  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(categoryId);
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
            : Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    constraints: BoxConstraints.expand(height: 300),
                    child: Consumer<Recipes>(
                      child: Center(
                        child:
                            const Text("you have no recipes in this category."),
                      ),
                      builder: (ctx, recipes, ch) => recipes.items.length <= 0
                          ? ch
                          : ListView.builder(
                              itemCount: recipes.items.length,
                              itemBuilder: (ctx, i) => Container(
                                color: Color(int.parse(category.colorCode)),
                                child: ListTile(
                                  title: Text(recipes.items[i].name),
                                  contentPadding: EdgeInsets.all(15),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      RouterNames.RecipeDetailsScreen,
                                      arguments: recipes.items[i].id.toString(),
                                    );
                                  },
                                ),
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
