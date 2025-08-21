import 'package:delicat/models/recipe.dart';
// Remove these imports:
// import 'package:delicat/constants.dart' as constants;
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Recipes with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favoriteRecipes = [];
  Database? _database;

  List<Recipe> get recipes {
    return [..._recipes];
  }

  List<Recipe> get favoriteRecipes {
    return [..._favoriteRecipes];
  }

  // ################################ DATABASE SETUP ################################ //
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'delicat_recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE recipes(id TEXT PRIMARY KEY, name TEXT, photo TEXT, description TEXT, isFavorite INTEGER, categoryId TEXT, createdAt INTEGER)',
        );
      },
    );
  }

  void toggleFavorite(String recipeId) {
    final existingIndex =
        _favoriteRecipes.indexWhere((recipe) => recipe.id == recipeId);
    if (existingIndex >= 0) {
      _favoriteRecipes.removeAt(existingIndex);
      getRecipeById(recipeId).isFavorite = false;
    } else {
      _favoriteRecipes.add(
        _recipes.firstWhere((recipe) => recipe.id == recipeId),
      );
      getRecipeById(recipeId).isFavorite = true;
    }

    // Update in database
    _updateRecipeFavoriteStatus(recipeId, getRecipeById(recipeId).isFavorite);
    notifyListeners();
  }

  Future<void> _updateRecipeFavoriteStatus(String recipeId, bool isFavorite) async {
    final db = await database;
    await db.update(
      'recipes',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  bool isRecipeFavorite(String recipeId) {
    Recipe recipe = getRecipeById(recipeId);
    if (recipe.isFavorite == true) {
      return true;
    }
    return false;
  }

  Future<void> loadRecipesByCategory(String categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    final categoryRecipes = maps.map((map) => Recipe(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      description: map['description'],
      isFavorite: map['isFavorite'] == 1,
      categoryId: map['categoryId'],
    )).toList();

    // Add to existing recipes (don't replace all)
    for (var recipe in categoryRecipes) {
      if (!_recipes.any((existingRecipe) => existingRecipe.id == recipe.id)) {
        _recipes.add(recipe);
      }
    }

    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe, String categoryId) async {
    final db = await database;

    // Generate unique ID
    final String id = const Uuid().v4();
    final recipeWithId = Recipe(
      id: id,
      name: recipe.name,
      photo: recipe.photo,
      description: recipe.description,
      isFavorite: recipe.isFavorite,
      categoryId: categoryId,
    );

    await db.insert('recipes', {
      'id': recipeWithId.id,
      'name': recipeWithId.name,
      'photo': recipeWithId.photo,
      'description': recipeWithId.description,
      'isFavorite': recipeWithId.isFavorite ? 1 : 0,
      'categoryId': categoryId,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    _recipes.add(recipeWithId);
    notifyListeners();
  }

  Future<void> removeRecipe(String id) async {
    final db = await database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
    _recipes.removeWhere((item) => item.id == id);
    _favoriteRecipes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> editRecipe(Recipe editedRecipe) async {
    final db = await database;

    await db.update(
      'recipes',
      {
        'name': editedRecipe.name,
        'photo': editedRecipe.photo,
        'description': editedRecipe.description,
        'isFavorite': editedRecipe.isFavorite ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [editedRecipe.id],
    );

    final existingRecipeIndex =
        _recipes.indexWhere((element) => element.id == editedRecipe.id);
    if (existingRecipeIndex != -1) {
      _recipes[existingRecipeIndex] = editedRecipe;
    }
    notifyListeners();
  }

  Future<void> loadFavoriteRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    _favoriteRecipes = maps.map((map) => Recipe(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      description: map['description'],
      isFavorite: true,
      categoryId: map['categoryId'],
    )).toList();

    notifyListeners();
  }

  List<Recipe> getRecipesByCategoryId(String categoryId) {
    var catRecipes =
        _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
    return catRecipes;
  }

  Recipe getRecipeById(String recipeId) {
    return _recipes.singleWhere((element) => element.id == recipeId);
  }
}