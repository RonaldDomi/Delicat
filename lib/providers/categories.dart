import 'package:delicat/models/category.dart';
// Remove these imports:
// import 'package:delicat/constants.dart' as constants;
// import 'dart:convert';
// import 'package:http_parser/http_parser.dart';
// import 'package:dio/dio.dart';
// import 'package:mime/mime.dart';
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Categories with ChangeNotifier {
  // ################################ VARIABLES ################################ //
  List<Category> _categories = [];
  List<Category> _predefinedCategories = [];
  Database? _database;

  // ################################ GETTERS ################################ //
  List<Category> get categories {
    return [..._categories];
  }

  List<Category> get predefinedCategories {
    return [..._predefinedCategories];
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

  Future<void> loadPredefinedCategories() async {
    // Create hardcoded predefined categories instead of fetching from server
    _predefinedCategories = [
      Category(
        id: 'breakfast',
        userId: 'predefined',
        recipes: [],
        name: 'Breakfast',
        photo: 'assets/photos/breakfast.jpg',
        colorCode: '#FF6B6B',
        colorLightCode: '#FFB3B3',
      ),
      Category(
        id: 'lunch',
        userId: 'predefined',
        recipes: [],
        name: 'Lunch',
        photo: 'assets/photos/pasta.jpg',
        colorCode: '#4ECDC4',
        colorLightCode: '#A8E6E1',
      ),
      Category(
        id: 'dinner',
        userId: 'predefined',
        recipes: [],
        name: 'Dinner',
        photo: 'assets/photos/meat.jpg',
        colorCode: '#45B7D1',
        colorLightCode: '#A2D5F2',
      ),
      Category(
        id: 'dessert',
        userId: 'predefined',
        recipes: [],
        name: 'Dessert',
        photo: 'assets/photos/dessert-circle.png',
        colorCode: '#F39C12',
        colorLightCode: '#F8C471',
      ),
    ];
    notifyListeners();
  }

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
    return _categories.singleWhere((element) => element.id == catId);
  }

  Future<void> removeCategory(String id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    _categories.removeWhere((item) => item.id == id);
    notifyListeners();
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
  }

  Future<void> addPredefinedCategory(Category category) async {
    // Copy predefined category to user's categories
    final newCategory = Category(
      id: const Uuid().v4(),
      userId: 'local',
      recipes: [],
      name: category.name,
      photo: category.photo,
      colorCode: category.colorCode,
      colorLightCode: category.colorLightCode,
    );

    await createCategory(newCategory);
  }
}