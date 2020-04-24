import 'dart:io';

import 'category.dart';

class Recipe {
  int id;
  String name;
  File photo;
  String instructions;
  Category category;

  Recipe({this.id, this.name, this.photo, this.instructions, this.category});
}
