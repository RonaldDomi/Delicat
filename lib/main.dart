import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/meals.dart';
import './providers/categories.dart';

import './screens/meal_details_screen.dart';
import './screens/meal_list_screen.dart';
import './screens/new_cat_screen.dart';
import './screens/cat_selection_screen.dart';
import './screens/home_screen.dart';
import './screens/new_meal_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Meals(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
      ],
      child: MaterialApp(
        title: 'Delicat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        initialRoute: '/',
        routes: {
          NewMealScreen.routeName: (ctx) => NewMealScreen(),
          CatSelectionScreen.routeName: (ctx) => CatSelectionScreen(),
          NewCatScreen.routeName: (ctx) => NewCatScreen(),
          MealListScreen.routeName: (ctx) => MealListScreen(),
          MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(),
        },
      ),
    );
  }
}
