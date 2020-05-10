import 'dart:io';

class Category {
  final int id;
  final String name;
  final String photo;
  final String colorCode;

  const Category({
    this.id,
    this.name,
    this.photo='https://image.shutterstock.com/image-vector/ui-image-placeholder-wireframes-apps-260nw-1037719204.jpg',
    this.colorCode,
  });
}
