import 'package:delicat/models/category.dart';
import 'package:flutter/material.dart';

class PredefinedCategoryItem extends StatefulWidget {
  final Category category;
  final Function addCategoryToSelection;
  final bool isSelected;

  PredefinedCategoryItem(
      this.category, this.addCategoryToSelection, this.isSelected) {}

  @override
  _PredefinedCategoryItemState createState() => _PredefinedCategoryItemState();
}

class _PredefinedCategoryItemState extends State<PredefinedCategoryItem> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  selectCategory() {
    setState(() {
      widget.addCategoryToSelection(widget.category);
      _isSelected = !_isSelected;
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
                color: _isSelected ? Color(0xffF6C2A4) : Colors.white,
              ),
            ),
          )),
    );
  }
}
