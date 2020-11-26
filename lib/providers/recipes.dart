import 'package:flutter/material.dart';
import 'dart:math';

import '../helperFunctions.dart';
import '../helpers/db_helper.dart';

import '../models/recipe.dart';
// import '../models/category.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

  bool _isOngoingRecipeNew;
  String _currentNewRecipePhoto = "";
  Recipe _ongoingRecipe = Recipe();

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> get favoriteRecipes {
    return [..._favoriteRecipes];
  }

  void setIsNew(bool isNew) {
    _isOngoingRecipeNew = isNew;
  }

  bool getIsNew() {
    return _isOngoingRecipeNew;
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
      getRecipeById(recipeId).isFavorite = false;
      DBHelper.edit('recipe', recipeId, {
        // "id": editedCategory.id,
        // "name": editedCategory.name,
        // "photo": editedCategory.photo.path,
        // "photo": editedCategory.photo,
        // "color_code": editedCategory.colorCode,
        // "color_code_light": editedCategory.colorLightCode,
        "is_favorite": 0,
      });
    } else {
      _favoriteRecipes.add(
        _recipes.firstWhere((recipe) => recipe.id == recipeId),
      );
      getRecipeById(recipeId).isFavorite = true;
      DBHelper.edit('recipe', recipeId, {
        // "id": editedCategory.id,
        // "name": editedCategory.name,
        // "photo": editedCategory.photo.path,
        // "photo": editedCategory.photo,
        // "color_code": editedCategory.colorCode,
        // "color_code_light": editedCategory.colorLightCode,
        "is_favorite": 1,
      });
    }
    notifyListeners();
  }

  bool isRecipeFavorite(String recipeId) {
    Recipe recipe = getRecipeById(recipeId);
    if (recipe.isFavorite == true) {
      return true;
    }
    return false;
  }

  void addRecipe(Recipe newRecipe) async {
    var rng = new Random();
    var recId = rng.nextInt(1000).toString();
    Recipe addRecipe = Recipe(
      id: recId,
      name: newRecipe.name,
      photo: newRecipe.photo,
      isFavorite: newRecipe.isFavorite,
      description: newRecipe.description,
      categoryId: newRecipe.categoryId,
    );
    var isFav;
    if (newRecipe.isFavorite) {
      isFav = 1;
    } else {
      isFav = 0;
    }
    _recipes.add(addRecipe);
    DBHelper.insert('recipe', {
      "id": recId,
      "name": newRecipe.name,
      "photo": newRecipe.photo,
      "is_favorite": isFav,
      "description": newRecipe.description,
      "category_id": newRecipe.categoryId,
    });
    notifyListeners();
  }

  void removeRecipe(String id) {
    _recipes.removeWhere((item) => item.id == id);
    DBHelper.delete('recipe', id);
    notifyListeners();
  }

  void editRecipe(Recipe editedRecipe) {
    final recipeIndex =
        _recipes.indexWhere((item) => item.id == editedRecipe.id);
    _recipes[recipeIndex] = editedRecipe;

    var isFav;
    if (editedRecipe.isFavorite) {
      isFav = 1;
    } else {
      isFav = 0;
    }
    DBHelper.edit('recipe', editedRecipe.id, {
      "id": editedRecipe.id,
      "name": editedRecipe.name,
      "photo": editedRecipe.photo,
      "is_favorite": isFav,
      "description": editedRecipe.description,
      "category_id": editedRecipe.categoryId,
    });

    notifyListeners();
  }

  void fetchAndSetAllRecipes() async {
    final dataList = await DBHelper.getData('recipe');
    _recipes = dataList
        .map(
          (item) => Recipe(
            id: item['id'],
            categoryId: item['category_id'].toString(),
            description: item['description'],
            isFavorite: bitToBool(item['is_favorite']),
            name: item['name'],
            photo: item['photo'],
          ),
        )
        .toList();
  }

  List<Recipe> getRecipesByCategoryId(String categoryId) {
    var catRecps =
        _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
    return catRecps;
  }

  notifyListeners();

  void fetchAndSetFavoriteRecipes() async {
    // print("recipes: $_recipes");
    _favoriteRecipes =
        _recipes.where((recipe) => recipe.isFavorite == true).toList();
  }

  Recipe getRecipeById(String recipeId) {
    //Here we rely solely on the memory data. We take for granted that _recipes is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.
    return _recipes.singleWhere((element) => element.id == recipeId);
  }
}
