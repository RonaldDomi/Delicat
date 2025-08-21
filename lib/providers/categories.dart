import 'package:delicat/models/category.dart';
import 'package:delicat/constants.dart' as constants;

import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Categories with ChangeNotifier {
  // ################################ VARIABLES ################################ //
  List<Category> _categories = [];
  List<Category> _predefinedCategories = [];

  // ################################ GETTERS ################################ //
  List<Category> get categories {
    return [..._categories];
  }

  List<Category> get predefinedCategories {
    return [..._predefinedCategories];
  }

  // ################################ SETTERS ################################ //
  void setCategories(List<Category> categories) {  // Fixed parameter type
    _categories = categories;
    notifyListeners();
  }

  void setUserCategories(List<Category> userCategories) {  // Fixed parameter type
    _categories = userCategories;
    notifyListeners();
  }

  // ################################ FUNCTIONS ################################ //

  Future<void> fetchAndSetPredefinedCategories() async {  // Added Future<void>
    String url = constants.url + "/Categories/default";
    try {
      final response = await http.get(Uri.parse(url));  // Fixed: Added Uri.parse()
      final List<dynamic> categoriesData = json.decode(response.body);

      _predefinedCategories.clear(); // Clear existing data
      for (var category in categoriesData) {
        var categoryToAdd = Category.fromMap(category);
        if (categoryToAdd != null) {  // Null check since fromMap can return null
          _predefinedCategories.add(categoryToAdd);
        }
      }
      notifyListeners();
    } catch (error) {
      print("error: $error");
    }
  }

  Future<void> fetchAndSetCategories(String userId) async {  // Added Future<void>
    String url = constants.url + "/Categories";
    try {
      final response = await http.get(Uri.parse(url));  // Fixed: Added Uri.parse()
      final List<dynamic> categoriesData = json.decode(response.body);

      _categories.clear(); // Clear existing data
      for (var category in categoriesData) {
        if (category["userId"] == userId) {
          var categoryToAdd = Category.fromMap(category);
          if (categoryToAdd != null) {  // Null check since fromMap can return null
            _categories.add(categoryToAdd);
          }
        }
      }
      notifyListeners();
    } catch (error) {
      print("error: $error");
    }
  }

  Category getCategoryById(String catId) {
    return _categories.singleWhere((element) => element.id == catId);
  }

  Future<void> removeCategory(String id) async {
    String url = constants.url + "/Categories/$id";
    _categories.removeWhere((item) => item.id == id);
    notifyListeners();
    try {
      await http.delete(Uri.parse(url));  // Fixed: Added Uri.parse()
    } catch (error) {
      print("Error deleting category: $error");
    }
  }

  Future<Category?> editCategory(Category editedCategory, String userId) async {  // Made return type nullable
    String url = constants.url + "/Categories/${editedCategory.id}";

    FormData formData;

    // TODO: check if coming from server in a more robust way, probably extract this into a constant at top of file
    if (editedCategory.photo.startsWith("https://delicat")) {
      formData = FormData.fromMap({
        "userId": userId,
        "name": editedCategory.name,
        "colorCode": editedCategory.colorCode,
        "photo": editedCategory.photo,
      });
    } else {
      // Fixed: Handle nullable mime type
      final mimeType = lookupMimeType(editedCategory.photo, headerBytes: [0xFF, 0xD8]);
      final mimeTypeData = mimeType?.split('/') ?? ['image', 'jpeg'];

      formData = FormData.fromMap({
        "userId": userId,
        "name": editedCategory.name,
        "colorCode": editedCategory.colorCode,
        "photo": await MultipartFile.fromFile(
          editedCategory.photo,
          filename: editedCategory.photo.split("/").last,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        )
      });
    }

    try {
      var response = await Dio().patch(url, data: formData);
      Category? newCategory = Category.fromMap(response.data);

      if (newCategory != null) {
        final existingCategoryIndex =
            _categories.indexWhere((element) => element.id == editedCategory.id);
        if (existingCategoryIndex != -1) {
          _categories[existingCategoryIndex] = newCategory;
        }
        notifyListeners();
        return newCategory;
      }
    } catch (error) {
      print("error: $error");
    }
    return null;  // Return null on error
  }

  Future<Category?> createCategory(Category category, String userId) async {  // Made return type nullable
    String url = constants.url + "/Categories";

    // Fixed: Handle nullable mime type
    final mimeType = lookupMimeType(category.photo, headerBytes: [0xFF, 0xD8]);
    final mimeTypeData = mimeType?.split('/') ?? ['image', 'jpeg'];

    FormData formData = FormData.fromMap({
      "userId": userId,
      "name": category.name,
      "colorCode": category.colorCode,
      "photo": await MultipartFile.fromFile(
        category.photo,
        filename: category.photo.split("/").last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      )
    });

    try {
      var response = await Dio().post(url, data: formData);
      Category? newCategory = Category.fromMap(response.data);

      if (newCategory != null) {
        _categories.add(newCategory);
        notifyListeners();
        return newCategory;
      }
    } catch (error) {
      // TODO: have toaster messages on the UI
      // toaster.show('There was an issue creating the category');
      print("error: $error");
    }
    return null;  // Return null on error
  }

  Future<void> addCategory(Category category, String userId) async {
    String url = constants.url + "/Categories";

    FormData formData = FormData.fromMap({
      "userId": userId,
      "name": category.name,
      "colorCode": category.colorCode,
      "photo_url": category.photo,
    });

    try {
      var response = await Dio().post(url, data: formData);

      // Add default properties to response data
      final responseData = response.data as Map<String, dynamic>;
      responseData['default'] = false;
      responseData['userId'] = userId;

      Category? newCategory = Category.fromMap(responseData);
      if (newCategory != null) {
        _categories.add(newCategory);
        notifyListeners();
      }
    } catch (error) {
      // Fixed: Handle Dio errors properly
      if (error is DioException) {
        print("Dio error: ${error.message}");
        print("Dio error request: ${error.requestOptions.path}");
      } else {
        print("error: $error");
      }
    }
  }
}