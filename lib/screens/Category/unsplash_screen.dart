import 'package:delicat/helpers/imagesHelperFunctions.dart';
import 'package:delicat/helpers/message_helper.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class UnsplashScreen extends StatefulWidget {
  @override
  _UnsplashnState createState() => _UnsplashnState();
}

class _UnsplashnState extends State<UnsplashScreen> {
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
                try {
                  var photos = await searchImage(value);
                  setState(() {
                    isLoading = false;
                    items = photos;
                  });
                  if (photos.isEmpty) {
                    MessageHelper.showInfo(context, 'No images found for "$value"');
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  MessageHelper.showError(context, 'Failed to search images. Please check your connection.');
                  print('Error searching images: $e');
                }
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
                          onIndexChanged: (index) {
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
                  // RaisedButton(
                  //   child: Text('Next'),
                  //   onPressed: () {
                  //     String newPhoto = items[currentIndex].toString();
                  //     Provider.of<AppState>(context)
                  //         .setCurrentUnsplashPhoto(newPhoto);
                  //     Navigator.of(context).pushNamed(
                  //       RouterNames.NewCategoryScreen,
                  //     );
                  //   },
                  // ),
                ],
              )
          ],
        ),
      ),
    );
  }

}
