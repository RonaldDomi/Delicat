import 'dart:io';

import 'category.dart';

class Meal {
  String id;
  String name;
  File photo;
  String instructions;
  Category category;

  Meal({this.id, this.name, this.photo, this.instructions, this.category});
}
