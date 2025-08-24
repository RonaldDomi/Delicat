import 'package:flutter/material.dart';

class TabNavigationHelper {
  static final TabNavigationHelper _instance = TabNavigationHelper._internal();
  factory TabNavigationHelper() => _instance;
  TabNavigationHelper._internal();

  // Current tab's navigator keys will be set by TabNavigationScaffold
  List<GlobalKey<NavigatorState>>? _navigatorKeys;
  int _currentTabIndex = 0;

  void setNavigatorKeys(List<GlobalKey<NavigatorState>> keys) {
    _navigatorKeys = keys;
  }

  void setCurrentTabIndex(int index) {
    _currentTabIndex = index;
  }

  NavigatorState? get currentNavigator {
    if (_navigatorKeys == null) return null;
    return _navigatorKeys![_currentTabIndex].currentState;
  }

  // Push a route onto the current tab's navigation stack
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    final navigator = currentNavigator;
    if (navigator != null) {
      return navigator.pushNamed<T>(routeName, arguments: arguments);
    }
    throw Exception('Navigator not available');
  }

  // Replace current route in the current tab
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    final navigator = currentNavigator;
    if (navigator != null) {
      return navigator.pushReplacementNamed<T, TO>(
        routeName,
        arguments: arguments,
        result: result,
      );
    }
    throw Exception('Navigator not available');
  }

  // Pop current route in the current tab
  void pop<T extends Object?>([T? result]) {
    final navigator = currentNavigator;
    if (navigator != null && navigator.canPop()) {
      navigator.pop<T>(result);
    }
  }

  // Pop until a certain condition in the current tab
  void popUntil(RoutePredicate predicate) {
    final navigator = currentNavigator;
    if (navigator != null) {
      navigator.popUntil(predicate);
    }
  }
}