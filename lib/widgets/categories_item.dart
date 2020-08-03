import 'package:flutter/material.dart';
import '../helperFunctions.dart';
import '../models/category.dart';
import 'dart:io';

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(category.colorCode).withOpacity(0.7),
            hexToColor(category.colorCode),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (category.photo.substring(0, 1) == "a")
                      ? AssetImage(category.photo)
                      : FileImage(File(category.photo))),
            ),
          ),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: hexToColor(category.colorLightCode),
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
