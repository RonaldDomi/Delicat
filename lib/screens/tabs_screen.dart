import 'package:delicat/screens/new_cat_screen.dart';
import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../routeNames.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../models/category.dart';

import './new_cat_screen.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import './search_screen.dart';
import './recipe_list_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Object> _pages;
  int _selectedPageIndex;
  bool _isCustomBody = false;
  var _customBody;

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

  void _selectPage(int index, [String catId]) {
    setState(() {
      if (catId != null) {
        _isCustomBody = true;
        _customBody = RecipeListScreen(categoryId: catId);
      } else {
        _isCustomBody = false;
        _selectedPageIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCustomBody ? _customBody : _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBarWidget(_selectPage),
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
