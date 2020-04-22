import 'package:flutter/material.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({Key key}) : super(key: key);

  static const routeName = '/meal-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal List"),
      ),
    );
  }
}
