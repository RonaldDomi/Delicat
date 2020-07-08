import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router.dart';

import './providers/recipes.dart';
import './providers/categories.dart';
// import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Recipes(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
      ],
      child: MaterialApp(
        title: 'Delicat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // accentColor: Colors.deepOrange[200],
        ),
        // navigatorObservers: [MyNavigatorObserver()],
        initialRoute: "/",
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = List();

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    try {
      print(
          "navigator observer: from ${previousRoute.settings.name} to ${previousRoute.settings.name}");
    } catch (FormatException) {
      print("error on formating");
    }
    routeStack.add(route);
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute);
  }
}
