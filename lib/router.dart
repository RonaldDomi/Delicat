import 'package:flutter/material.dart';

import 'screens/cat_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/meal_details_screen.dart';
import 'screens/new_cat_screen.dart';
import 'screens/new_recipe_screen.dart';
import 'screens/recipe_list_screen.dart';

import './routeNames.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouterNames.NewCatScreen:
        return MaterialPageRoute(builder: (_) => NewCatScreen());
      case RouterNames.RecipeListScreen:
        return MaterialPageRoute(builder: (_) => RecipeListScreen());
      case RouterNames.MealDetailsScreen:
        return MaterialPageRoute(builder: (_) => MealDetailsScreen());
      case RouterNames.CatSelectionScreen:
        return MaterialPageRoute(builder: (_) => CatSelectionScreen());
      case RouterNames.NewRecipeScreen:
        return MaterialPageRoute(builder: (_) => NewRecipeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}.'),
            ),
          ),
        );
    }
  }
}
