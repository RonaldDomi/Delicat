import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/recipes.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import '../models/recipe.dart';
import './search_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    // List<Recipe> favoriteRecipes = Provider.of<Recipes>(context).favoriteItems;
    // CANNOT USE THE PROVIDER INSIDE THE INITSTATE METHOD
    List<Recipe> favoriteRecipes = [];
    _pages = [
      {
        'page': CategoriesScreen(),
      },
      {
        'page': FavoritesScreen(favoriteRecipes),
      },
      {
        'page': SearchScreen(),
      },
      {
        'page': SearchScreen(),
      },
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
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color.fromRGBO(246, 194, 164, 1),
            icon: RawMaterialButton(
              elevation: 3,
              padding: EdgeInsets.all(10),
              fillColor: Color.fromRGBO(246, 194, 164, 1),
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
              fillColor: Color.fromRGBO(246, 194, 164, 1),
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
              fillColor: Color.fromRGBO(246, 194, 164, 1),
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
              fillColor: Color.fromRGBO(246, 194, 164, 1),
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
          icon: Image.asset("assets/logo/logo-hdpi.png"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
