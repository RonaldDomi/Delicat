import 'dart:io';

import 'category.dart';

class Recipe {
  int id;
  String name;
  String photo;
  String instructions;
  String categoryId; 

  Recipe({this.id, this.name, this.photo, this.instructions, this.categoryId});
}
