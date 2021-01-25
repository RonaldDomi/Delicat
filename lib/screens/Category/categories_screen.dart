import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../providers/categories.dart';
import '../../routeNames.dart';
import '../../helpers/db_helper.dart';

import '../../widgets/categories_item.dart';
import '../other/screen_scaffold.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    List<Category> allCategories = Provider.of<Categories>(context).categories;
    return ScreenScaffold(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Container(
          color: Color(0xffF1EBE8),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Your Menu",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<Categories>(context)
                            .setIsOngoingCategoryNew(true);
                        Navigator.of(context)
                            .pushNamed(RouterNames.NewCategoryScreen);
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
              (allCategories.length <= 0)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text("you have no cats on your profile."),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          childAspectRatio: 2 / 2.6,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                        ),
                        padding: const EdgeInsets.all(30),
                        itemCount: allCategories.length,
                        itemBuilder: (ctx, i) => InkWell(
                          onTap: () {
                            // REROUTE TO RECIPELIST
                            Navigator.of(context).pushNamed(
                                RouterNames.RecipeListScreen,
                                arguments: allCategories[i].id);
                          },
                          child: CategoryItem(allCategories[i]),
                        ),
                      ),
                    ),
              // RaisedButton(
              //   child: Text("Drop user_categories table"),
              //   onPressed: clearTableData,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
