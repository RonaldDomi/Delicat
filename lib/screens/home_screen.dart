import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';

import './new_meal_screen.dart';
import './cat_selection_screen.dart';
import './meal_details_screen.dart';
import './meal_list_screen.dart';
import './new_cat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Categories>(context).getFirstHitStatus();
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
