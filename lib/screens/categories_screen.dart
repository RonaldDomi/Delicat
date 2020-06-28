import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/categories.dart';
import '../routeNames.dart';

import '../widgets/categories_item.dart';

class CategoriesScreen extends StatefulWidget {
  Function changeView;

  CategoriesScreen(this.changeView);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  checkFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // It isn't the first time, so on rebuild just stay here

    } else if (firstTime == null) {
      prefs.setBool('first_time', false);
      Navigator.of(context)
          .pushReplacementNamed(RouterNames.CatSelectionScreen);
    }
    // Navigator.of(context).pushReplacementNamed(RouterNames.CatSelectionScreen);
  }

  flipFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('first_time', null);
    });
  }

  @override
  Widget build(BuildContext context) {
    checkFirstHitStatus();

    var selectedCats =
        Provider.of<Categories>(context, listen: false).getAllCategories();

    return FutureBuilder(
      future: selectedCats,
      builder: (ctx, snapshotCategories) => snapshotCategories
                  .connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Color(0xffF1EBE8),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Your Menu",
                          style: TextStyle(
                            fontSize: 23,
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            widget.changeView(4); //NewCatScreen
                          },
                          color: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            "add a new cat",
                            style: TextStyle(
                              color: Color(0xffF6C2A4),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<Categories>(
                      child: Center(
                        child: const Text("you have no cats on your profile."),
                      ),
                      builder: (ctx, categories, ch) =>
                          categories.items.length <= 0
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
                                  itemCount: categories.items.length,
                                  itemBuilder: (ctx, i) => InkWell(
                                    onTap: () => widget.changeView(
                                      0,
                                      categories.items[i].id,
                                    ), //RecipeList
                                    child: CategoryItem(categories.items[i]),
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
