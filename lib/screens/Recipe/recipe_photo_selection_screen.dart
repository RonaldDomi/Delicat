import 'dart:io';
import 'package:delicat/providers/app_state.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../routeNames.dart';

class RecipePhotoSelectionScreen extends StatefulWidget {
  final String colorCode;
  final String name;
  final String catId;
  
  const RecipePhotoSelectionScreen(this.colorCode, this.name, this.catId, {Key? key}) : super(key: key);

  @override
  _RecipePhotoSelectionScreenState createState() =>
      _RecipePhotoSelectionScreenState();
}

class _RecipePhotoSelectionScreenState
    extends State<RecipePhotoSelectionScreen> {
  File? _imageFile;                    // Made nullable
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String? _retrieveDataError;          // Made nullable

  void _onImageButtonPressed(ImageSource source, {BuildContext? context}) async {
    try {
      // Fixed: Use pickImage method correctly
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget? _getRetrieveErrorWidget() {    // Made return type nullable
    if (_retrieveDataError != null) {
      final String errorMessage = _retrieveDataError!; // Use ! operator after null check
      final Widget result = Text(errorMessage);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  void submit() async {
    if (_imageFile == null || _imageFile!.path.isEmpty) {
      return;
    }
    String newPhoto = _imageFile!.path;
    Provider.of<AppState>(context, listen: false).setCurrentNewRecipePhoto(newPhoto);
    Navigator.of(context).pushNamed(
      RouterNames.NewRecipeScreen,
      arguments: [widget.name, widget.colorCode, widget.catId],
    );
  }

  Widget _previewImage() {
    final Widget? retrieveError = _getRetrieveErrorWidget();
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
            backgroundImage: FileImage(_imageFile!),
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

  // Removed getLostData method as it's deprecated in newer image_picker versions

  Future<void> _displayPickImageDialog(BuildContext context, VoidCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            actions: <Widget>[
              // Fixed: FlatButton is deprecated, use TextButton
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
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
                    style: const TextStyle(
                      fontSize: 23,
                    ),
                  ),
                  // Fixed: RaisedButton is deprecated, use ElevatedButton
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xffD6D6D6),
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    onPressed: null, // Disabled button
                    child: const Text(
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
                ? _previewImage() // Simplified - removed deprecated getLostData
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);
                        },
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
                          child: const Icon(
                            Icons.camera_alt,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
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
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  // Fixed: RaisedButton is deprecated, use ElevatedButton
                  ElevatedButton(
                    onPressed: () async {
                      submit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hexToColor("#F6C2A4"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.0),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
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
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 75),
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
          ],
        ),
      ),
    );
  }
}