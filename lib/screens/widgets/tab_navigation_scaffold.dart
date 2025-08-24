import 'package:delicat/screens/Category/categories_screen.dart';
import 'package:delicat/screens/Favorites/favorites_screen.dart';
import 'package:delicat/screens/Search/search_screen.dart';
import 'package:delicat/helpers/tab_navigation_helper.dart';
import 'package:delicat/router.dart' as app_router;
import 'package:flutter/material.dart';

class TabNavigationScaffold extends StatefulWidget {
  const TabNavigationScaffold({Key? key}) : super(key: key);

  @override
  _TabNavigationScaffoldState createState() => _TabNavigationScaffoldState();
}

class _TabNavigationScaffoldState extends State<TabNavigationScaffold> {
  int _currentIndex = 0;
  final TabNavigationHelper _navHelper = TabNavigationHelper();
  
  // Separate navigation keys for each tab to maintain independent navigation stacks
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Categories
    GlobalKey<NavigatorState>(), // Favorites  
    GlobalKey<NavigatorState>(), // Search
    GlobalKey<NavigatorState>(), // Settings/More
  ];

  @override
  void initState() {
    super.initState();
    _navHelper.setNavigatorKeys(_navigatorKeys);
    _navHelper.setCurrentTabIndex(_currentIndex);
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
      // If user taps current tab, pop to root of that tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      // Switch to new tab
      setState(() {
        _currentIndex = index;
        _navHelper.setCurrentTabIndex(index);
      });
    }
  }

  Future<bool> _onWillPop() async {
    // Let the current tab's navigator handle back button
    final isFirstRouteInCurrentTab = 
        !await _navigatorKeys[_currentIndex].currentState!.maybePop();
    
    if (isFirstRouteInCurrentTab) {
      // If we're at the root of current tab and it's not Categories, go to Categories
      if (_currentIndex != 0) {
        setState(() {
          _currentIndex = 0;
        });
        return false;
      }
    }
    
    return isFirstRouteInCurrentTab;
  }

  Widget _buildTabNavigator(int tabIndex, Widget rootPage) {
    return Navigator(
      key: _navigatorKeys[tabIndex],
      onGenerateRoute: (settings) {
        // For root route, show the root page
        if (settings.name == '/' || settings.name == null) {
          return MaterialPageRoute(
            builder: (context) => rootPage,
            settings: const RouteSettings(name: '/'),
          );
        }
        
        // For other routes, use the main app router
        return app_router.Router.generateRoute(settings);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, CategoriesScreen()),
            _buildTabNavigator(1, FavoritesScreen()),
            _buildTabNavigator(2, SearchScreen()),
            _buildTabNavigator(3, CategoriesScreen()), // Placeholder - same as Categories for now
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color(0xffF6C2A4)),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, color: Color(0xffF6C2A4)),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Color(0xffF6C2A4)),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps, color: Color(0xffF6C2A4)),
              label: 'More',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            // Go to Categories tab and pop to root
            if (_currentIndex != 0) {
              setState(() {
                _currentIndex = 0;
              });
            }
            _navigatorKeys[0].currentState?.popUntil((route) => route.isFirst);
          },
          child: Image.asset("assets/logo/logo.png"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}