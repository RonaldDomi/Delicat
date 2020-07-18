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
      description: "Delicious very easy to make amazing breakfast serve with",
      photo: 'assets/photos/veggies.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "2",
      name: 'Pancakes 2',
      description: 'Fry the pancakes then eat.',
      photo: 'assets/photos/veggies.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "3",
      name: 'Pancakes 2 but better',
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.  Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      photo: 'assets/photos/veggies.jpg',
      categoryId: '1',
    ),
  ];
  List<Recipe> _favoriteRecipes = [
    Recipe(
      id: "2",
      name: 'Pancakes 2',
      description: 'Fry the pancakes then eat.',
      photo: 'assets/photos/veggies.jpg',
      categoryId: '1',
    ),
    Recipe(
      id: "3",
      name: 'Pancakes 2 but better',
      description: 'Fry the pancakes better then eat.',
      photo: 'assets/photos/veggies.jpg',
      categoryId: '1',
    ),
  ];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> get favoriteRecipes {
    return [..._favoriteRecipes];
  }

  String _currentNewRecipePhoto = "";
  Recipe _ongoingRecipe = Recipe();
  bool _isCurrentRecipeNew = true;
  bool _isCurrentRecipeEdited = false;
  void setIsNew(bool isNew) {
    _isCurrentRecipeNew = isNew;
  }

  bool getIsNew() {
    return _isCurrentRecipeNew;
    // return true;
  }

  void setIsEdited(bool isEdited) {
    _isCurrentRecipeEdited = isEdited;
  }

  bool getIsEdited() {
    return _isCurrentRecipeEdited;
    // return true;
  }

  String setCurrentNewRecipePhoto(String newPhoto) {
    _currentNewRecipePhoto = newPhoto;
  }

  String getCurrentNewRecipePhoto() {
    return _currentNewRecipePhoto;
  }

  void zeroCurrentPhoto() {
    _currentNewRecipePhoto = "";
  }

  void setOngoingRecipe(Recipe recipe) {
    _ongoingRecipe = recipe;
  }

  Recipe getOngoingRecipe() {
    return _ongoingRecipe;
  }

  void zeroOngoingRecipe() {
    _ongoingRecipe = Recipe();
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
      id: newRecipe.id,
      name: newRecipe.name,
      photo: newRecipe.photo,
      description: newRecipe.description,
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
            description: bodyRecipe.description,
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
