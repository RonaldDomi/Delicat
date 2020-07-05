import 'package:flutter/material.dart';

import 'screens/cat_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/generating_cats_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/meal_details_screen.dart';
import 'screens/new_cat_screen.dart';
import 'screens/new_recipe_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'screens/recipe_details_screen.dart';

import 'screens/imaga_input_screen.dart';
import './routeNames.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsScreen());

      case RouterNames.ImageScreen:
        return MaterialPageRoute(builder: (_) => ImageScreen());
      case RouterNames.GeneratingCategoriesScreen:
        return MaterialPageRoute(builder: (_) => GeneratingCategoriesScreen());
      case RouterNames.SplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case RouterNames.NewCatScreen:
        return MaterialPageRoute(builder: (_) => NewCatScreen());
        break;
      case RouterNames.MealDetailsScreen:
        return MaterialPageRoute(builder: (_) => MealDetailsScreen());
      case RouterNames.CatSelectionScreen:
        return MaterialPageRoute(builder: (_) => CatSelectionScreen());

      case RouterNames.RecipeListScreen:
        String categoryId = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => RecipeListScreen(categoryId: categoryId));
        break;
      case RouterNames.NewRecipeScreen:
        List arguments = settings.arguments;
        String categoryName = arguments[0];
        String categoryColorCode = arguments[1];
        return MaterialPageRoute(
            builder: (_) => NewRecipeScreen(
                  categoryName: categoryName,
                  categoryColorCode: categoryColorCode,
                ));
      case RouterNames.RecipeDetailsScreen:
        String recipeId = settings.arguments;
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
