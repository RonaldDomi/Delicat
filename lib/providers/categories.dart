import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../other/colorHelperFunctions.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> _predefinedCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  void setCategories(categories) {
    _categories = categories;
  }

  List<Category> get predefinedCategories {
    return [..._predefinedCategories];
  }

  void setUserCategories(userCategories) {
    _categories = userCategories;
  }

  void fetchAndSetPredefinedCategories() async {
    const url = 'http://54.195.158.131/categories/default';
    try {
      final response = await http.get(url);
      for (var category in json.decode(response.body)) {
        var categoryToAdd = Category(
          recipes: [],
          id: category["_id"],
          name: category["name"],
          photo: category["photo"],
          colorCode: category["colorCode"],
          colorLightCode: colorToHex(TinyColor(
            hexToColor("${category["colorCode"]}"),
          ).brighten(14).color),
        );
        _predefinedCategories.add(categoryToAdd);
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void fetchAndSetCategories(String userId) async {
    const url = 'http://54.195.158.131/categories';
    try {
      final response = await http.get(url);
      for (var category in json.decode(response.body)) {
        if (category["userId"] == userId) {
          var categoryToAdd = Category(
            recipes: [],
            id: category["_id"],
            userId: category["userId"],
            name: category["name"],
            photo: category["photo"],
            colorCode: category["colorCode"],
            colorLightCode: colorToHex(TinyColor(
              hexToColor("${category["colorCode"]}"),
            ).brighten(14).color),
          );
          _categories.add(categoryToAdd);
        }
      }
    } catch (error) {
      print("error: $error");
    }
  }

  void commentedFunctions() {
    /*
    Future<List<Category>> getAllCategories() async {
      // AWS should try and give us something of the shape:
      // [
      //   { 'uid' : 'x',
      //   'name' : 'x',
      //   'photo' : 'x',
      //   'colorCode' : 'x',
      //   'recipes' : [{}{}]
      //   },
      //  { another cateogry object ... }
      // ]
      const url = '/category/all';

      try {
        final response = await http.get(url);

        for (var category in json.decode(response.body)) {
          //purge existing categories
          _categories = [];
          //then load again with data coming from server

          //now we create a Category model object from the json data
          var categoryToAdd =
              Category(name: category.name, colorCode: category.colorCode);

          //finally we add each parsed category object to our master list
          _categories.add(categoryToAdd);
        }
        notifyListeners();
      } catch (error) {
        //if we have erorr with our request
        // throw error;

        final dataList = await DBHelper.getData('category');
        _categories = dataList
            .map(
              (item) => Category(
                id: item['id'],
                colorCode: item['color_code'],
                colorLightCode: item['color_code_light'],
                name: item['name'],
                photo: item['photo'],
              ),
            )
            .toList();
        return _categories;
      }
    }
  */
  }

  Category getCategoryById(String catId) {
    //Here we rely solely on the memory data. We take for granted that _categories is already loaded with the up-to-date
    //data from the server. For our app, this should work as intended.

    final cat = _categories.singleWhere((element) => element.id == catId);
    //When we will have the option to share recipes online, we will have to implement this with api, but only for recipes. This version is MVP 1 consistent
    return cat;
  }

  Future<void> removeCategory(String id) async {
    var url = 'http://54.195.158.131/Categories/$id';
    _categories.removeWhere((item) => item.id == id);
    await http.delete(url);
    notifyListeners();
  }

  Future<Category> editCategory(Category editedCategory, String userId) async {
    //TODO: extract IP as constant on top of file (when server changes etc)
    String url = 'http://54.195.158.131/Categories/';
    url = url + editedCategory.id;

    FormData formData;
    // TODO: check if coming from server in a more roboust way, probably extract this into a constant at top of file
    if (editedCategory.photo.startsWith("https://delicat")) {
      formData = FormData.fromMap({
        "userId": userId,
        "name": editedCategory.name,
        "colorCode": editedCategory.colorCode,
        "photo_url": editedCategory.photo,
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
      Category new_category = Category.fromMap(response.data);

      final existingCategoryIndex =
          _categories.indexWhere((element) => element.id == editedCategory.id);
      _categories[existingCategoryIndex] = new_category;
      notifyListeners();
      return new_category;
    } catch (error) {
      print("error: $error");
    }
  }

  Future<Category> createCategory(Category category, String userId) async {
    const url = 'http://54.195.158.131/Categories';
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
    const url = 'http://54.195.158.131/Categories';
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
      print(category);
      _categories.add(category);
      notifyListeners();
    } catch (error) {
      print("error: ${error.message}");
      print("error: ${error.request}");
    }
  }
}
