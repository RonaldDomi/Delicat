import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/models/category.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class FavoriteItem extends StatelessWidget {
  final Recipe recipe;

  const FavoriteItem(this.recipe, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Category category = Provider.of<Categories>(context, listen: false)
        .getCategoryById(recipe.categoryId);
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
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  // image: AssetImage(recipe.photo),
                  image: _getImageProvider(),
              )
            ),
          ),
          Text(
            recipe.name,
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

    ImageProvider _getImageProvider() {
    final photo = recipe.photo;
    if (photo == null || photo.isEmpty) {
      return const AssetImage('assets/default_recipe.png'); // Fallback image
    }

    if (photo.startsWith('http')) {
      return NetworkImage(photo);
    } else if (photo.startsWith('assets/')) {
      return AssetImage(photo);
    } else {
      return FileImage(File(photo));
    }
  }
}
