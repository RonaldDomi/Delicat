import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final Function handleTap;

  const BottomNavigationBarWidget(this.handleTap, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) => handleTap(index, context),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Color(0xffF6C2A4),
          icon: Icon(Icons.home, color: Color(0xffF6C2A4)),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.favorite_border, color: Color(0xffF6C2A4)),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.search, color: Color(0xffF6C2A4)),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.apps, color: Color(0xffF6C2A4)),
          label: 'Apps',
        ),
      ],
    );
  }
}
