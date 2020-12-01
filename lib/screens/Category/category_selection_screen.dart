import 'package:delicat/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:delicat/providers/categories.dart';
import 'package:provider/provider.dart';

import '../../routeNames.dart';
import '../../models/category.dart';
import '../../widgets/predefined_categoy_item.dart';

class CatSelectionScreen extends StatefulWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  @override
  _CatSelectionScreenState createState() => _CatSelectionScreenState();
}

class _CatSelectionScreenState extends State<CatSelectionScreen> {
  List<Category> selectedCategories = [];

  bool isFirstTime;
  bool showButton = false;

  void addCategoryToSelection(Category category) {
    var existingItem = selectedCategories.firstWhere(
        (itemToCheck) => itemToCheck.id == category.id,
        orElse: () => null);
    if (existingItem == null) {
      selectedCategories.add(category);
    } else {
      selectedCategories.removeWhere((item) => item.id == category.id);
    }
    if (isFirstTime) {
      if (selectedCategories.length == 0) {
        setState(() {
          showButton = false;
        });
      } else {
        setState(() {
          showButton = true;
        });
      }
    }
  }

  void submitCategories(context) {
    // the button functionaily is over, so change the variable
    // #############
    if (isFirstTime) {
      Provider.of<Categories>(context).setFirstTime(false);
      isFirstTime = false;
    }

    // get our cats and our userUuid
    // add it to our user
    // #############
    var allOurCats = Provider.of<Categories>(context).categories;
    String userUuid = Provider.of<User>(context).getCurrentUserUuid;
    // add what category is not in our list
    for (Category cat in selectedCategories) {
      if (allOurCats.length != 0) {
        for (var myCat in allOurCats) {
          if (cat.name != myCat.name) {
            print("adding");
            Provider.of<Categories>(context).addCategory(cat, userUuid);
          }
        }
      } else {
        print("adding 2");
        Provider.of<Categories>(context).addCategory(cat, userUuid);
      }
    }
    Navigator.of(context)
        .pushReplacementNamed(RouterNames.GeneratingCategoriesScreen);
  }

  void didChangeDependencies() async {
    isFirstTime = Provider.of<Categories>(context).getFirstTime();
    if (!isFirstTime) {
      showButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF1EBE8),
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
                          color: Color(0xffE4D9A2),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                child: Image(
                                  image: AssetImage("assets/logo/logo.png"),
                                ),
                              ),
                              radius: 100.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (showButton)
                        RawMaterialButton(
                          onPressed: () {
                            submitCategories(context);
                          },
                          elevation: 2.0,
                          fillColor: Color(0xffE4D9A2),
                          child: Icon(
                            Icons.chevron_right,
                            size: 60.0,
                            color: Color(0xffBB9982),
                          ),
                          // padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("Tell about your taste preferences"),
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
                color: Color(0xffBB9982),
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
                    constraints: BoxConstraints.expand(height: 150),
                    child: Consumer<Categories>(
                      builder: (ctx, categories, _) => GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 5 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20,
                        ),
                        padding: const EdgeInsets.all(15),
                        itemCount: categories.predefinedCategories.length,
                        itemBuilder: (ctx, i) => PredefinedCategoryItem(
                          categories.predefinedCategories[i],
                          addCategoryToSelection,
                          selectedCategories
                              .contains(categories.predefinedCategories[i]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
