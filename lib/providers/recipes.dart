import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

import '../other/helperFunctions.dart';
import '../helpers/db_helper.dart';

import 'package:http/http.dart' as http;
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

  void getSetRecipesByCategory(String categoryId) async {
    const url = 'http://54.195.158.131/recipes/byCategoryId/';
    try {
      final response = await http.get(url + categoryId);
      for (var recipe in json.decode(response.body)) {
        var recipeToAdd = Recipe(
          id: recipe["_id"],
          categoryId: recipe["categoryId"],
          isFavorite: recipe["isFavorite"],
          name: recipe["name"],
          photo: recipe["photo"],
          description: recipe["text"],
        );
        _recipes.add(recipeToAdd);
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void addRecipe(Recipe newRecipe, String categoryId) async {
    // const url = 'http://54.195.158.131/recipes/upload';
    const url = 'http://54.195.158.131/recipes';
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = json.encode({
      "categoryId": categoryId,
      "name": newRecipe.name,
      // "photo": newRecipe.photo,
      "text": newRecipe.description,
      "isFavorite": false,
    });

    print(body);

    Recipe addRecipe = Recipe(
      name: newRecipe.name,
      // photo: newRecipe.photo,
      isFavorite: false,
      description: newRecipe.description,
      categoryId: newRecipe.categoryId,
    );
    print("send response");
    var response = await http.post(url, headers: headers, body: body);
    String recipeId = json.decode(response.body)["_id"];
    // String recipePhoto = json.decode(response.body)["photo"];
    print("new id: $recipeId");
    addRecipe.id = recipeId;
    // addRecipe.photo = recipePhoto;

    _recipes.add(addRecipe);
    notifyListeners();
  }

  void removeRecipe(String id) async {
    _recipes.removeWhere((item) => item.id == id);
    var url = 'http://54.195.158.131/Recipes/$id';
    await http.delete(url);
    notifyListeners();
  }

  void editRecipe(Recipe editedRecipe) async {
    final recipeIndex =
        _recipes.indexWhere((item) => item.id == editedRecipe.id);
    _recipes[recipeIndex] = editedRecipe;

    const url = 'http://54.195.158.131/recipes';
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyPatch = "";
    bodyPatch = json.encode({
      "name": editedRecipe.name,
      "text": editedRecipe.description,
      // "photo": editedRecipe.photo,
    });
    // print(bodyPatch);
    await http.patch(url + "/${editedRecipe.id}",
        headers: headers, body: bodyPatch);

    notifyListeners();
  }

  List<Recipe> getRecipesByCategoryId(String categoryId) {
    print("all recipes: $_recipes");
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
