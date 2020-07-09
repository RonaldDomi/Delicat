import 'package:delicat/helperFunctions.dart';
import 'package:delicat/widgets/favorites_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';
import '../routeNames.dart';
import '../screen_scaffold.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController editingController = TextEditingController();
  var items = List<Recipe>();

  @override
  Widget build(BuildContext context) {
    List<Recipe> recipes = Provider.of<Recipes>(context).recipes;

    void filterSearchResults(String query) {
      List<Recipe> dummySearchList = List<Recipe>();
      dummySearchList.addAll(recipes);
      if (query.isNotEmpty) {
        List<Recipe> dummyListData = List<Recipe>();
        dummySearchList.forEach((item) {
          if (item.name.contains(query)) {
            dummyListData.add(item);
          }
        });
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
        return;
      } else {
        setState(() {
          items.clear();
          items.addAll(recipes);
        });
      }
    }

    return ScreenScaffold(
      child: Container(
        color: hexToColor("#BB9982"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  // labelText: "Search...",
                  hintText: "Search...",
                  fillColor: hexToColor("#F1EBE8"),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
            (editingController.text.isNotEmpty)
                ? Consumer<Recipes>(
                    child: Center(
                      child: const Text("you have no recipes."),
                    ),
                    builder: (ctx, recipes, ch) => recipes.recipes.length <= 0
                        ? ch
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2.5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            padding: const EdgeInsets.all(15),
                            itemCount: recipes.recipes.length,
                            itemBuilder: (ctx, i) => InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    RouterNames.RecipeDetailsScreen,
                                    arguments: recipes.recipes[i].id);
                              },
                              child: FavoriteItem(recipes.recipes[i]),
                            ),
                          ),
                  )
                : Center(
                    child: Text('What are you looking for?'),
                  )
          ],
        ),
      ),
    );
  }
}
