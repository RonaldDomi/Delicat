import 'dart:io';
import 'dart:typed_data';

import 'package:delicat/helpers/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get items {
    return [..._categories];
  }

  void addCategory(name, colorCode) {
    Category newCategory = Category(
      id: DateTime.now().toString(),
      name: name,
      colorCode: colorCode,
    );
    print("");
    print("created the new category");
    print("");
    print("$newCategory");
    print("name: ${newCategory.name}, color: ${newCategory.colorCode}");
    print("             --      ");
    print("category type: ${newCategory.runtimeType}");

    _categories.add(newCategory);
    print("          --             ");
    print("");
    print("categories: $_categories");
    print("");
    print("");
    notifyListeners();

    DBHelper.insert('user_categories', {
      'id': newCategory.id,
      'name': newCategory.name,
      'colorCode': newCategory.colorCode,
    });
    print("Added to the database. ");
    print("");
    print("");
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
      'colorCode': editedCategory.colorCode,
    });
  }

  Future<void> fetchAndSetCategories() async {
    final dataList = await DBHelper.getData('user_categories');
    // print("database $dataList");

    _categories = dataList.map(
      (item) {
        Category(
          id: item['id'],
          name: item['name'],
          colorCode: item['colorCode'],
        );
      },
    ).toList();
    print("fetch $_categories");
    // notifyListeners();
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
