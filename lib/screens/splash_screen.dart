import 'package:delicat/models/category.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../providers/user.dart';
import '../routeNames.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 1), () async {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          bool? firstTime = prefs.getBool('firstTime');

      if (firstTime != null && !firstTime) {
        // NOT first time - load existing local data
        Provider.of<AppState>(context, listen: false).setFirstTime(false);

        // Load local user
        await Provider.of<User>(context, listen: false).loadLocalUser();

        // Load user's categories from local database
        await Provider.of<Categories>(context, listen: false).loadCategoriesFromLocal();
        List<Category> myCategories =
            Provider.of<Categories>(context, listen: false).categories;

        // Load recipes for each category from local database
        for (Category myCat in myCategories) {
          await Provider.of<Recipes>(context, listen: false).loadRecipesByCategory(myCat.id);
        }

        // Load favorite recipes
        await Provider.of<Recipes>(context, listen: false).loadFavoriteRecipes();

        Navigator.of(context)
            .pushReplacementNamed(RouterNames.CategoriesScreen);

      } else if (firstTime == null) {
        // FIRST time - set up new local user
        prefs.setBool('firstTime', false);

        // Set provider variable for button functionality
        Provider.of<AppState>(context, listen: false).setFirstTime(true);

        // Create a new local user (no server call)
        await Provider.of<User>(context, listen: false).createAndSetNewUser();


        Navigator.of(context)
            .pushReplacementNamed(RouterNames.CategoriesScreen);
      }
        } catch (e) {
          // Handle initialization errors gracefully
          print('Error during app initialization: $e');
          // Navigate to main screen anyway, app can function without perfect initialization
          Navigator.of(context)
              .pushReplacementNamed(RouterNames.CategoriesScreen);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffF1EBE8),
        ),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 100.0,
              child: Image(
                image: AssetImage("assets/logo/logo.png"),
              ),
            ),
            const Column(
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
    );
  }
}