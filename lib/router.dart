import 'package:flutter/material.dart';

import 'screens/cat_selection_screen.dart';
import 'screens/home_screen.dart';
import 'screens/meal_details_screen.dart';
import 'screens/new_cat_screen.dart';
import 'screens/new_recipe_screen.dart';
import 'screens/recipe_list_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case NewCatScreen.routeName:
        return MaterialPageRoute(builder: (_) => NewCatScreen());
      case RecipeListScreen.routeName:
        return MaterialPageRoute(builder: (_) => RecipeListScreen());
      case MealDetailsScreen.routeName:
        return MaterialPageRoute(builder: (_) => MealDetailsScreen());
      case CatSelectionScreen.routeName:
        return MaterialPageRoute(builder: (_) => CatSelectionScreen());
      case NewRecipeScreen.routeName:
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
