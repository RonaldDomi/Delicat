import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../providers/user.dart';
import '../routeNames.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // await Provider.of<Recipes>(context).fetchAndSetAllRecipes();
    // await Provider.of<Recipes>(context).fetchAndSetFavoriteRecipes();
    // Provider.of<Categories>(context).fetchAndSetCategories();
    await Provider.of<Categories>(context).fetchAndSetPredefinedCategories();
    // ###########
    // when you open the app, either if it is the first time or not, we should get the predefined categories
    // -- when it is the first time, to let the user chose
    // -- when it is not, to let the user create a new category, choosing one the predefined
    // ###########

    Future.delayed(Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool firstTime = prefs.getBool('firstTime');
      // firstTime = null;

      //
      //
      if (firstTime != null && !firstTime) {
        // set the button functionality variable to false
        // ###########
        Provider.of<Categories>(context).setFirstTime(false);

        // get the current user
        // ###########
        String currentUser = prefs.getString('userUuid');
        Provider.of<User>(context).setCurrentUserUuid(currentUser);

        // get all categories, then set only the user categories
        // ###########
        List<Category> allCategories =
            await Provider.of<Categories>(context).fetchAndSetAllCategories();
        List<Category> userCategories = [];
        for (var category in allCategories) {
          if (category.userUuid == currentUser) {
            userCategories.add(category);
          }
        }
        Provider.of<Categories>(context).setUserCategories(userCategories);

        Navigator.of(context)
            .pushReplacementNamed(RouterNames.CategoriesScreen);
        //
        //
      } else if (firstTime == null) {
        // ###########
        // it is the first time, we should update the localstorage for the next time
        // ###########
        prefs.setBool('firstTime', false);

        // provider variable, for the functionality of the button
        // the button should be shown when at least one predefined category is selected
        // ###########
        Provider.of<Categories>(context).setFirstTime(true);

        // create a new user in the backend
        // ###########
        await Provider.of<User>(context).createNewUser();
        String newUser = Provider.of<User>(context).getCurrentUserUuid;

        // set the user in the localstorage
        // ###########
        prefs.setString('userUuid', newUser);

        Navigator.of(context)
            .pushReplacementNamed(RouterNames.CategoriesSelectionScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF1EBE8),
        ),
        child: Container(
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
                    "delicacy",
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    "catalogue",
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
    );
  }
}
