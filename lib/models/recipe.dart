import 'dart:convert';

class Recipe {
  String id;
  String name;
  String? photo;
  String description;
  bool isFavorite;
  String categoryId;
  List<String> ingredients;
  String photoSource; // 'camera', 'gallery', 'unsplash', or 'unknown'

  Recipe({
    required this.id,
    required this.name,
    this.photo,
    this.description = '',
    this.isFavorite = false,
    required this.categoryId,
    this.ingredients = const [],
    this.photoSource = 'unknown',
  });

  Recipe.empty()
    : id = '',
      name = '',
      photo = '',
      description = '',
      isFavorite = false,
      categoryId = '',
      ingredients = [],
      photoSource = 'unknown';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'isFavorite': isFavorite,
      'description': description,
      'categoryId': categoryId,
      'ingredients': ingredients,
      'photoSource': photoSource,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['_id'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      photo: map['photo'] as String?,
      description: map['text'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
      ingredients: List<String>.from(map['ingredients'] as List<dynamic>? ?? []),
      photoSource: map['photoSource'] as String? ?? 'unknown',
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    return "{id: $id, name: $name, photo: $photo, description: $description, isFavorite: $isFavorite, categoryId: $categoryId, ingredients: $ingredients, photoSource: $photoSource}";
  }
}
