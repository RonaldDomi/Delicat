import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/categories.dart';

import '../helpers/db_helper.dart';

import './new_recipe_screen.dart';
import './cat_selection_screen.dart';
import './meal_details_screen.dart';
import './recipe_list_screen.dart';
import './new_cat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  checkFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      // prefs.setBool('first_time', null);
      // Navigator.of(context).pushReplacementNamed(CatSelectionScreen.routeName);
    } else if (firstTime == null) {
      prefs.setBool('first_time', false);
      Navigator.of(context).pushReplacementNamed(CatSelectionScreen.routeName);
    }
  }

  flipFirstHitStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('first_time', null);
    });
  }

  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  void navigateToRecipes(routeName, BuildContext ctx, categoryId) {
    Navigator.of(ctx).pushNamed(routeName, arguments: {
      'categoryId':categoryId
    });
  }

  void clearTableData() {
    setState(() {
      DBHelper.truncateTable("user_categories"); //actually is truncateTable
    });
  }

  @override
  Widget build(BuildContext context) {
    checkFirstHitStatus();
    var selectedCats =
        Provider.of<Categories>(context, listen: false).fetchAndSetCategories();
    print("selected cats inside home screen: $selectedCats");

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: FutureBuilder(
        future: selectedCats,
        builder: (ctx, snapshotCategories) => snapshotCategories
                    .connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.red,

                    constraints: BoxConstraints.expand(height: 300),
                    child: Consumer<Categories>(
                      child: Center(
                        child: const Text("you have no cats on your profile."),
                      ),
                      builder: (ctx, categories, ch) =>
                          categories.items.length <= 0
                              ? ch
                              : ListView.builder(
                                  itemCount: categories.items.length,
                                  itemBuilder: (ctx, i) => Container(
                                    color:Color(int.parse(categories.items[i].colorCode)),
                                    child: ListTile(

                                      title: Text(categories.items[i].name),
                                      contentPadding: EdgeInsets.all(15),
                                      
                                      onTap: () {
                                        navigateToRecipes(RecipeListScreen.routeName, context, categories.items[i].id);
                                      },
                                    ),
                                  ),
                                ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Drop user_categories table"),
                    onPressed: clearTableData,
                  ),
                  RaisedButton(
                    child: Text("Flip first time status (you have to reload)"),
                    onPressed: flipFirstHitStatus,
                  ),
                ],
              ),
      ),
    );
  }
}
