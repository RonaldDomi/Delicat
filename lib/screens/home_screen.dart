import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import '../providers/categories.dart';

import './new_meal_screen.dart';
import './cat_selection_screen.dart';
import './meal_details_screen.dart';
import './meal_list_screen.dart';
import './new_cat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    // var firstTime = Provider.of<Categories>(context).getFirstHitStatus();
    // Provider.of<Categories>(context).changeFirstTimeStatus();

    Widget _buildSwitchListTile(
      String title,
      String description,
      int currentValue,
      Function updateValue,
    ) {
      bool value = (currentValue == 0) ? false : true;
      return SwitchListTile(
        title: Text(title),
        value: value,
        subtitle: Text(
          description,
        ),
        onChanged: (boolValue) => {
          print(" "),
          print(""),
          print(" "),
          print("before onClick"),
          print(""),
          print(" "),
          print(""),
          // setState(() => {
          Provider.of<Categories>(context).editFirstHitStatus(),
          // }),
          print(" "),
          print(""),
          print(" "),
          print("after OnClick"),
          print(""),
          print(" "),
          print(""),
        },
      );
    }

    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Meals>(context, listen: false).fetchAndSetMeals(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Meals>(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Got no cats yet, start adding some!'),
                      RaisedButton(
                        onPressed: () =>
                            navigateTo(NewMealScreen.routeName, context),
                        child: Text("/new-meal"),
                      ),
                      RaisedButton(
                        onPressed: () =>
                            navigateTo(CatSelectionScreen.routeName, context),
                        child: Text("/cat-selection"),
                      ),
                      RaisedButton(
                        onPressed: () =>
                            navigateTo(MealDetailsScreen.routeName, context),
                        child: Text("/meal-details"),
                      ),
                      RaisedButton(
                        onPressed: () =>
                            navigateTo(MealListScreen.routeName, context),
                        child: Text("/meal-list"),
                      ),
                      RaisedButton(
                        onPressed: () =>
                            navigateTo(NewCatScreen.routeName, context),
                        child: Text("/new-cat"),
                      ),
                      FutureBuilder(
                        future: Provider.of<Categories>(context, listen: false)
                            .getFirstHitStatus(),
                        builder: (ctx, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: <Widget>[
                                      Divider(height: 20),
                                      _buildSwitchListTile(
                                        "Dev Tools mapRead['firstTime'] : ${snapshot.data}",
                                        "toogle show first time Cat Selection Screen",
                                        snapshot.data,
                                        () {},
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  ),
                ),
                builder: (ctx, meals, ch) => meals.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: meals.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              meals.items[i].photo,
                            ),
                          ),
                          title: Text(meals.items[i].name),
                          onTap: () {
                            // Go to detail page ...
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
