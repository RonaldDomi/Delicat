import 'package:flutter/foundation.dart';

class Recipe {
  String id;
  String name;
  String photo;
  String description;
  String categoryId;

  Recipe({
    this.id,
    this.name,
    this.photo,
    this.description,
    this.categoryId,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, name: ${this.name}, photo: ${this.photo}, description: ${this.description}, categoryid: ${this.categoryId}}";
  }
}
