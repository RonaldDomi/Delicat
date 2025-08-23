import 'dart:convert';

class Recipe {
  String id;
  String name;
  String? photo;
  String description;
  bool isFavorite;
  String categoryId;

  Recipe({
    required this.id,
    required this.name,
    this.photo,
    this.description = '',
    this.isFavorite = false,
    required this.categoryId,
  });

  Recipe.empty()
    : id = '',
      name = '',
      photo = '',
      description = '',
      isFavorite = false,
      categoryId = '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'isFavorite': isFavorite,
      'description': description,
      'categoryId': categoryId,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    return "{id: $id, name: $name, photo: $photo, description: $description, isFavorite: $isFavorite, categoryId: $categoryId}";
  }
}
