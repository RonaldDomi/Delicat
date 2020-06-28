import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';
import '../widgets/recipe_list_item.dart';

import '../helperFunctions.dart';

class RecipeListScreen extends StatefulWidget {
  final String categoryId;
  RecipeListScreen({this.categoryId});

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final TextEditingController _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final category =
        Provider.of<Categories>(context).getCategoryById(widget.categoryId);
    _nameController.text = category.name;

    print("Widget category: $category");
    return FutureBuilder(
      future: Provider.of<Recipes>(context, listen: false)
          .getRecipesByCategoryId(category.id),
      builder: (ctx, snapshotRecipes) => snapshotRecipes.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: hexToColor(category.colorLightCode),
              child: Consumer<Recipes>(
                child: Center(
                  child: const Text("you have no recipes in this category."),
                ),
                builder: (ctx, recipesProvider, ch) => recipesProvider
                            .recipes.length <=
                        0
                    ? ch
                    : Column(
                        children: <Widget>[
                          Container(
                            height: 350,
                            child: Swiper(
                              onTap: (index) {
                                Navigator.of(context).pushNamed(
                                  RouterNames.RecipeDetailsScreen,
                                  arguments: recipesProvider.recipes[index].id,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return RecipeListItem(
                                  recipesProvider.recipes[index],
                                  category.colorCode,
                                );
                              },
                              itemCount: recipesProvider.recipes.length,
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
                          RaisedButton(
                            child: Text("Delete Category"),
                            onPressed: () => {
                              Provider.of<Categories>(context, listen: false)
                                  .removeCategory(category.id),

                              // !IMPORTANT TODO: Fix error Shown after removal.

                              Navigator.of(ctx).pop()
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: "Rename"),
                              onSubmitted: (String value) {
                                Provider.of<Categories>(context, listen: false)
                                    .editCategory(
                                  Category(
                                    id: category.id,
                                    name: value,
                                    photo: category.photo,
                                    colorCode: category.colorCode,
                                    colorLightCode: category.colorLightCode,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
