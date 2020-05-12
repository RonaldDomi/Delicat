import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';

class PredefinedCategoryItem extends StatefulWidget {
  final Category category;
  final Function addCategoryToSelection;
  bool isSelected;

  PredefinedCategoryItem(this.category, this.addCategoryToSelection) {
    isSelected = false;
  }

  @override
  _PredefinedCategoryItemState createState() => _PredefinedCategoryItemState();
}

class _PredefinedCategoryItemState extends State<PredefinedCategoryItem> {
  selectCategory() {
    setState(() {
      widget.addCategoryToSelection(widget.category);
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
          widget.category.name,
          style: Theme.of(context).textTheme.title,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(int.parse(widget.category.colorCode)).withOpacity(0.7),
              Color(int.parse(widget.category.colorCode)),
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
