import 'package:delicat/models/category.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Categories with ChangeNotifier {
  // ################################ VARIABLES ################################ //
  List<Category> _categories = [];
  Database? _database;

  // ################################ GETTERS ################################ //
  List<Category> get categories {
    return [..._categories];
  }

  // ################################ DATABASE SETUP ################################ //
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'delicat_categories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE categories(id TEXT PRIMARY KEY, name TEXT, photo TEXT, colorCode TEXT, colorLightCode TEXT, createdAt INTEGER)',
        );
      },
    );
  }

  // ################################ SETTERS ################################ //
  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setUserCategories(List<Category> userCategories) {
    _categories = userCategories;
    notifyListeners();
  }

  // ################################ LOCAL FUNCTIONS ################################ //

  Future<void> loadCategoriesFromLocal() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    _categories = maps.map((map) => Category(
      id: map['id'],
      userId: 'local',
      recipes: [], // Load recipes separately if needed
      name: map['name'],
      photo: map['photo'],
      colorCode: map['colorCode'],
      colorLightCode: map['colorLightCode'],
    )).toList();

    notifyListeners();
  }

  Category getCategoryById(String catId) {
    try {
      return _categories.singleWhere(
        (element) => element.id == catId,
        orElse: () => throw Exception('Category with id $catId not found'),
      );
    } catch (e) {
      throw Exception('Error finding category: $e');
    }
  }

  Future<void> removeCategory(String id) async {
    try {
      final db = await database;
      await db.delete('categories', where: 'id = ?', whereArgs: [id]);
      _categories.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to remove category: $e');
    }
  }

  Future<Category?> editCategory(Category editedCategory) async {
    final db = await database;

    await db.update(
      'categories',
      {
        'name': editedCategory.name,
        'photo': editedCategory.photo,
        'colorCode': editedCategory.colorCode,
        'colorLightCode': editedCategory.colorLightCode,
      },
      where: 'id = ?',
      whereArgs: [editedCategory.id],
    );

    final existingCategoryIndex =
        _categories.indexWhere((element) => element.id == editedCategory.id);
    if (existingCategoryIndex != -1) {
      _categories[existingCategoryIndex] = editedCategory;
    }
    notifyListeners();
    return editedCategory;
  }

  Future<Category?> createCategory(Category category) async {
    try {
      final db = await database;

      // Generate unique ID
      final String id = const Uuid().v4();
      final categoryWithId = Category(
        id: id,
        userId: 'local',
        recipes: [],
        name: category.name,
        photo: category.photo,
        colorCode: category.colorCode,
        colorLightCode: category.colorLightCode,
      );

      await db.insert('categories', {
        'id': categoryWithId.id,
        'name': categoryWithId.name,
        'photo': categoryWithId.photo,
        'colorCode': categoryWithId.colorCode,
        'colorLightCode': categoryWithId.colorLightCode,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      _categories.add(categoryWithId);
      notifyListeners();
      return categoryWithId;
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

}