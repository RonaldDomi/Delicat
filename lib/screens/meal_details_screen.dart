import 'package:flutter/material.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({Key key}) : super(key: key);

  static const routeName = '/meal-details';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("meal details screen"),
      ),
    );
  }
}
