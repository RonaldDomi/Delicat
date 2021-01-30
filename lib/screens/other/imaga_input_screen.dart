import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import '../../other/imagesHelperFunctions.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<String> items = [];
  bool isLoading = false;
  bool showSelectedImage = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 60),
            TextField(
              onSubmitted: (value) async {
                setState(() {
                  isLoading = true;
                });
                var photos = await searchImage(value);
                setState(() {
                  isLoading = false;
                  items = photos;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffF1EBE8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
            SizedBox(height: 60),
            (items.length != 0)
                ? (!isLoading)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Swiper(
                          onTap: (index) {
                            setState(() {
                              showSelectedImage = true;
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              items[index].toString(),
                              fit: BoxFit.cover,
                            );
                          },
                          itemCount: items.length,
                          viewportFraction: 0.6,
                          scale: 0.8,
                        ),
                      )
                    : CircularProgressIndicator()
                : (isLoading)
                    ? CircularProgressIndicator()
                    : Center(
                        child: Text('What are you looking for?'),
                      ),
            SizedBox(height: 60),
            if (showSelectedImage = true && items.length != 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          items[currentIndex].toString(),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Next'),
                    onPressed: () {
                      String newPhoto = items[currentIndex].toString();
                      Provider.of<AppState>(context)
                          .setCurrentNewCategoryPhoto(newPhoto);
                      Navigator.of(context).pushNamed(
                        RouterNames.NewCategoryScreen,
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
