import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final Function handleTap;

  BottomNavigationBarWidget(this.handleTap);

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
    );
  }
}
