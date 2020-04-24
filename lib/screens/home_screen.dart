import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    prefs.setBool('first_time', null);
  }

  void navigateTo(routeName, BuildContext ctx) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    checkFirstHitStatus();
    var selectedCats =
        Provider.of<Categories>(context, listen: false).fetchAndSetCategories();
    print("selected cats inside home screen: $selectedCats");

    // Provider.of<Categories>(context).getFirstHitStatus();

    Widget _buildSwitchListTile(
      String title,
      String description,
      int currentValue,
    ) {
      bool value = (currentValue == 0) ? false : true;
      return SwitchListTile(
        title: Text(title),
        value: value,
        subtitle: Text(
          description,
        ),
        onChanged: (_) => {
          setState(() => {
                // Provider.of<Categories>(context).editFirstHitStatus(),
              }),
        },
      );
    }

    return Scaffold(
      body: FutureBuilder(
        // future: Provider.of<Meals>(context, listen: false).fetchAndSetMeals(),
        future: selectedCats,
        //       .fetchAndSetCategories(),
        builder: (ctx, snapshotCategories) =>
            snapshotCategories.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Categories>(
                    builder: (ctx, categories, ch) =>
                        categories.items.length <= 0
                            ? ch
                            : ListView.builder(
                                itemCount: categories.items.length,
                                itemBuilder: (ctx, i) => ListTile(
                                  title: Text(categories.items[i].name),
                                  onTap: () {
                                    // Go to detail page ...
                                  },
                                ),
                              ),
                  ),
      ),
    );

    // FutureBuilder(
    //   // future: Provider.of<Meals>(context, listen: false).fetchAndSetMeals(),
    //   future: selectedCats,
    // //       .fetchAndSetCategories(),
    //   builder: (ctx, snapshotCategories) => snapshotCategories
    //               .connectionState ==
    //           ConnectionState.waiting
    //       ? Center(
    //           child: CircularProgressIndicator(),
    //         )
    //       : Consumer<Categories>(
    //           child: Column(children: <Widget>[
    //             Text("$snapshotCategories")
    //           ],)
    //       )
    // ),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 const Text('Got no cats yet, start adding some!'),
    //                 RaisedButton(
    //                   onPressed: () =>
    //                       navigateTo(NewMealScreen.routeName, context),
    //                   child: Text("/new-meal"),
    //                 ),
    //                 // RaisedButton(
    //                 //   onPressed: () =>
    //                 //       navigateTo(CatSelectionScreen.routeName, context),
    //                 //   child: Text("/cat-selection"),
    //                 // ),
    //                 RaisedButton(
    //                   onPressed: () =>
    //                       navigateTo(MealDetailsScreen.routeName, context),
    //                   child: Text("/meal-details"),
    //                 ),
    //                 RaisedButton(
    //                   onPressed: () =>
    //                       navigateTo(MealListScreen.routeName, context),
    //                   child: Text("/meal-list"),
    //                 ),
    //                 RaisedButton(
    //                   onPressed: () =>
    //                       navigateTo(NewCatScreen.routeName, context),
    //                   child: Text("/new-cat"),
    //                 ),
    //                 FutureBuilder(
    //                   future: Provider.of<Categories>(context, listen: false)
    //                       .getFirstHitStatus(),
    //                   builder: (ctx, snapshotFirstHit) => snapshotFirstHit
    //                               .connectionState ==
    //                           ConnectionState.waiting
    //                       ? Center(
    //                           child: CircularProgressIndicator(),
    //                         )
    //                       : Column(
    //                           children: <Widget>[
    //                             Divider(height: 20),
    //                             _buildSwitchListTile(
    //                               "Dev Tools mapRead['firstTime'] : ${snapshotFirstHit.data}",
    //                               "toogle show first time Cat Selection Screen",
    //                               snapshotFirstHit.data,
    //                             ),
    //                             Divider(height: 40),
    //                             if (snapshotFirstHit.data == 1)
    //                               InkWell(
    //                                 onTap: () {
    //                                   Navigator.of(context).pushNamed(
    //                                       CatSelectionScreen.routeName);
    //                                 },
    //                                 borderRadius: BorderRadius.circular(20),
    //                                 splashColor: Colors.red,
    //                                 child: Container(
    //                                   height: 50,
    //                                   width: double.infinity,
    //                                   alignment: Alignment.center,
    //                                   child: Text(
    //                                     "Go to Cat Selection Screen",
    //                                     style: TextStyle(
    //                                       fontSize: 20,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                           ],
    //                         ),
    //                 ),
    //                 Divider(height: 20),
    //                 Text("yoo"),
    //                 // Text("$snapshotCategories"),
    //                 // ListView.builder(
    //                 //   itemCount: 2,
    //                 //   itemBuilder: (ctx, catDat) => Text("Hey yoo"),
    //                 // )
    //               ],
    //             ),
    //           ),
    // builder: (ctx, meals, ch) => meals.items.length <= 0
    //     ? ch
    //     : ListView.builder(
    //         itemCount: meals.items.length,
    //         itemBuilder: (ctx, i) => ListTile(
    //           leading: CircleAvatar(
    //             backgroundImage: FileImage(
    //               meals.items[i].photo,
    //             ),
    //           ),
    //           title: Text(meals.items[i].name),
    //           onTap: () {
    //             // Go to detail page ...
    //           },
    //         ),
    //       ),
    // ),
    // ),
  }
}
