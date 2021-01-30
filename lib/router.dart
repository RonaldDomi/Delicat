import 'package:delicat/screens/Category/categories_screen.dart';
import 'package:delicat/screens/Category/category_selection_screen.dart';
import 'package:delicat/screens/Category/generating_categories_screen.dart';
import 'package:delicat/screens/Category/new_category_screen.dart';
import 'package:delicat/screens/Category/unsplash_screen.dart';
import 'package:delicat/screens/Favorites/favorites_screen.dart';
import 'package:delicat/screens/Recipe/recipe_photo_selection_screen.dart';
import 'package:delicat/screens/Recipe/new_recipe_screen.dart';
import 'package:delicat/screens/Recipe/recipe_details_screen.dart';
import 'package:delicat/screens/Recipe/recipe_list_screen.dart';
import 'package:delicat/screens/Search/search_screen.dart';
import 'package:delicat/screens/splash_screen.dart';
import 'package:delicat/routeNames.dart';

import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: RouteSettings(name: RouterNames.SplashScreen),
        );
      case RouterNames.CategoriesScreen:
        return MaterialPageRoute(
          builder: (_) => CategoriesScreen(),
          settings: RouteSettings(name: RouterNames.CategoriesScreen),
        );

      case RouterNames.UnsplashScreen:
        return MaterialPageRoute(builder: (_) => UnsplashScreen());
      case RouterNames.RecipePhotoSelectionScreen:
        List<String> arguments = settings.arguments;
        String colorCode = arguments[0];
        String name = arguments[1];
        String catId = arguments[2];
        return MaterialPageRoute(
            builder: (_) => RecipePhotoSelectionScreen(colorCode, name, catId));
      case RouterNames.FavoritesScreen:
        return MaterialPageRoute(builder: (_) => FavoritesScreen());
      case RouterNames.GeneratingCategoriesScreen:
        return MaterialPageRoute(builder: (_) => GeneratingCategoriesScreen());
      case RouterNames.SplashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case RouterNames.SearchScreen:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      case RouterNames.NewCategoryScreen:
        return MaterialPageRoute(
          builder: (_) => NewCategoryScreen(),
        );
        break;
      case RouterNames.CategoriesSelectionScreen:
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
        String categoryId = arguments[2];
        return MaterialPageRoute(
            builder: (_) => NewRecipeScreen(
                  categoryName: categoryName,
                  categoryColorCode: categoryColorCode,
                  categoryId: categoryId,
                ));
      case RouterNames.RecipeDetailsScreen:
        String recipeId = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => RecipeDetailsScreen(recipeId: recipeId),
        );

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
