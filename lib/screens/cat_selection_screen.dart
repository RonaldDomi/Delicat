import 'package:flutter/material.dart';
// import 'package:delicat/providers/recipes.dart';
// import 'package:delicat/screens/home_screen.dart';
import 'package:delicat/providers/categories.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../widgets/categoy_item.dart';

class CatSelectionScreen extends StatefulWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  static const routeName = '/cat-selection';

  @override
  _CatSelectionScreenState createState() => _CatSelectionScreenState();
}

class _CatSelectionScreenState extends State<CatSelectionScreen> {
  List<Category> selectedCategories = [];

  void addCategoryToSelection(Category category) {
    var existingItem = selectedCategories.firstWhere(
        (itemToCheck) => itemToCheck.id == category.id,
        orElse: () => null);
    if (existingItem == null) {
      selectedCategories.add(category);
    } else {
      selectedCategories.removeWhere((item) => item.id == category.id);
    }
  }

  void submitCategories(context) {
    for (Category cat in selectedCategories) {
      Provider.of<Categories>(context)
          .addCategory(cat.id, cat.name, cat.colorCode);
      //
      //
      //
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
            .fetchAndSetCategories(),
        builder: (ctx, snapshotCategories) =>
            snapshotCategories.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        color: Colors.red,
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
                            itemCount: categories.items.length,
                            itemBuilder: (ctx, i) => CategoryItem(
                              categories.items[i].name,
                              categories.items[i].colorCode,
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
