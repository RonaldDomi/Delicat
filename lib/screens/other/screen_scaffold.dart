import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';

import '../../widgets/bottom_navigation_bar.dart';

class ScreenScaffold extends StatelessWidget {
  Widget child;

  ScreenScaffold({@required this.child});

  void handleTap(int bottomNavIndex, BuildContext context) {
    switch (bottomNavIndex) {
      case 0:
        Navigator.of(context).pushNamed(RouterNames.CategoriesScreen);
        break;
      case 1:
        Navigator.of(context).pushNamed(RouterNames.FavoritesScreen);
        break;
      case 2:
        Navigator.of(context).pushNamed(RouterNames.SearchScreen);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBarWidget(handleTap),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Image.asset("assets/logo/logo.png"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
