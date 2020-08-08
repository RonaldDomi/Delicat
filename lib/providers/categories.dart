import 'dart:math';

import 'package:tinycolor/tinycolor.dart';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../helperFunctions.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  Category ongoingCategory = Category();
  String _currentNewCategoryPhoto = "";
  bool _isOngoingCategoryNew;
  bool _firstTime;

  List<Category> _categories = [];

  List<Category> _predefinedCategories = [
    Category(
      id: "1",
      name: 'Dessert',
      colorCode: '#E5C1CB',
      photo: "assets/photos/dessert-circle.png",
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#E5C1CB"),
      ).brighten(14).color),
    ),
    Category(
      id: "2",
      name: 'Vegetable',
      colorCode: '#DDE5B0',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#DDE5B0"),
      ).brighten(14).color),
      photo: "assets/photos/vegetable-circle.png",
    ),
    Category(
      id: "3",
      name: 'Breakfast',
      colorCode: '#ABBFB5',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#ABBFB5"),
      ).brighten(14).color),
      photo: "assets/photos/breakfast-circle.png",
    ),
    Category(
      id: "4",
      name: 'Burger',
      colorCode: '#1B2E46',
      colorLightCode: colorToHex(TinyColor(
        hexToColor("#1B2E46"),
      ).brighten(14).color),
      photo: "assets/photos/burgers-circle.png",
    ),
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

  List<Category> get predefinedItems {
    return [..._predefinedCategories];
  }

  void fetchAndSetCategories() async {
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

  void createCategory(Category category) {
    var rng = new Random();
    final newCategory = Category(
      id: rng.nextInt(1000).toString(),
      name: category.name,
      photo: category.photo,
      colorCode: category.colorCode,
      colorLightCode: category.colorLightCode,
    );
    _categories.add(newCategory);
    DBHelper.insert('category', {
      "id": newCategory.id,
      "name": newCategory.name,
      // "photo": newCategory.photo.path,
      "photo": newCategory.photo,
      "color_code": newCategory.colorCode,
      "color_code_light": newCategory.colorLightCode,
    });

    notifyListeners();
  }

  void addCategory(Category category) {
    _categories.add(category);
    DBHelper.insert('category', {
      "id": category.id,
      "name": category.name,
      "photo": category.photo,
      "color_code": category.colorCode,
      "color_code_light": category.colorLightCode,
    });
    notifyListeners();
  }

  Future<void> removeCategory(String id) async {
    _categories.removeWhere((item) =>
        item.id ==
        id); //here we assume response finished correctly, maybe additional checks needed

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
