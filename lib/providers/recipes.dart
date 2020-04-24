import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/recipe.dart';
import '../models/category.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get items {
    return [..._recipes];
  }

  void addRecipe(name, photo, instructions, category) {
    Recipe newRecipe = Recipe(
      name: name,
      photo: photo,
      instructions: instructions,
      category: category,
    );

    _recipes.add(newRecipe);
    notifyListeners();

    DBHelper.insert('user_recipes', {
      'id': newRecipe.id,
      'name': newRecipe.name,
      'photo': newRecipe.photo.path,
      'instructions': newRecipe.instructions,
      'category_id': newRecipe.category.id,
    });
  }

  void removeRecipe(id) {
    _recipes.removeWhere((item) => item.id == id);

    notifyListeners();

    DBHelper.delete('user_recipes', id);
  }

  void editRecipe(id, Recipe editedRecipe) {
    final recipeIndex = _recipes.indexWhere((item) => item.id == id);
    _recipes[recipeIndex] = editedRecipe;

    notifyListeners();

    DBHelper.edit('user_recipes', id, {
      'id': editedRecipe.id,
      'name': editedRecipe.name,
      'photo': editedRecipe.photo.path,
      'instructions': editedRecipe.instructions,
      'category_id': editedRecipe.category.id,
    });
  }

  Future<void> fetchAndSetRecipesByCategory(categoryId) async {
    final dataList = await DBHelper.getData('user_recipes');

    //I need this to get all categories
    final categoryList = await DBHelper.getData('user_categories');
    //Map them to list
    List<Category> _cats = categoryList.map(
      (item) {
        Category createdCategory = Category(
          id: item['id'],
          name: item['name'],
          colorCode: item['colorCode'],
        );
        return createdCategory;
      },
    ).toList();

    _recipes = [];
    _recipes = dataList.map(
      (item) {
        //So then I can link the category manually to the created meals. This is a workaround to having properly relational tables in the database.
        //It needs to be fixed at some point
        print("This recipe has categoryId of ${item['categoryId']}");
        for (Category cat in _cats) {
          if (int.parse(item['categoryId']) == categoryId) {
            print("Returning a recipe for category $categoryId");

            Recipe recipe = Recipe(
              id: item['id'],
              name: item['name'],
              photo: File(item['photo']),
              instructions: item['instructions'],
              category: cat,
            );
            print("recipe is $recipe");
            return recipe;
          }
          print("first run, _recipes length is ${_recipes.length}");
        }

        // Category cat = _cats.firstWhere((cat) => cat.id == item['categoryId']);
      },
    ).toList();

    if(_recipes[0]==null){
      print("probabkly no recipes found, but map returns null anyawy");
      _recipes = [];
    }
    notifyListeners();
  }
}
