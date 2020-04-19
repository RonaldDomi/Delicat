import 'package:flutter/material.dart';

import '../models/meal.dart';

class Meals with ChangeNotifier {
  List<Meal> _meals = [Meal(title: "Meal 1")];

    List<Meal> get items {
    return [..._meals];
  }
}