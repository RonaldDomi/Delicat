import 'dart:io';

class Category {
  final String id;
  final String name;
  final File photo;
  final String colorCode;

  const Category({
    this.id,
    this.name,
    this.photo,
    this.colorCode,
  });
}
