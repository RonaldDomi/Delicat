import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helperFunctions.dart';
import '../models/recipe.dart';
import '../providers/categories.dart';

class FavoriteItem extends StatelessWidget {
  final Recipe recipe;

  FavoriteItem(this.recipe);

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
                image: AssetImage(recipe.photo),
              ),
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
}
