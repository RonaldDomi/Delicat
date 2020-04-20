import 'dart:io';

import 'package:delicat/helpers/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class Categories with ChangeNotifier{
  List<Category> _categories = [];

  List<Category> get items {
    return [..._categories];
  }

  void addCategory(name, photo, colorCode) {
    Category newCategory = Category(
      id: DateTime.now().toString(),
      name: name,
      photo: photo,
      colorCode: colorCode,
    );

    _categories.add(newCategory);
    notifyListeners();

    DBHelper.insert('user_categories', {
      'id': newCategory.id,
      'name': newCategory.name,
      'photo': newCategory.photo.path,
      'colorCode': newCategory.colorCode,
    });
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
      'photo': editedCategory.photo.path,
      'colorCode': editedCategory.colorCode,
    });
  }

  Future<void> fetchAndSetCategories() async {

    final dataList = await DBHelper.getData('user_categories');

    _categories = dataList.map(
      (item) {
        Category(
          id: item['id'],
          name: item['name'],
          photo: File(item['photo']),
          colorCode: item['colorCode'],
        );
      },
    ).toList();
    notifyListeners();
  }



}