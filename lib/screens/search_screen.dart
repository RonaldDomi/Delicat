import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/recipes.dart';
import '../models/recipe.dart';

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

    return Container(
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
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          (editingController.text.isNotEmpty)
              ? Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.all(20),
                        color: Colors.grey,
                        child: Text(items[index].name),
                      );
                    },
                    itemCount: items.length,
                  ),
                )
              : Center(
                  child: Text('What are you looking for?'),
                )
        ],
      ),
    );
  }
}
