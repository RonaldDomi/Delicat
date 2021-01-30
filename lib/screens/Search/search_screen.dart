import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/Favorites/components/favorites_item.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        width: MediaQuery.of(context).size.width,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Center(
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (editingController.text.isNotEmpty)
                ? Expanded(
                    flex: 1,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2.5,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      padding: const EdgeInsets.all(15),
                      itemCount: items.length,
                      itemBuilder: (ctx, i) => InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              RouterNames.RecipeDetailsScreen,
                              arguments: items[i].id);
                        },
                        child: FavoriteItem(items[i]),
                        // child: ListTile(
                        //   title: Text("What are you looking for?"),
                        // ),
                      ),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Center(
                          child: Text(
                            'What are you looking for?',
                            style: TextStyle(
                              color: hexToColor("#F6C2A4"),
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
