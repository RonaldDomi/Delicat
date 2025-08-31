import 'package:delicat/models/recipe.dart';
import 'package:delicat/helpers/image_storage_helper.dart';

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
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE recipes(id TEXT PRIMARY KEY, name TEXT, photo TEXT, description TEXT, isFavorite INTEGER, categoryId TEXT, ingredients TEXT, photoSource TEXT, createdAt INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          // Add new columns for existing installations
          db.execute('ALTER TABLE recipes ADD COLUMN ingredients TEXT DEFAULT ""');
          db.execute('ALTER TABLE recipes ADD COLUMN photoSource TEXT DEFAULT "unknown"');
        }
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
      final recipe = _recipes.firstWhere(
        (recipe) => recipe.id == recipeId,
        orElse: () => throw Exception('Recipe with id $recipeId not found'),
      );
      _favoriteRecipes.add(recipe);
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
      ingredients: (map['ingredients'] as String? ?? '').split('|').where((s) => s.isNotEmpty).toList(),
      photoSource: map['photoSource'] as String? ?? 'unknown',
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
    try {
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
        ingredients: recipe.ingredients,
        photoSource: recipe.photoSource,
      );

      await db.insert('recipes', {
        'id': recipeWithId.id,
        'name': recipeWithId.name,
        'photo': recipeWithId.photo,
        'description': recipeWithId.description,
        'isFavorite': recipeWithId.isFavorite ? 1 : 0,
        'categoryId': categoryId,
        'ingredients': recipeWithId.ingredients.join('|'), // Store as pipe-separated string
        'photoSource': recipeWithId.photoSource,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      _recipes.add(recipeWithId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  Future<void> removeRecipe(String id) async {
    try {
      // Find the recipe to get its image info before deletion
      final Recipe? recipeToDelete = _recipes.cast<Recipe?>().firstWhere(
        (recipe) => recipe?.id == id,
        orElse: () => null,
      );
      
      final db = await database;
      await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
      _recipes.removeWhere((item) => item.id == id);
      _favoriteRecipes.removeWhere((item) => item.id == id);
      
      // Clean up Unsplash images after successful deletion
      if (recipeToDelete != null) {
        await ImageStorageHelper.safeDeleteUnsplashImage(
          recipeToDelete.photo, 
          recipeToDelete.photoSource
        );
      }
      
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to remove recipe: $e');
    }
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
        'ingredients': editedRecipe.ingredients.join('|'), // Store as pipe-separated string
        'photoSource': editedRecipe.photoSource,
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
      ingredients: (map['ingredients'] as String? ?? '').split('|').where((s) => s.isNotEmpty).toList(),
      photoSource: map['photoSource'] as String? ?? 'unknown',
    )).toList();

    notifyListeners();
  }

  List<Recipe> getRecipesByCategoryId(String categoryId) {
    var catRecipes =
        _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
    return catRecipes;
  }

  Recipe getRecipeById(String recipeId) {
    try {
      return _recipes.singleWhere(
        (element) => element.id == recipeId,
        orElse: () => throw Exception('Recipe with id $recipeId not found'),
      );
    } catch (e) {
      throw Exception('Error finding recipe: $e');
    }
  }

  List<Recipe> searchRecipesByIngredient(String ingredient) {
    if (ingredient.isEmpty) return [];
    
    return _recipes.where((recipe) {
      return recipe.ingredients.any((recipeIngredient) =>
        recipeIngredient.toLowerCase().contains(ingredient.toLowerCase()));
    }).toList();
  }
  
  Recipe? getRandomRecipe() {
      if (_recipes.isEmpty) return null;
      final random = DateTime.now().millisecondsSinceEpoch % _recipes.length;
      return _recipes[random];
  }

  Recipe? getRandomRecipeByCategory(String categoryId) {
      final categoryRecipes = getRecipesByCategoryId(categoryId);
      if (categoryRecipes.isEmpty) return null;
      final random = DateTime.now().millisecondsSinceEpoch % categoryRecipes.length;
      return categoryRecipes[random];
  } 

  Future<void> cleanupOrphanedFavorites() async {
    final validRecipeIds = _recipes.map((recipe) => recipe.id).toSet();
    final favoritesToRemove = _favoriteRecipes.where((recipe) => !validRecipeIds.contains(recipe.id)).toList();
    
    for (Recipe recipe in favoritesToRemove) {
      _favoriteRecipes.remove(recipe);
    }
    
    if (favoritesToRemove.isNotEmpty) {
      notifyListeners();
    }
  }

}
