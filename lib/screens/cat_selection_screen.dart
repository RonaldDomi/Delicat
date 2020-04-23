import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/categoy_item.dart';

class CatSelectionScreen extends StatefulWidget {
  const CatSelectionScreen({Key key}) : super(key: key);

  static const routeName = '/cat-selection';

  @override
  _CatSelectionScreenState createState() => _CatSelectionScreenState();
}

class _CatSelectionScreenState extends State<CatSelectionScreen> {
  final DUMMY_CATEGORIES = const [
    Category(
      id: 'c1',
      name: 'Italian',
      colorCode: "0xff00f3ff",
    ),
    Category(
      id: 'c2',
      name: 'Quick & Easy',
      colorCode: "0x888aefc3",
    ),
    Category(
      id: 'c3',
      name: 'Hamburgers',
      colorCode: "0x88990000",
    ),
    Category(
      id: 'c4',
      name: 'German',
      colorCode: "0x88ff0000",
    ),
    Category(
      id: 'c5',
      name: 'Light & Lovely',
      colorCode: "0x8800ff00",
    ),
    Category(
      id: 'c6',
      name: 'Exotic',
      colorCode: "0x88ff990023",
    ),
    Category(
      id: 'c7',
      name: 'Breakfast',
      colorCode: "0x85374fea",
    ),
    Category(
      id: 'c8',
      name: 'Asian',
      colorCode: "0x85ff5500",
    ),
    Category(
      id: 'c9',
      name: 'French',
      colorCode: "0x8f929950",
    ),
    Category(
      id: 'c10',
      name: 'Summer',
      colorCode: "0x8f3f3360",
    ),
    Category(
      id: 'c11',
      name: 'French',
      colorCode: "0x8f929950",
    ),
    Category(
      id: 'c12',
      name: 'Summer',
      colorCode: "0x8f3f3360",
    ),
    Category(
      id: 'c13',
      name: 'French',
      colorCode: "0x8f929950",
    ),
    Category(
      id: 'c14',
      name: 'Summer',
      colorCode: "0x8f3f3360",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selection Cat Screen"),
      ),
      body: GridView(
        padding: const EdgeInsets.all(25),
        children: DUMMY_CATEGORIES
            .map(
              (catData) => CategoryItem(
                catData.id,
                catData.name,
                catData.colorCode,
              ),
            )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
