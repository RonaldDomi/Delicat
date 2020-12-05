import 'dart:convert';

import 'package:delicat/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../helpers/db_helper.dart';
import '../helperFunctions.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  Category ongoingCategory = Category();
  String _currentNewCategoryPhoto = "";
  bool _isOngoingCategoryNew;
  bool _firstTime;

  List<Category> _categories = [
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Dessert',
    //   colorCode: '#E5C1CB',
    //   photo: "assets/photos/dessert-circle.png",
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#E5C1CB"),
    //   ).brighten(14).color),
    // ),
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Vegetable',
    //   colorCode: '#DDE5B0',
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#DDE5B0"),
    //   ).brighten(14).color),
    //   photo: "assets/photos/vegetable-circle.png",
    // ),
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Breakfast',
    //   colorCode: '#ABBFB5',
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#ABBFB5"),
    //   ).brighten(14).color),
    //   photo: "assets/photos/breakfast-circle.png",
    // ),
  ];

  List<Category> _predefinedCategories = [
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Dessert',
    //   colorCode: '#E5C1CB',
    //   photo: "assets/photos/dessert-circle.png",
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#E5C1CB"),
    //   ).brighten(14).color),
    // ),
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Vegetable',
    //   colorCode: '#DDE5B0',
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#DDE5B0"),
    //   ).brighten(14).color),
    //   photo: "assets/photos/vegetable-circle.png",
    // ),
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Breakfast',
    //   colorCode: '#ABBFB5',
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#ABBFB5"),
    //   ).brighten(14).color),
    //   photo: "assets/photos/breakfast-circle.png",
    // ),
    // Category(
    //   id: Uuid().v4(),
    //   name: 'Burger',
    //   colorCode: '#1B2E46',
    //   colorLightCode: colorToHex(TinyColor(
    //     hexToColor("#1B2E46"),
    //   ).brighten(14).color),
    //   photo: "assets/photos/burgers-circle.png",
    // ),
  ];

  List<Category> get categories {
    return [..._categories];
  }

  String get currentNewCategoryPhoto {
    return _currentNewCategoryPhoto;
  }

  void setCurrentNewCategoryPhoto(String newPhoto) {
    _currentNewCategoryPhoto = newPhoto;
  }

  String getCurrentNewCategoryPhoto() {
    return _currentNewCategoryPhoto;
  }

  void setIsOngoingCategoryNew(bool isNew) {
    _isOngoingCategoryNew = isNew;
  }

  void setFirstTime(bool firstTime) {
    _firstTime = firstTime;
  }

  bool getFirstTime() {
    return _firstTime;
  }

  bool getIsOngoingCategoryNew() {
    return _isOngoingCategoryNew;
  }

  void zeroCurrentPhoto() {
    _currentNewCategoryPhoto = "";
  }

  void setOngoingCategory(Category category) {
    ongoingCategory = category;
  }

  Category getOngoingCategory() {
    return ongoingCategory;
  }

  void zeroOngoingCategory() {
    ongoingCategory = Category();
  }

  List<Category> get predefinedCategories {
    return [..._predefinedCategories];
  }

  Future<List<Category>> fetchAndSetAllCategories() async {
    const url = 'http://54.77.35.193/categories';
    try {
      final response = await http.get(url);
      List<Category> newList = [];
      for (var category in json.decode(response.body)) {
        var categoryToAdd = Category(
          recipes: [],
          id: category["uuid"],
          userUuid: category["userUuid"],
          name: category["name"],
          photo: category["photo"],
          colorCode: category["colorCode"],
          colorLightCode: colorToHex(TinyColor(
            hexToColor("${category["colorCode"]}"),
          ).brighten(14).color),
        );

        newList.add(categoryToAdd);
      }
      return newList;
    } catch (error) {
      print("error: $error");
    }
  }

  void setUserCategories(userCategories) {
    _categories = userCategories;
  }

  void fetchAndSetPredefinedCategories() async {
    const url = 'http://54.77.35.193/categories';
    try {
      final response = await http.get(url);
      for (var category in json.decode(response.body)) {
        var categoryToAdd = Category(
          id: category["uuid"],
          userUuid: category["userUuid"],
          name: category["name"],
          photo: category["photo"],
          colorCode: category["colorCode"],
          colorLightCode: colorToHex(TinyColor(
            hexToColor("${category["colorCode"]}"),
          ).brighten(14).color),
        );
        if (category['default'] != null && category['default'] != false) {
          _predefinedCategories.add(categoryToAdd);
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

  Future<Category> createCategory(Category category, String userUuid) async {
    const urlPost = 'http://54.77.35.193/Categories';
    const urlPostUpload = 'http://54.77.35.193/categories/upload';
    String newUuid = Uuid().v4();
    final newCategory = Category(
      id: newUuid,
      name: category.name,
      colorCode: category.colorCode,
      colorLightCode: category.colorLightCode,
      recipes: [],
      userUuid: userUuid,
    );
    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyPost = "";
    bodyPost = json.encode({
      "recipes": [],
      "uuid": newUuid,
      "userUuid": userUuid,
      "name": category.name,
      "photo": category.photo,
      "colorCode": category.colorCode,
      "default": false,
    });
    if (category.photo.startsWith('https://')) {
      try {
        await http.post(urlPost, headers: headers, body: bodyPost);
        newCategory.photo = category.photo;
        _categories.add(newCategory);
      } catch (error) {
        print("error: $error");
      }
    } else {
      try {
        var response =
            await http.post(urlPostUpload, headers: headers, body: bodyPost);
        String catPhoto = json.decode(response.body)["photo"];
        print("$catPhoto");
        newCategory.photo = catPhoto;
        _categories.add(newCategory);
      } catch (error) {
        print("error: $error");
      }
    }
    notifyListeners();
    return newCategory;
  }

  void patchCategory(Category category, String photo) async {
    // var urlPatch = "http://54.77.35.193/categories/${category.id}";
    // Map<String, String> headers = {"Content-type": "application/json"};
    // String bodyPatch = json.encode({
    //   "uuid": category.id,
    //   "photo": photo,
    // });
    // try {
    //   var reponse =
    //       await http.post(urlPatch, headers: headers, body: bodyPatch);
    //   print(reponse.body);
    // } catch (error) {
    //   print("error: $error");
    // }

    // notifyListeners();
  }

  void addCategory(Category category, String userUuid) async {
    const url = 'http://54.77.35.193/Categories';

    String newUuid = Uuid().v4();
    Map<String, String> headers = {"Content-type": "application/json"};
    String body = json.encode({
      "recipes": [],
      "uuid": newUuid,
      "userUuid": userUuid,
      "name": category.name,
      "photo": category.photo,
      "colorCode": category.colorCode,
      "default": false,
    });
    try {
      await http.post(url, headers: headers, body: body);
      _categories.add(Category(
        id: newUuid,
        userUuid: userUuid,
        recipes: [],
        name: category.name,
        photo: category.photo,
        colorCode: category.colorCode,
      ));
      notifyListeners();
    } catch (error) {
      print("error: $error");
    }
  }

  Future<void> removeCategory(String id) async {
    var url = 'http://54.77.35.193/Categories/$id';
    _categories.removeWhere((item) => item.id == id);
    await http.delete(url);
    notifyListeners();
  }

  Future<void> editCategory(Category editedCategory) {
    final existingCategoryIndex =
        _categories.indexWhere((element) => element.id == editedCategory.id);

    _categories[existingCategoryIndex] = editedCategory;

    DBHelper.edit('category', editedCategory.id, {
      "id": editedCategory.id,
      "name": editedCategory.name,
      // "photo": editedCategory.photo.path,
      "photo": editedCategory.photo,
      "color_code": editedCategory.colorCode,
      "color_code_light": editedCategory.colorLightCode,
    });

    notifyListeners();
  }
}
