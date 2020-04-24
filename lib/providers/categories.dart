import 'dart:io';

import 'package:delicat/helpers/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get items {
    return [..._categories];
  }

  void addCategory(id, name, colorCode) {
    print("inside addCategory()");
    Category newCategory = Category(
      id: DateTime.now().toString(),
      name: name,
      // photo: File.fromRawPath(Uint8List.fromList([2])),
      // photo: File.fromUri(Uri.directory(photo)),
      // this is just a placeholder
      colorCode: colorCode,
    );
    print("category: name : ${newCategory.name}, id: ${newCategory.id}");
    print("_categories: $_categories");
    print("category runtime type ${newCategory.runtimeType}");
    var existingItem = _categories
        .firstWhere((itemToCheck) => itemToCheck.id == id, orElse: () => null);

    if (existingItem == null) {
      print("existing item is null");
      _categories.add(newCategory);
      print("successfully added");
      notifyListeners();

      DBHelper.insert('user_categories', {
        'id': newCategory.id,
        'name': newCategory.name,
        // 'photo': newCategory.photo.path,
        'colorCode': newCategory.colorCode,
      });
    }

    print("finished adding category");
  }

  void removeCategory(id) {
    _categories.removeWhere((item) => item.id == id);

    notifyListeners();

    DBHelper.delete('user_categories', id);
  }

  void editCategory(id, Category editedCategory) {
    notifyListeners();

    DBHelper.edit('user_categories', id, {
      'id': editedCategory.id,
      'name': editedCategory.name,
      // 'photo': editedCategory.photo.path,
      'colorCode': editedCategory.colorCode,
    });
  }

  Future<void> fetchAndSetCategories() async {
    final dataList = await DBHelper.getData('user_categories');
    print("populating categories with: ${dataList.toString()}");
    _categories = dataList.map(
      (item) {
        print("the item being mapped is ${item.toString()}");
        Category createdCategory = Category(
          id: item['id'],
          name: item['name'],
          // photo: File(item['photo']),
          colorCode: item['colorCode'],
        );
        print("Inside mapping, created category is: $createdCategory");
        return createdCategory;
      },
    ).toList();
    notifyListeners();
    print("Fetched categories from db: $_categories");
  }

  void editFirstHitStatus() async {
    final dataList = await DBHelper.getData('app_info');
    Map<String, dynamic> mapRead = dataList.first;

    DBHelper.edit("app_info", "1", {
      "firstTime": mapRead['firstTime'] == 1 ? 0 : 1,
    });
  }

  Future<int> getFirstHitStatus() async {
    final dataList = await DBHelper.getData('app_info');

    // get the first record
    Map<String, dynamic> mapRead = dataList.first;
    print('firstTime value: ${mapRead['firstTime']}');
    return mapRead['firstTime'];
  }
}
