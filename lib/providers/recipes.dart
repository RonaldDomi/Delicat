import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';
// import '../models/category.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [
    Recipe(
      id: "1",
      name: 'Blueberry Muffin',
      instructions: "Delicious very easy to make amazing breakfast serve with",
      photo:
          'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "2",
      name: 'Pancakes 2',
      instructions: 'Fry the pancakes then eat.',
      photo:
          'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "3",
      name: 'Pancakes 2 but better',
      instructions: 'Fry the pancakes better then eat.',
      photo:
          'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
      categoryId: '1',
    ),
  ];
  List<Recipe> _favoriteRecipes = [
    Recipe(
      id: "2",
      name: 'Pancakes 2',
      instructions: 'Fry the pancakes then eat.',
      photo:
          'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "3",
      name: 'Pancakes 2 but better',
      instructions: 'Fry the pancakes better then eat.',
      photo:
          'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
      categoryId: '1',
    ),
  ];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> get favoriteRecipes {
    return [..._favoriteRecipes];
  }

  void toggleFavorite(String recipeId) {
    final existingIndex =
        _favoriteRecipes.indexWhere((recipe) => recipe.id == recipeId);
    if (existingIndex >= 0) {
      _favoriteRecipes.removeAt(existingIndex);
    } else {
      _favoriteRecipes.add(
        _recipes.firstWhere((recipe) => recipe.id == recipeId),
      );
    }
    notifyListeners();
  }

  bool isRecipeFavorite(String id) {
    return _favoriteRecipes.any((recipe) => recipe.id == id);
  }

  void addRecipe(Recipe newRecipe) {
    Recipe addRecipe = Recipe(
      name: newRecipe.name,
      photo: newRecipe.photo,
      instructions: newRecipe.instructions,
      categoryId: newRecipe.categoryId,
    );

    _recipes.add(addRecipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _recipes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void editRecipe(Recipe editedRecipe) {
    final recipeIndex =
        _recipes.indexWhere((item) => item.id == editedRecipe.id);
    _recipes[recipeIndex] = editedRecipe;

    notifyListeners();
  }

  //We can do an eager load of the recipes at home screen
  //Alternatively we load recipes only when selecting the category, which is the default behavior
  Future<void> getRecipesByCategoryId(String categoryId) async {
    //Assuming this function is called when wanting to list recipes of a certain category, then the _recipe "store" variable
    //only holds the currenct category recipes

    const url =
        'category/{categoryId}/recipe/all'; //find string interpolation syntax for dart

    try {
      final response = await http.get(url);

      for (var bodyRecipe in json.decode(response.body)) {
        var recipe = Recipe(
            name: bodyRecipe.name,
            instructions: bodyRecipe.instructions,
            photo: bodyRecipe.photo,
            categoryId: bodyRecipe.category.uid);

        _recipes.add(recipe);
      }
      notifyListeners();
    } catch (error) {
      //if we have erorr with our request
      // throw error;

      await Future.delayed(const Duration(milliseconds: 250), () {});
      return _recipes;
    }
    notifyListeners();
  }

  Recipe getRecipeById(String recipeId) {
    //Here we rely solely on the memory data. We take for granted that _recipes is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.
    return _recipes.singleWhere((element) => element.id == recipeId);
  }
}
