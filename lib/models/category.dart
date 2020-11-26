import 'package:delicat/providers/recipes.dart';

class Category {
  final String id;
  final String userUuid;
  final String name;
  List<Recipes> recipes;
  String photo;
  final String colorCode;
  final String colorLightCode;

  Category({
    this.id,
    this.userUuid,
    this.recipes,
    this.name,
    this.photo,
    this.colorCode,
    this.colorLightCode,
  });

  @override
  String toString() {
    // TODO: implement toString
    return "{id: ${this.id}, userUuid: ${this.userUuid}, name: ${this.name}, color: ${this.colorCode}, photo: ${this.photo}, recipes: ${this.recipes}}";
  }
}
