import 'package:delicat/helperFunctions.dart';
import 'package:delicat/screens/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinycolor/tinycolor.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_downloader/image_downloader.dart';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';

import '../routeNames.dart';
import '../models/category.dart';
import '../providers/categories.dart';
import '../screen_scaffold.dart';

const List<Color> _availableColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

class NewCatScreen extends StatefulWidget {
  Category category;

  NewCatScreen({this.category});

  @override
  _NewCatScreenState createState() => _NewCatScreenState();
}

class _NewCatScreenState extends State<NewCatScreen> {
  final _form = GlobalKey<FormState>();
  Color pickerColor = Colors.red;
  bool _isEditing = false;
  bool _isNew = false;

  final _nameController = TextEditingController();
  final _colorCodeController = TextEditingController();
  Color currentColor = Color(0xff443a49);

  String postedImage = "";

  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  void changeColor(Color color) {
    setState(() => {
          currentColor = color,
        });
    final currentColorCode = colorToHex(color);
    _colorCodeController.text = currentColorCode;
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context, () async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );
        setState(() async {
          _imageFile = pickedFile;
          print(" ------------------ ");
          print("photo selected: ${_imageFile.path}");
          print(" ------------------ ");
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
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
  void initState() {
    if (widget.category != null) {
      _nameController.text = widget.category.name;
      _colorCodeController.text = widget.category.colorCode;
      pickerColor = hexToColor(widget.category.colorCode);
      _isEditing = true;
    } else {
      _colorCodeController.text = colorToHex(pickerColor);
      _isNew = true;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    postedImage = Provider.of<Categories>(context).getCurrentNewCategoryPhoto();
    Category category = Provider.of<Categories>(context).getOngoingCategory();
    if (category.name != null && category.colorCode != null) {
      _nameController.text = category.name;
      _colorCodeController.text = category.colorCode;
      pickerColor = category.colorCode != null
          ? hexToColor(category.colorCode)
          : Colors.red;
      _isEditing = true;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (_imageFile != null && postedImage != "") {
      return;
    }
    if (_isEditing && !_isNew) {
      var newCodeLight = TinyColor(
        hexToColor(_colorCodeController.text),
      ).brighten(14).color;
      Category editedCategory = Category(
        id: widget.category.id,
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        colorLightCode: colorToHex(newCodeLight),
        photo: "assets/photos/sushi-circle.png",
      );

      Provider.of<Categories>(context, listen: false)
          .editCategory(editedCategory);
      Navigator.of(context).pop();
      return;
    }

    _form.currentState.save();
    String newCode = _colorCodeController.text;
    var newCodeLight = TinyColor(
      hexToColor(newCode),
    ).brighten(14).color;
    var img;
    if (_imageFile != null) {
      img = _imageFile.path;
    } else {
      img = postedImage;
      try {
        // Saved with this method.
        var imageId = await ImageDownloader.downloadImage(img);
        if (imageId == null) {
          return;
        }

        // Below is a method of obtaining saved image information.
        // var fileName = await ImageDownloader.findName(imageId);
        var path = await ImageDownloader.findPath(imageId);
        print("path: $path");
        img = path;
        // var size = await ImageDownloader.findByteSize(imageId);
        // var mimeType = await ImageDownloader.findMimeType(imageId);
      } on PlatformException catch (error) {
        print(error);
      }
    }
    Category _newCategory = Category(
      name: _nameController.text,
      photo: img,
      colorCode: newCode,
      colorLightCode: colorToHex(newCodeLight),
    );

    try {
      await Provider.of<Categories>(context, listen: false)
          .createCategory(_newCategory);
      _imageFile = null;
      postedImage = "";
      Provider.of<Categories>(context).zeroCurrentPhoto();
      Provider.of<Categories>(context).zeroOngoingCategory();
      Navigator.of(context).pushReplacementNamed(RouterNames.CategoriesScreen);
    } catch (error) {
      print("error: sent category $_newCategory");
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CategoriesScreen(),
                  ),
                );
              },
            )
          ],
        ),
      );
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
                        "New Categorie",
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
                                  Provider.of<Categories>(context)
                                      .zeroCurrentPhoto();
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
                      if (_imageFile != null && postedImage != "")
                        Center(
                          child: Text(
                              "You cannot create this category, please remove one of the photos"),
                        ),
                      if (_imageFile != null)
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(_imageFile.path),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  _imageFile = null;
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
                          Category category = Category(
                              name: _nameController.text,
                              colorCode: _colorCodeController.text);
                          Provider.of<Categories>(context)
                              .setOngoingCategory(category);

                          Navigator.of(context)
                              .pushNamed(RouterNames.ImageScreen);
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
                          // _onImageButtonPressed(ImageSource.gallery,
                          //     context: context);
                          _onImageButtonPressed(ImageSource.camera,
                              context: context);
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
                          availableColors: _availableColors,
                          onColorChanged: changeColor,
                        ),
                      ),
                      SizedBox(height: 21),
                      RaisedButton(
                        onPressed: _saveForm,
                        color: hexToColor("#F6C2A4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        elevation: 6,
                        child: Text(
                          (!_isNew) ? "Update Category" : "Submit form",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(height: 21),
                    ],
                  ),
                ),
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
                          Navigator.of(context)
                              .pushNamed(RouterNames.CategoriesSelectionScreen);
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
