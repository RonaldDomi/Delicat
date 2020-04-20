import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/meal.dart';
import '../models/category.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [];

  List<Meal> get items {
    return [..._meals];
  }


  void addMeal(name, photo, instructions, category) {
    Meal newMeal = Meal(
      id: DateTime.now().toString(),
      name: name,
      photo: photo,
      instructions: instructions,
      category: category,
    );

    _meals.add(newMeal);
    notifyListeners();

    DBHelper.insert('user_meals', {
      'id': newMeal.id,
      'name': newMeal.name,
      'photo': newMeal.photo.path,
      'instructions': newMeal.instructions,
      'category_id': newMeal.category.id,
    });
  }

  void removeMeal(id) {
    _meals.removeWhere((item) => item.id == id);

    notifyListeners();

    DBHelper.delete('user_meals', id);
  }

  void editMeal(id, Meal editedMeal) {
    final mealIndex = _meals.indexWhere((item) => item.id == id);
    _meals[mealIndex] = editedMeal;

    notifyListeners();

    DBHelper.edit('user_meals', id, {
      'id': editedMeal.id,
      'name': editedMeal.name,
      'photo': editedMeal.photo.path,
      'instructions': editedMeal.instructions,
      'category_id': editedMeal.category.id,
    });
  }

  Future<void> fetchAndSetMeals() async {
    final dataList = await DBHelper.getData('user_meals');

    //I need this to get all categories
    final categoryList = await DBHelper.getData('user_categories');
    //Map them to list
    List<Category> _cats = categoryList.map(
      (item) {
        Category(
          id: item['id'],
          name: item['name'],
          photo: File(item['photo']),
          colorCode: item['colorCode'],
        );
      },
    ).toList();

    _meals = dataList.map(
      (item) {
        //So then I can link the category manually to the created meals. This is a workaround to having properly relational tables in the database.
        //It needs to be fixed at some point
        Category cat = _cats.firstWhere((cat) => cat.id == item['category_id']);
        Meal(
          id: item['id'],
          name: item['name'],
          photo: File(item['photo']),
          instructions: item['instructions'],
          category: cat,
        );
      },
    ).toList();
    notifyListeners();
  }
}
