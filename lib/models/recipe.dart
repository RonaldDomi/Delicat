import 'dart:convert';

class Recipe {
  String id;
  String name;
  String photo;
  String description;
  bool isFavorite;
  String categoryId;

  Recipe({
    this.id,
    this.name,
    this.photo,
    this.isFavorite,
    this.description,
    this.categoryId,
  });

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
    if (map == null) return null;

    return Recipe(
      id: map['_id'],
      categoryId: map['categoryId'],
      name: map['name'],
      description: map['text'],
      photo: map['photo'],
      isFavorite: map['isFavorite'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, name: ${this.name}, photo: ${this.photo}, description: ${this.description}, isFavorite: ${this.isFavorite}, categoryid: ${this.categoryId}}";
  }
}
