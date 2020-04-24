import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/recipe.dart';
import '../models/category.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get items {
    return [ ..._recipes ];
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

  Future<void> fetchAndSetRecipes() async {
    final dataList = await DBHelper.getData('user_recipes');

    //I need this to get all categories
    final categoryList = await DBHelper.getData('user_categories');
    print("Raw data category list from db is: ${categoryList.toString()}");
    //Map them to list
    List<Category> _cats = categoryList.map(
      (item) {
        print("Trying to map db data to object creation ${item.toString()}");
        print("We will create this category with id: ${item['id']}");
        Category createdCategory = Category(
          id: item['id'],
          name: item['name'],
          colorCode: item['colorCode'],
        );
        print("My created category is ${createdCategory.toString()} with id ${createdCategory.id}");
        return createdCategory;
      },
    ).toList();

    print("The cats in recipes provider are : ${_cats.toString()}");

    _recipes = dataList.map(
      (item) {
        //So then I can link the category manually to the created meals. This is a workaround to having properly relational tables in the database.
        //It needs to be fixed at some point
        print("item in dataList ${item.toString()}");
        print("_cats inside dataList recipes ${_cats.toString()}");
        Category recipeCategory;
        for(Category cat in _cats){
          print("the current cat is $cat");
          if(cat.id == int.parse(item['categoryId'])){
            print("found a matching category");
            recipeCategory = cat;
          }
        }
        print("the category for this recipeis ${recipeCategory.toString()}");
        // Category cat = _cats.firstWhere((cat) => cat.id == item['categoryId']);
        return Recipe(
          id: item['id'],
          name: item['name'],
          photo: File(item['photo']),
          instructions: item['instructions'],
          category: recipeCategory,
        );
      },
    ).toList();
    notifyListeners();
  }
}
