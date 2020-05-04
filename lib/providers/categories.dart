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
    Category newCategory = Category(
      name: name,
      // photo: File.fromUri(Uri.directory(photo)),
      colorCode: colorCode,
    );

    var existingItem = _categories
        .firstWhere((itemToCheck) => itemToCheck.id == id, orElse: () => null);

    if (existingItem == null) {
      _categories.add(newCategory);
      notifyListeners();

      DBHelper.insert('user_categories', {
        'name': newCategory.name,
        // 'photo': newCategory.photo.path,
        'colorCode': newCategory.colorCode,
      });
    }
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

    // dataList is a List of objects
    _categories = dataList.map(
      (item) {
        Category createdCategory = Category(
          id: item['id'],
          name: item['name'],
          // photo: File(item['photo']),
          colorCode: item['colorCode'],
        );

        return createdCategory;
      },
    ).toList();
    // toList because the return type of .map() is a lazy Iterable
    notifyListeners();
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
    return mapRead['firstTime'];
  }
}
