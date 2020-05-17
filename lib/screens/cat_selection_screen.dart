import 'package:flutter/material.dart';
// import 'package:delicat/providers/recipes.dart';
// import 'package:delicat/screens/home_screen.dart';
import 'package:delicat/providers/categories.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../widgets/predefined_categoy_item.dart';

class CatSelectionScreen extends StatefulWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  @override
  _CatSelectionScreenState createState() => _CatSelectionScreenState();
}

class _CatSelectionScreenState extends State<CatSelectionScreen> {
  List<Category> selectedCategories = [];

  void addCategoryToSelection(Category category) {
    print("  ");
    print("  ");
    print("adding $category to selectedCats");
    var existingItem = selectedCategories.firstWhere(
        (itemToCheck) => itemToCheck.id == category.id,
        orElse: () => null);
    if (existingItem == null) {
      selectedCategories.add(category);
    } else {
      selectedCategories.removeWhere((item) => item.id == category.id);
    }
    print("selected Cats $selectedCategories");
  }

  void submitCategories(context) {
    print("selected categories: $selectedCategories");
    for (Category cat in selectedCategories) {
      print(" ");
      print(" ");
      print("trying to create a new category");
      print(" ");
      print(" ");
      Provider.of<Categories>(context).createCategory(cat);
    }
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category Selection Screen"),
      ),
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false)
            .getAllPredefinedCategories(),
        builder: (ctx, snapshotCategories) =>
            snapshotCategories.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        constraints: BoxConstraints.expand(height: 300),
                        child: Consumer<Categories>(
                          builder: (ctx, categories, _) => GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            padding: const EdgeInsets.all(25),
                            itemCount: categories.predefinedItems.length,
                            itemBuilder: (ctx, i) => PredefinedCategoryItem(
                              categories.predefinedItems[i],
                              addCategoryToSelection,
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () => {
                          submitCategories(context),
                        },
                        child: Text("Submit"),
                      )
                    ],
                  ),
      ),
    );
  }
}
