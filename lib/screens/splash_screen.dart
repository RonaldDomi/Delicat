import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

import '../providers/categories.dart';
import '../providers/recipes.dart';
import '../routeNames.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    await Provider.of<Recipes>(context).fetchAndSetAllRecipes();
    await Provider.of<Recipes>(context).fetchAndSetFavoriteRecipes();
    Provider.of<Categories>(context).fetchAndSetCategories();

    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool firstTime = prefs.getBool('first_time');
      if (firstTime != null && !firstTime) {
        Provider.of<Categories>(context).setFirstTime(false);
        Navigator.of(context)
            .pushReplacementNamed(RouterNames.CategoriesScreen);
      } else if (firstTime == null) {
        prefs.setBool('first_time', false);
        Provider.of<Categories>(context).setFirstTime(true);
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
