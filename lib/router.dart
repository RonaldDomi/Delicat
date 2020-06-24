import 'package:flutter/material.dart';

import 'screens/cat_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_details_screen.dart';
import 'screens/new_cat_screen.dart';
import 'screens/new_recipe_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'screens/recipe_details_screen.dart';

import './routeNames.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsScreen());
      case RouterNames.SplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouterNames.NewCatScreen:
        return MaterialPageRoute(builder: (_) => NewCatScreen());
      case RouterNames.MealDetailsScreen:
        return MaterialPageRoute(builder: (_) => MealDetailsScreen());
      case RouterNames.CatSelectionScreen:
        return MaterialPageRoute(builder: (_) => CatSelectionScreen());
      case RouterNames.RecipeListScreen:
        var categoryId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => RecipeListScreen(categoryId: categoryId));
        break;
      case RouterNames.NewRecipeScreen:
        return MaterialPageRoute(builder: (_) => NewRecipeScreen());
      case RouterNames.RecipeDetailsScreen:
        var recipeId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => RecipeDetailsScreen(recipeId: recipeId));

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
