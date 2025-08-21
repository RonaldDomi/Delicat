import 'dart:convert';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:tinycolor2/tinycolor2.dart';

class Category {
  final String id;
  final String userId;
  final String name;
  List<Recipe> recipes;
  String photo;
  final String colorCode;
  final String colorLightCode;

  Category({
    required this.id,
    required this.userId,
    required this.recipes,
    required this.name,
    required this.photo,
    required this.colorCode,
    required this.colorLightCode,
  });

  // Named constructor for empty category
  Category.empty()
      : id = '',
        userId = '',
        name = '',
        recipes = <Recipe>[],
        photo = '',
        colorCode = '#000000',
        colorLightCode = '#CCCCCC';

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
    return Category(
      id: map['_id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      photo: map['photo'] as String? ?? '',
      recipes: <Recipe>[],
      name: map['name'] as String? ?? '',
      colorCode: map['colorCode'] as String? ?? '#000000',
      colorLightCode: colorToHex(TinyColor.fromColor(
        hexToColor("${map["colorCode"] ?? '#000000'}"),
      ).lighten(20).color),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return "{id: $id, userId: $userId, name: $name, color: $colorCode, photo: $photo, recipes: $recipes}";
  }
}