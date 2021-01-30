import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';

class PredefinedCategoryItem extends StatefulWidget {
  final Category category;
  final Function addCategoryToSelection;
  bool isSelected;

  PredefinedCategoryItem(
      this.category, this.addCategoryToSelection, this.isSelected) {}

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
      child: Container(
          decoration: BoxDecoration(
            color: Color(0xff48332A),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              widget.category.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: widget.isSelected ? Color(0xffF6C2A4) : Colors.white,
              ),
            ),
          )),
    );
  }
}
