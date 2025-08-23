import 'package:delicat/helpers/colorHelperFunctions.dart' as colorHelper;
// import 'package:delicat/helpers/imagesHelperFunctions.dart'; // Commented out - functionality not available
import 'package:delicat/models/category.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';
import 'package:delicat/helpers/image_storage_helper.dart';
import 'package:delicat/helpers/image_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({Key? key}) : super(key: key);

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorCodeController = TextEditingController();

  int _buttonState = 0;
  Color pickerColor = Colors.red;
  bool _isNew = true;              // Initialize with default
  Category? category;              // Made nullable

  Color currentColor = const Color(0xff443a49);

  String postedImage = "";

  String _imageFilePath = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    postedImage = Provider.of<AppState>(context).currentNewCategoryPhoto;
    category = Provider.of<AppState>(context).ongoingCategory;
    _isNew = Provider.of<AppState>(context).isOngoingCategoryNew;
    _colorCodeController.text = colorHelper.colorToHex(Colors.red);

    if (postedImage.isEmpty && category?.photo != null) {
      postedImage = category!.photo;
    }
    if (category?.name != null) {
      _nameController.text = category!.name;
    }
    if (category?.colorCode != null) {
      _colorCodeController.text = category!.colorCode;
      pickerColor = colorHelper.hexToColor(category!.colorCode);
    }
    if (_isNew) {
      _imageFilePath = "";
      postedImage = "";
      _nameController.text = "";
      Provider.of<AppState>(context, listen: false).zeroCurrentCategoryPhoto();
      Provider.of<AppState>(context, listen: false).zeroOngoingCategory();
    }
    super.didChangeDependencies();
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
    });
    final currentColorCode = colorHelper.colorToHex(color);
    _colorCodeController.text = currentColorCode;
  }

  void animateButton() {
    setState(() {
      _buttonState = 1;
    });

    _saveForm();
    setState(() {
      _buttonState = 2;
    });
  }

  Widget setUpButtonChild() {
    if (_buttonState == 0) {
      return Text(
        (!_isNew) ? "Update Category" : "Submit form",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      );
    } else if (_buttonState == 1) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return const Icon(Icons.check, color: Colors.white);
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    try {
      // Fixed: Use pickImage correctly
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        String localImagePath = await ImageStorageHelper.saveImageLocally(pickedFile);
        setState(() {
          _imageFilePath = localImagePath;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  /// Placeholder for image download functionality  
  /// Currently disabled as Unsplash integration is not active
  Future<File> saveImageFromWeb(String imageUrl) async {
    throw UnimplementedError('Image download functionality not implemented yet');
  }

  Future<void> _saveForm() async {

    // Fixed: Null-safe form validation
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    if (_imageFilePath.isNotEmpty && postedImage.isNotEmpty) {
      return;
    }
    if (_imageFilePath.isEmpty && postedImage.isEmpty && _isNew == true) {
      return;
    }
    _form.currentState?.save();

    // colorCode
    var newCodeLight = TinyColor.fromColor(
      colorHelper.hexToColor(_colorCodeController.text),
    ).lighten(20).color;

    if (_isNew == false && category != null) {
      // refactor into function from here -----
      var img;
      if (_imageFilePath.isNotEmpty) {
        // if we put a new file from phone, send the multipart
        img = _imageFilePath;
      } else if (postedImage.isNotEmpty) {
        // postedImage when we are editing, is the delicat url_photo
        if (postedImage != category!.photo) {
          // if we changed this postedImage, send the multipart
          try {
            File downloadedFile = await saveImageFromWeb(postedImage);
            img = downloadedFile.path;
          } catch (e) {
            print('Error downloading image: $e');
            img = postedImage; // Fallback to URL
          }
        } else {
          // else, just send forward the delicat photo_url
          img = postedImage;
        }
      } else {
        // if we don't remove photos, just send the delicat photo_url forward
        img = category!.photo;
      }

      Category editedCategory = Category(
        id: category!.id,
        userId: category!.userId,
        recipes: category!.recipes,
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        colorLightCode: colorHelper.colorToHex(newCodeLight),
        photo: img,
      );

      await Provider.of<Categories>(context, listen: false)
          .editCategory(editedCategory);

      _resetForm();
      Navigator.of(context).pushReplacementNamed(RouterNames.CategoriesScreen);
      return;
    } else if (_isNew == true) {
      String finalImagePath = _imageFilePath;
      if (_imageFilePath.isEmpty && postedImage.isNotEmpty) {
        try {
          // download and all that thing
          File downloadedFile = await saveImageFromWeb(postedImage);
          finalImagePath = downloadedFile.path;
        } catch (e) {
          print('Error downloading image: $e');
          finalImagePath = postedImage; // Fallback to URL
        }
      }

      Category newCategory = Category(
        id: '', // Will be set by server
        userId: '', // Will be set by server
        recipes: <Recipe>[], // Empty initially
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        photo: finalImagePath,
        colorLightCode: colorHelper.colorToHex(newCodeLight),
      );
      await Provider.of<Categories>(context, listen: false)
          .createCategory(newCategory);

      _resetForm();
      Navigator.of(context).pushReplacementNamed(RouterNames.CategoriesScreen);
      return;
    }
  }

  void _resetForm() {
    _imageFilePath = "";
    postedImage = "";
    _nameController.text = "";
    Provider.of<AppState>(context, listen: false).zeroCurrentCategoryPhoto();
    Provider.of<AppState>(context, listen: false).zeroOngoingCategory();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Container(
        color: const Color(0xffF1EBE8),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Your Menu",
                        style: TextStyle(
                          fontSize: 23,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xffD6D6D6),
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        onPressed: null,
                        child: const Text("add a new cat"),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: const Color(0xffF9F9F9),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        (!_isNew) ? "Update Category" : "New Category",
                        style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xffBB9982),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              "Cat Name",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff927C6C),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.7,
                              child: TextFormField(
                                initialValue: _nameController.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: colorHelper.hexToColor("#F1EBE8"),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {  // Fixed null safety
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _nameController.text = value;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (postedImage.isNotEmpty)
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(postedImage),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Provider.of<AppState>(context, listen: false)
                                      .zeroCurrentCategoryPhoto();
                                  postedImage = "";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Remove photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_imageFilePath.isNotEmpty && postedImage.isNotEmpty)
                        const Center(
                          child: Text(
                              "You cannot create this category, please remove one of the photos"),
                        ),
                      if (_imageFilePath.isEmpty && postedImage.isEmpty)
                        const Center(
                          child: Text("Please select one of the photos"),
                        ),
                      if (_imageFilePath.isNotEmpty)
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(_imageFilePath)
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _imageFilePath = "";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Remove photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ElevatedButton(
                        onPressed: () {
                          if (category != null) {
                            Category ongoingCategory = Category(
                              id: category!.id,
                              userId: category!.userId,
                              recipes: category!.recipes,
                              name: _nameController.text,
                              colorCode: _colorCodeController.text,
                              photo: category!.photo,
                              colorLightCode: category!.colorLightCode,
                            );
                            Provider.of<AppState>(context, listen: false)
                                .setOngoingCategory(ongoingCategory);
                          }

                          Navigator.of(context)
                              .pushNamed(RouterNames.UnsplashScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          "Choose Photo Online",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.camera);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          "Choose Photo From Camera",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        child: ColorPicker(
                          color: pickerColor,
                          pickersEnabled: const <ColorPickerType, bool>{
                            ColorPickerType.primary: false,
                            ColorPickerType.accent: false,
                            ColorPickerType.wheel: false,
                            ColorPickerType.custom: true,
                          },
                          onColorChanged: changeColor,
                        ),
                      ),
                      const SizedBox(height: 21),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_buttonState == 0) {
                              animateButton();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                        ),
                        child: setUpButtonChild(),
                      ),
                      const SizedBox(height: 21),
                    ],
                  ),
                ),
                if (_isNew)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29),
                      color: const Color(0xffF9F9F9),
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        const Text("Please choose what we have made for you"),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                RouterNames.CategoriesSelectionScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19.0),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                            "Choose from ours",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}