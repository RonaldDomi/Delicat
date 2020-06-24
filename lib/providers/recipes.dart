import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/recipe.dart';
// import '../models/category.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [
    Recipe(
        id: 1,
        name: 'Pancakes 1',
        instructions: 'Fry the pancakes then eat.',
        photo:
            'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
        categoryId: '1'),
    Recipe(
        id: 2,
        name: 'Pancakes 2',
        instructions: 'Fry the pancakes then eat.',
        photo:
            'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
        categoryId: '1'),
    Recipe(
        id: 3,
        name: 'Pancakes 3',
        instructions: 'Fry the pancakes then eat.',
        photo:
            'https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
        categoryId: '1'),
  ];

  List<Recipe> get items {
    return [..._recipes];
  }

  void addRecipe(name, photo, instructions, categoryId) {
    Recipe newRecipe = Recipe(
      name: name,
      photo: photo,
      instructions: instructions,
      categoryId: categoryId,
    );

    _recipes.add(newRecipe);
    notifyListeners();
  }

  void removeRecipe(id) {
    print("_recipes before removal: $_recipes");
    print("targeted id: $id");
    _recipes.removeWhere((item) => item.id == id);
    print("removed a recipe: new recipeList: $_recipes");
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
  Future<void> getRecipesByCategoryId(categoryId) async {
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

      await Future.delayed(const Duration(seconds: 2), () {});
      return _recipes;
    }
    notifyListeners();
  }

  Recipe getRecipeById(recipeId) {
    //Here we rely solely on the memory data. We take for granted that _recipes is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.
    print("recipeId : $recipeId, recipes: $_recipes");
    return _recipes.singleWhere((element) => element.id.toString() == recipeId);
  }
}
