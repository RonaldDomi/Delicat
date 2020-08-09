import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import '../helperFunctions.dart';
import '../models/category.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:io';

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: hexToColor(category.colorCode),
            borderRadius: BorderRadius.circular(24),
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 6.0),
                width: 135,
                height: 135,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (category.photo.substring(0, 1) == "a")
                          ? AssetImage(category.photo)
                          : FileImage(File(category.photo))),
                ),
              ),
            ],
          ),
        ),
        ClipPath(
          clipper: TitleClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: TinyColor(hexToColor(category.colorCode)).darken(14).color,
              // color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            height: 90,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: AutoSizeText(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TitleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height / 3 * 2);
    path.cubicTo(0, 0, size.width, size.height / 3 * 2, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
