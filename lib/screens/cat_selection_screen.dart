import 'package:flutter/material.dart';
import 'package:delicat/providers/categories.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/predefined_categoy_item.dart';

class CatSelectionScreen extends StatefulWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  @override
  _CatSelectionScreenState createState() => _CatSelectionScreenState();
}

class _CatSelectionScreenState extends State<CatSelectionScreen> {
  List<Category> selectedCategories = [];

  void addCategoryToSelection(Category category) {
    print("-");
    print("--");
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
      print("-");
      print("--");
      print("trying to create a new category");
      print("--");
      print("-");
      Provider.of<Categories>(context).createCategory(cat);
    }
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false)
            .getAllPredefinedCategories(),
        builder: (ctx, snapshotCategories) => snapshotCategories
                    .connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : InkWell(
                onTap: () {},
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(241, 235, 232, 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontSize: 75,
                                      color: Color.fromRGBO(228, 217, 162, 1)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      child: Image(
                                        image: AssetImage(
                                            "assets/logo/logo-hdpi.png"),
                                      ),
                                    ),
                                    radius: 100.0,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "deli",
                                        style: TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                      Text(
                                        "cat",
                                        style: TextStyle(
                                          fontSize: 28,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Tell about your taste preferences"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SlidingUpPanel(
                      minHeight: 40,
                      maxHeight: 340,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      panel: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Color.fromRGBO(187, 153, 130, 1),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: SizedBox(
                                width: 86.0,
                                height: 7.0,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1)),
                              constraints: BoxConstraints.expand(height: 150),
                              child: Consumer<Categories>(
                                builder: (ctx, categories, _) =>
                                    GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 100,
                                    childAspectRatio: 5 / 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  itemCount: categories.predefinedItems.length,
                                  itemBuilder: (ctx, i) =>
                                      PredefinedCategoryItem(
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
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
