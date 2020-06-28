import 'package:flutter/foundation.dart';

class Recipe {
  String id;
  String name;
  String photo;
  String instructions;
  String categoryId;

  Recipe({
    this.id,
    this.name,
    this.photo,
    this.instructions,
    this.categoryId,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, name: ${this.name}}";
  }
}
