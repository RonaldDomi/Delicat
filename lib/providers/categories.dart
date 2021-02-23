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
  void setCategories(categories) {
    _categories = categories;
  }

  void setUserCategories(userCategories) {
    _categories = userCategories;
  }

  // ################################ FUNCTIONS ################################ //

  void fetchAndSetPredefinedCategories() async {
    String url = constants.url + "/Categories/default";
    try {
      final response = await http.get(url);
      for (var category in json.decode(response.body)) {
        var categoryToAdd = Category.fromMap(category);
        _predefinedCategories.add(categoryToAdd);
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void fetchAndSetCategories(String userId) async {
    String url = constants.url + "/Categories";
    try {
      final response = await http.get(url);
      for (var category in json.decode(response.body)) {
        if (category["userId"] == userId) {
          var categoryToAdd = Category.fromMap(category);
          _categories.add(categoryToAdd);
        }
      }
    } catch (error) {
      print("error: $error");
    }
  }

  Category getCategoryById(String catId) {
    final cat = _categories.singleWhere((element) => element.id == catId);
    //When we will have the option to share recipes online, we will have to implement this with api, but only for recipes. This version is MVP 1 consistent
    return cat;
  }

  Future<void> removeCategory(String id) async {
    String url = constants.url + "/Categories/$id";
    _categories.removeWhere((item) => item.id == id);
    notifyListeners();
    await http.delete(url);
  }

  Future<Category> editCategory(Category editedCategory, String userId) async {
    //TODO: extract IP as constant on top of file (when server changes etc)
    String url = constants.url + "/Categories/";
    url = url + editedCategory.id;

    FormData formData;
    // TODO: check if coming from server in a more roboust way, probably extract this into a constant at top of file
    if (editedCategory.photo.startsWith("https://delicat")) {
      formData = FormData.fromMap({
        "userId": userId,
        "name": editedCategory.name,
        "colorCode": editedCategory.colorCode,
        "photo": editedCategory.photo,
      });
    } else {
      final mimeTypeData =
          lookupMimeType(editedCategory.photo, headerBytes: [0xFF, 0xD8])
              .split('/');
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
      Category newCategory = Category.fromMap(response.data);

      final existingCategoryIndex =
          _categories.indexWhere((element) => element.id == editedCategory.id);
      _categories[existingCategoryIndex] = newCategory;
      notifyListeners();
      return newCategory;
    } catch (error) {
      print("error: $error");
    }
  }

  Future<Category> createCategory(Category category, String userId) async {
    String url = constants.url + "/Categories";
    final mimeTypeData =
        lookupMimeType(category.photo, headerBytes: [0xFF, 0xD8]).split('/');

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

      Category category = Category.fromMap(response.data);
      _categories.add(category);
      notifyListeners();
      return category;
    } catch (error) {
      // TODO: have toaster messages on the UI
      // toaster.show('There was an issue creating the category');
      print("error: $error");
    }
  }

  void addCategory(Category category, String userId) async {
    String url = constants.url + "/Categories";

    FormData formData = FormData.fromMap({
      "userId": userId,
      "name": category.name,
      "colorCode": category.colorCode,
      "photo_url": category.photo,
    });
    try {
      var response = await Dio().post(url, data: formData);
      response.data['default'] = false;
      response.data['userId'] = userId;
      Category category = Category.fromMap(response.data);
      _categories.add(category);
      notifyListeners();
    } catch (error) {
      print("error: ${error.message}");
      print("error: ${error.request}");
    }
  }
}
