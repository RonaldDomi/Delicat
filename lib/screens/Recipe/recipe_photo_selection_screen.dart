// whatsup type photo pickers, whatsupp style
// update photo on unsplash, onChangedIndex
// colorCode in between updateCategory
// the old bug, the ondelete "category doesnt exist"
// when updating cateogry, remain on category page not front page
// do not  wrap around when there's less than 3 recipes
//// if one or two recipes available only swip right
////// singlechild scrollview direction horizontal
// on recipe add photo, directly go to camera
// make a state provider with all* the variables transversing the screens
// look at read btn, on recipe lise
// bonus: read on performance improvements
// btn shows add recipe, when editing, after* we put a photo

import 'dart:io';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// import 'package:delicat/providers/recipes.dart';
// import 'package:delicat/models/recipe.dart';
// import 'package:provider/provider.dart';

import '../../routeNames.dart';

class RecipePhotoSelectionScreen extends StatefulWidget {
  final String colorCode;
  final String name;
  final String catId;
  RecipePhotoSelectionScreen(this.colorCode, this.name, this.catId);

  @override
  _RecipePhotoSelectionScreenState createState() =>
      _RecipePhotoSelectionScreenState();
}

class _RecipePhotoSelectionScreenState
    extends State<RecipePhotoSelectionScreen> {
  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String _retrieveDataError;

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await ImagePicker.pickImage(
        source: source,
      );
      setState(() async {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  void submit() async {
    if (_imageFile == null || _imageFile.path == null) {
      return;
    }
    String newPhoto = _imageFile.path;
    Provider.of<AppState>(context).setCurrentNewRecipePhoto(newPhoto);
    Navigator.of(context).pushNamed(
      RouterNames.NewRecipeScreen,
      arguments: [widget.name, widget.colorCode, widget.catId],
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hexToColor("#E4E4E4"),
            border: Border.all(
              color: hexToColor("#EEDA76"),
              width: 5,
            ),
          ),
          child: CircleAvatar(
            radius: 150,
            backgroundImage: new FileImage(
              _imageFile,
            ),
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    _retrieveDataError = response.exception.code;
  }

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    onPick();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              color: hexToColor(widget.colorCode),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${widget.name} Catalogue",
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  RaisedButton(
                    disabledTextColor: Color(0xffD6D6D6),
                    disabledColor: Colors.white,
                    disabledElevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text(
                      "add a new recipe",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            (_imageFile != null)
                ? FutureBuilder<void>(
                    future: retrieveLostData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        case ConnectionState.done:
                          return _previewImage();
                        // return null;
                        default:
                          if (snapshot.hasError) {
                            return Text(
                              'Pick image/video error: ${snapshot.error}}',
                              textAlign: TextAlign.center,
                            );
                          } else {
                            // return const Text(
                            //   'You have not yet picked an image.',
                            //   textAlign: TextAlign.center,
                            // );
                            return null;
                          }
                      }
                    },
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hexToColor("#E4E4E4"),
                          border: Border.all(
                            color: hexToColor("#EEDA76"),
                            width: 5,
                          ),
                        ),
                        child: null,
                      ),
                    ),
                  ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              color: hexToColor(widget.colorCode),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: InkWell(
                      onTap: () {
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                        // _onImageButtonPressed(ImageSource.gallery,
                        // context: context);
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          border: Border.all(
                            color: hexToColor("#655C3D"),
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      submit();
                    },
                    color: hexToColor("#F6C2A4"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    elevation: 6,
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                final dirPath = await getApplicationDocumentsDirectory();
                var ourFile = File(_imageFile.path);
                String localPath = "${dirPath.path}/assets/photos/image1.png";
                File saveDestinationFile = File('$localPath');
                // print("our file: ${ourFile}");
                // print("saveDestinationFile: ${saveDestinationFile.path}");

                final File newImage =
                    await ourFile.copy('${saveDestinationFile.path}');
                // final File newImage =
                //     await saveDestinationFile.copy('${ourFile.path}');

                // final AssetBundle rootBundle = _initRootBundle();
                // final imageBytes = await rootBundle.load(path);
                // final buffer = imageBytes.buffer;
                // await file.writeAsBytes(buffer.asUint8List(
                //     imageBytes.offsetInBytes, imageBytes.lengthInBytes));

                // Provider.of<Recipes>(context)
                //     .setCurrentNewRecipePhoto(newImage.path);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.symmetric(horizontal: 75),
                child: Center(
                  child: Text(
                    "Make sure you fill the circle",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: hexToColor("#F6C2A4"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
