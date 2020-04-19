import 'package:flutter/material.dart';

import '../models/meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [];

    List<Meal> get items {
    return [..._meals];
  }

  void addMeal(title, image){
    _meals.add(Meal(title:title, image: image));
  }
}