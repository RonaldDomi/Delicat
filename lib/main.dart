import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/meals.dart';

import './screens/home_screen.dart';
import './screens/new_meal_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Meals(),
        ),
      ],
      child: MaterialApp(
        title: 'Delicat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeSceen(),
        initialRoute: '/',
        routes: {
          NewMealScreen.routeName: (ctx) => NewMealScreen(),
        },
      ),
    );
  }
}
