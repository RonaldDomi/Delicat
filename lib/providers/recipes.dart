import 'package:delicat/models/recipe.dart';
import 'package:delicat/constants.dart' as constants;

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];

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
      getRecipeById(recipeId).isFavorite = false;
      // TODO: Patch recipe with flipped isFavorite
    } else {
      _favoriteRecipes.add(
        _recipes.firstWhere((recipe) => recipe.id == recipeId),
      );
      getRecipeById(recipeId).isFavorite = true;
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
    String url = constants.url + '/recipes/byCategoryId/$categoryId';
    try {
      final response = await http.get(Uri.parse(url));
      for (var recipe in json.decode(response.body)) {
        var recipeToAdd = Recipe.fromMap(recipe);
        _recipes.add(recipeToAdd);
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void addRecipe(Recipe recipe, String categoryId) async {
    String url = constants.url + '/Recipes';

    final photo = recipe.photo;
    if (photo == null || photo.isEmpty){
      print("Error: Recipe photo is required for upload");
      return;
    }

    final mimeType = lookupMimeType(photo, headerBytes: [0xFF, 0xD8]);
    final mimeTypeData =
        mimeType?.split('/') ?? ['image', 'jpeg'];

    FormData formData = FormData.fromMap({
      "categoryId": categoryId,
      "name": recipe.name,
      "text": recipe.description,
      "isFavorite": recipe.isFavorite,
      "photo": await MultipartFile.fromFile(
        photo,
        filename: photo.split("/").last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      )
    });
    try {
      var response = await Dio().post(url, data: formData);

      Recipe recipe = Recipe.fromMap(response.data);
      _recipes.add(recipe);
      notifyListeners();
    } catch (error) {
      // TODO: have toaster messages on the UI
      // toaster.show('There was an issue creating the category');
      print("error: $error");
    }
  }

  void removeRecipe(String id) async {
    String url = constants.url + '/Recipes/$id';
    await http.delete(Uri.parse(url));
    _recipes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void editRecipe(Recipe editedRecipe) async {
    //TODO: extract IP as constant on top of file (when server changes etc)
    String url = constants.url + '/Recipes/';
    url = url + editedRecipe.id;

    final photo = editedRecipe.photo;
    if (photo == null){
      print("Error: Recipe photo is null");
      return;
    }

    final mimeType = lookupMimeType(photo, headerBytes: [0xFF, 0xD8]);
    final mimeTypeData = mimeType?.split('/') ?? ['image', 'jpeg'];

    // TODO: check if coming from server in a more roboust way, probably extract this into a constant at top of file
    FormData formData;
    if (photo.startsWith("https://delicat")) {
      formData = FormData.fromMap({
        "name": editedRecipe.name,
        "text": editedRecipe.description,
        "isFavorite": editedRecipe.isFavorite,
      });
    } else {
      formData = FormData.fromMap({
        "name": editedRecipe.name,
        "text": editedRecipe.description,
        "isFavorite": editedRecipe.isFavorite,
        "photo": await MultipartFile.fromFile(
          photo,
          filename: photo.split("/").last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        )
      });
    }

    try {
      var response = await Dio().patch(url, data: formData);
      Recipe new_category = Recipe.fromMap(response.data);

      final existingRecipeIndex =
          _recipes.indexWhere((element) => element.id == editedRecipe.id);
      _recipes[existingRecipeIndex] = new_category;
      notifyListeners();
    } catch (error) {
      print("error: $error");
    }
  }

  void fetchAndSetFavoriteRecipes() async {
    _favoriteRecipes =
        _recipes.where((recipe) => recipe.isFavorite == true).toList();
    notifyListeners();
  }

  List<Recipe> getRecipesByCategoryId(String categoryId) {
    // print("all recipes: $_recipes");
    var catRecps =
        _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
    return catRecps;
  }

  Recipe getRecipeById(String recipeId) {
    return _recipes.singleWhere((element) => element.id == recipeId);
  }
}
