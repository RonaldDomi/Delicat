import 'dart:io';

class Category {
  final String id;
  final String name;
  final String photo;
  final String colorCode;

  const Category({
    this.id,
    this.name,
    this.photo='-',
    this.colorCode,
  });
}
