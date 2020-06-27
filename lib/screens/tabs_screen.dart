import 'package:delicat/screens/new_cat_screen.dart';
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../routeNames.dart';

import 'new_cat_screen.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import './search_screen.dart';

class TabsScreen extends StatefulWidget {
  final String pageName;

  TabsScreen({this.pageName = "Default"});
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Object> _pages;
  int _selectedPageIndex;

  @override
  void initState() {
    // List<Recipe> favoriteRecipes = [];
    // List<Recipe> favoriteRecipes = Provider.of<Recipes>(context).favoriteItems;
    _selectedPageIndex = 0;
    _pages = [
      CategoriesScreen(_selectPage),
      FavoritesScreen(),
      SearchScreen(),
      SearchScreen(),
      NewCatScreen(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF6C2A4),
            icon: RawMaterialButton(
              elevation: 3,
              padding: EdgeInsets.all(10),
              fillColor: Color(0xffF6C2A4),
              child: Icon(
                Icons.home,
                color: Colors.white,
              ),
              shape: CircleBorder(),
            ),
            title: Text('Categories'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: RawMaterialButton(
              elevation: 3,
              padding: EdgeInsets.all(10),
              fillColor: Color(0xffF6C2A4),
              child: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
              shape: CircleBorder(),
            ),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: RawMaterialButton(
              elevation: 3,
              padding: EdgeInsets.all(10),
              fillColor: Color(0xffF6C2A4),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
              shape: CircleBorder(),
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: RawMaterialButton(
              elevation: 3,
              padding: EdgeInsets.all(10),
              fillColor: Color(0xffF6C2A4),
              child: Icon(
                Icons.apps,
                color: Colors.white,
              ),
              shape: CircleBorder(),
            ),
            title: Text('Search'),
          ),
        ],
      ),
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
