import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [];

    List<Meal> get items {
    return [..._meals];
  }

  void addMeal(title, image){

    Meal newMeal = Meal(id: DateTime.now().toString(), title:title, image: image);

    _meals.add(newMeal);
    notifyListeners();

    DBHelper.insert('user_meals', {
      'id': newMeal.id,
      'title': newMeal.title,
      'image': newMeal.image.path,
    });

  }

    Future<void> fetchAndSetMeals() async {
    final dataList = await DBHelper.getData('user_meals');
    _meals = dataList
        .map(
          (item) => Meal(
                id: item['id'],
                title: item['title'],
                image: File(item['image']),
              ),
        )
        .toList();
    notifyListeners();
  }
}