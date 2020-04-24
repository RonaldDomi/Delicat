import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../models/category.dart';
import '../providers/categories.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String colorCode;

  CategoryItem(this.id, this.title, this.colorCode);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        print("i got touched"),
        Provider.of<Categories>(context).addCategory(title, colorCode),
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(colorCode)).withOpacity(0.7),
              Color(int.parse(colorCode)),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
