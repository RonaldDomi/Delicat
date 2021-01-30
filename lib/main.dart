import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './router.dart' as MyRouter;
import './providers/recipes.dart';
import './providers/categories.dart';
import 'providers/app_state.dart';
import './providers/user.dart';
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
        ChangeNotifierProvider.value(
          value: User(),
        ),
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
      ],
      child: MaterialApp(
        title: 'Delicat',
        theme: ThemeData(
          // todo: think about how to properly use theme data to have a central design
          // -- see yt video
          primarySwatch: Colors.blue,
          // accentColor: Colors.deepOrange[200],
        ),
        // navigatorObservers: [MyNavigatorObserver()],
        initialRoute: "/",
        onGenerateRoute: MyRouter.Router.generateRoute,
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
