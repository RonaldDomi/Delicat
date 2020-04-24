import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/recipes.dart';
import './providers/categories.dart';

import './screens/meal_details_screen.dart';
import './screens/recipe_list_screen.dart';
import './screens/new_cat_screen.dart';
import './screens/cat_selection_screen.dart';
import './screens/home_screen.dart';
import './screens/new_recipe_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Recipes(),
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
          CatSelectionScreen.routeName: (ctx) => CatSelectionScreen(),
          NewRecipeScreen.routeName: (ctx) => NewRecipeScreen(),
          NewCatScreen.routeName: (ctx) => NewCatScreen(),
          RecipeListScreen.routeName: (ctx) => RecipeListScreen(),
          MealDetailsScreen.routeName: (ctx) => MealDetailsScreen(),
        },
      ),
    );
  }
}
