import 'package:flutter/material.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({Key key}) : super(key: key);

  static const routeName = '/meal-list';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("meal list screen"),
      ),
    );
  }
}
