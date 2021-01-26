import 'dart:convert';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/other/colorHelperFunctions.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:tinycolor/tinycolor.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  List<Recipe> recipes;
  final String photo;
  final String colorCode;
  final String colorLightCode;

  Category({
    this.id,
    this.userId,
    this.recipes,
    this.name,
    this.photo,
    this.colorCode,
    this.colorLightCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipes': recipes,
      'name': name,
      'photo': photo,
      'colorCode': colorCode,
      'colorLightCode': colorLightCode,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Category(
      id: map['_id'],
      userId: map['userId'],
      photo: map['photo'],
      recipes: [],
      name: map['name'],
      colorCode: map['colorCode'],
      colorLightCode: colorToHex(TinyColor(
        hexToColor("${map["colorCode"]}"),
      ).brighten(14).color),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, userId: ${this.userId}, name: ${this.name}, color: ${this.colorCode}, photo: ${this.photo}, recipes: ${this.recipes}}";
  }
}
