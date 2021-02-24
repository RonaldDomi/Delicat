import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/helpers/imagesHelperFunctions.dart';
import 'package:delicat/models/category.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/providers/user.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';
import 'package:delicat/constants.dart' as constants;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewCategoryScreen extends StatefulWidget {
  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorCodeController = TextEditingController();

  int _buttonState = 0;
  Color pickerColor = Colors.red;
  bool _isNew;
  Category category;

  Color currentColor = Color(0xff443a49);

  String postedImage = "";

  String _imageFilePath = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    postedImage = Provider.of<AppState>(context).currentNewCategoryPhoto;
    category = Provider.of<AppState>(context).ongoingCategory;
    _isNew = Provider.of<AppState>(context).isOngoingCategoryNew;
    _colorCodeController.text = colorToHex(Colors.red);
    if (postedImage == "" && category.photo != null) {
      postedImage = category.photo;
    }
    if (category.name != null) {
      _nameController.text = category.name;
    }
    if (category.colorCode != null) {
      _colorCodeController.text = category.colorCode;
      pickerColor = category.colorCode != null
          ? hexToColor(category.colorCode)
          : Colors.red;
    }
    if (_isNew) {
      _imageFilePath = "";
      postedImage = "";
      _nameController.text = "";
      Provider.of<AppState>(context).zeroCurrentCategoryPhoto();
      Provider.of<AppState>(context).zeroOngoingCategory();
    }
    super.didChangeDependencies();
  }

  void changeColor(Color color) {
    setState(() => {
          currentColor = color,
        });
    final currentColorCode = colorToHex(color);
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
      return new Text(
        (!_isNew) ? "Update Category" : "Submit form",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      );
    } else if (_buttonState == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFilePath = pickedFile.path;
    });
  }

  Future<void> _saveForm() async {
    // TODO: Invest into flutter unit testing
    // TODO: look at how to use form libraries for automatic validation
    // example: let fieldName = FormControl(null, [Validators.required, MyCustomLogic.needsPhoto]);
    print("submiting, with postedImage : $postedImage");
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (_imageFilePath != "" && postedImage != "") {
      return;
    }
    if (_imageFilePath == "" && postedImage == "" && _isNew == true) {
      return;
    }
    _form.currentState.save();

    // colorCode
    var newCodeLight = TinyColor(
      hexToColor(_colorCodeController.text),
    ).brighten(14).color;
    if (_isNew == false) {
      // refactor into function from here -----
      // example: createImage(filePath, postedImage) { return img }
      var img;
      if (_imageFilePath != "") {
        // if we putted a new file from phone, send the multipart
        img = _imageFilePath;
      } else if (postedImage != "") {
        // postedImage when we are editing, is the delicat url_photo
        if (postedImage != category.photo) {
          // if we changed this postedImage, send the multipart
          File downloadedFile = await saveImageFromWeb(postedImage);
          img = downloadedFile.path;
        } else {
          // else, just send forward the delicat photo_url
          img = postedImage;
        }
      } else {
        // if we don't remove photos, just send the delicat photo_url forward
        img = category.photo;
      }
      // to here
      Category editedCategory = Category(
        id: category.id,
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        colorLightCode: colorToHex(newCodeLight),
        photo: img,
      );
      String userId = Provider.of<User>(context).getCurrentUserId;

      await Provider.of<Categories>(context, listen: false)
          .editCategory(editedCategory, userId);

      _imageFilePath = "";
      postedImage = "";
      Provider.of<AppState>(context).zeroCurrentCategoryPhoto();
      Provider.of<AppState>(context).zeroOngoingCategory();
      _nameController.text = "";

      Navigator.of(context).pushReplacementNamed(RouterNames.CategoriesScreen);
      return;
    } else if (_isNew == true) {
      if (_imageFilePath != "") {
        // local
      } else {
        // download and all that thing
        File downloadedFile = await saveImageFromWeb(postedImage);
        _imageFilePath = downloadedFile.path;
      }
      Category _newCategory = Category(
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        photo: _imageFilePath,
        colorLightCode: colorToHex(newCodeLight),
      );
      String userId = Provider.of<User>(context).getCurrentUserId;
      await Provider.of<Categories>(context, listen: false)
          .createCategory(_newCategory, userId);

      _imageFilePath = "";
      postedImage = "";
      _nameController.text = "";
      Provider.of<AppState>(context).zeroCurrentCategoryPhoto();
      Provider.of<AppState>(context).zeroOngoingCategory();

      Navigator.of(context).pushReplacementNamed(RouterNames.CategoriesScreen);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Container(
        color: Color(0xffF1EBE8),
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
                      Text(
                        "Your Menu",
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
                          "add a new cat",
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: Color(0xffF9F9F9),
                  ),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        (!_isNew) ? "Update Category" : "New Categorie",
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xffBB9982),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              // width: 80.0,
                              child: Text(
                                "Cat Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff927C6C),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.7,
                              child: TextFormField(
                                initialValue: _nameController.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: hexToColor("#F1EBE8"),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                // onFieldSubmitted: (_) {
                                //   FocusScope.of(context).requestFocus(_colorFocusNode);
                                // },
                                validator: (value) {
                                  if (value.isEmpty) {
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
                      SizedBox(width: 20),
                      if (postedImage != "")
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(postedImage),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  Provider.of<AppState>(context)
                                      .zeroCurrentCategoryPhoto();
                                  postedImage = "";
                                });
                              },
                              color: hexToColor("#F6C2A4"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19.0),
                              ),
                              elevation: 6,
                              child: Text(
                                "Remove photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (_imageFilePath != "" && postedImage != "")
                        Center(
                          child: Text(
                              "You cannot create this category, please remove one of the photos"),
                        ),
                      if (_imageFilePath == "" && postedImage == "")
                        Center(
                          child: Text("Please select one of the photos"),
                        ),
                      if (_imageFilePath != "")
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      (_imageFilePath.substring(0, 6) == "http")
                                          ? AssetImage(_imageFilePath)
                                          : FileImage(File(_imageFilePath)),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  _imageFilePath = "";
                                });
                              },
                              color: hexToColor("#F6C2A4"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19.0),
                              ),
                              elevation: 6,
                              child: Text(
                                "Remove photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      RaisedButton(
                        onPressed: () {
                          Category ongoingCategory = Category(
                              name: _nameController.text,
                              colorCode: _colorCodeController.text,
                              id: category.id);
                          Provider.of<AppState>(context)
                              .setOngoingCategory(ongoingCategory);

                          Navigator.of(context)
                              .pushNamed(RouterNames.UnsplashScreen);
                        },
                        color: hexToColor("#F6C2A4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        elevation: 6,
                        child: Text(
                          "Choose Photo Online",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          // _onImageButtonPressed(ImageSource.gallery);
                          _onImageButtonPressed(ImageSource.camera);
                        },
                        color: hexToColor("#F6C2A4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        elevation: 6,
                        child: Text(
                          "Choose Photo From Galery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        height: 150,
                        child: BlockPicker(
                          pickerColor: pickerColor,
                          availableColors: constants.availableColors,
                          onColorChanged: changeColor,
                        ),
                      ),
                      SizedBox(height: 21),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (_buttonState == 0) {
                              animateButton();
                            }
                          });
                        },
                        color: hexToColor("#F6C2A4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        elevation: 6,
                        child: setUpButtonChild(),
                      ),
                      SizedBox(height: 21),
                    ],
                  ),
                ),
                if (_isNew)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(29),
                      color: Color(0xffF9F9F9),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text("Please choose what we have made for you"),
                        RaisedButton(
                          onPressed: () {
                            // var pass;
                            Navigator.of(context).pushNamed(
                                RouterNames.CategoriesSelectionScreen);
                          },
                          color: hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                          child: Text(
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
