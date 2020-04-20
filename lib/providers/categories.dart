import 'package:flutter/material.dart';

import '../models/category.dart';

class Categories with ChangeNotifier{
  List<Category> _categories = [];

  List<Category> get items {
    return [..._categories];
  }
}