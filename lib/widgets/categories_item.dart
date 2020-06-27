import 'package:flutter/material.dart';
import '../models/category.dart';
import '../routeNames.dart';

class CategoryItem extends StatelessWidget {
  Category category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse(category.colorCode)).withOpacity(0.7),
            Color(int.parse(category.colorCode)),
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
                fit: BoxFit.fill,
                image: AssetImage(category.photo),
              ),
            ),
          ),
          // CircleAvatar(
          //   backgroundImage: DecorationImage(
          //       fit: BoxFit.fill,
          //       image: AssetImage(category.photo),
          //     ),,
          // ),
          Text(
            category.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// onTap: () {
//   Navigator.of(context).pushNamed(RouterNames.RecipeListScreen,
//       arguments: category.id.toString());
// },
