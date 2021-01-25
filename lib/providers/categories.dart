import 'dart:convert';

// import 'package:delicat/providers/user.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// import '../helpers/db_helper.dart';
import '../other/helperFunctions.dart';
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

  void setCategories(categories) {
    _categories = categories;
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

  void patchCategory(Category category, String photo) async {
    // var urlPatch = "http://54.195.158.131/categories/${category.id}";
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

  Future<void> removeCategory(String id) async {
    var url = 'http://54.195.158.131/Categories/$id';
    _categories.removeWhere((item) => item.id == id);
    await http.delete(url);
    notifyListeners();
  }

  Future<Category> editCategory(Category editedCategory, String userId) async {
    const urlPatch = 'http://54.195.158.131/Categories';
    const urlPatchUpload = 'http://54.195.158.131/categories/upload';

    Map<String, String> headers = {"Content-type": "application/json"};
    String bodyPatch = "";
    bodyPatch = json.encode({
      "userId": userId,
      "name": editedCategory.name,
      "colorCode": editedCategory.colorCode,
      "photo": editedCategory.photo,
    });
    print(bodyPatch);
    if (editedCategory.photo.startsWith('https://')) {
      try {
        await http.patch(urlPatch + "/${editedCategory.id}",
            headers: headers, body: bodyPatch);
      } catch (error) {
        print("error: $error");
      }
    } else {
      print("adding the local...");
      try {
        print("trying...");
        print("sending body: $bodyPatch");
        var response = await http.patch(
            urlPatchUpload + "/${editedCategory.id}",
            headers: headers,
            body: bodyPatch);
        String catPhoto = json.decode(response.body)["photo"];
      } catch (error) {
        print("trying but...");
        print("error: $error");
      }
    }
    final existingCategoryIndex =
        _categories.indexWhere((element) => element.id == editedCategory.id);

    _categories[existingCategoryIndex] = editedCategory;
    notifyListeners();
    return editedCategory;
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
      print(category);
      _categories.add(category);
      notifyListeners();
      return category;
    } catch (error) {
      print("error: $error");
    }
  }

  void addCategory(Category category, String userId) async {
    const url = 'http://54.195.158.131/Categories';
    print(category.photo);
    FormData formData = FormData.fromMap({
      "userId": userId,
      "name": category.name,
      "colorCode": category.colorCode,
      "photo_url": category.photo,
    });
    try {
      var response = await Dio().post(url, data: formData);
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
