import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryItem extends StatefulWidget {
  final String title;
  final String colorCode;
  final Function addCategoryToSelection;
  bool isSelected;

  CategoryItem(this.title, this.colorCode, this.addCategoryToSelection) {
    isSelected = false;
  }

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  selectCategory() {
    setState(() {
      widget.addCategoryToSelection(
        Category(name: widget.title, colorCode: widget.colorCode),
      );
      widget.isSelected = !widget.isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectCategory,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          widget.title,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(widget.colorCode)).withOpacity(0.7),
              Color(int.parse(widget.colorCode)),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: widget.isSelected
              ? BorderRadius.circular(0)
              : BorderRadius.circular(15),
        ),
      ),
    );
  }
}
