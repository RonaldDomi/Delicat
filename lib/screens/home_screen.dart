import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/meals.dart';
import './new_meal_screen.dart';

class HomeSceen extends StatelessWidget {
  const HomeSceen({Key key}) : super(key: key);

  void toNewMealScreen(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      NewMealScreen.routeName
    );
  }



  @override
  Widget build(BuildContext context) {

    var mealList = Provider.of<Meals>(context).items;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("Home Screen. We have ${mealList.length}"),
          ),
          RaisedButton(onPressed: () => toNewMealScreen(context), child: Text("Create new meal"),)
        ],
      ),
    );
  }
}
