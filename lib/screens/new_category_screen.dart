import 'package:delicat/helperFunctions.dart';
import 'package:delicat/screens/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinycolor/tinycolor.dart';

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
  Color pickerColor = Color(0xff443a49);
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _colorCodeController = TextEditingController();

  Color currentColor = Color(0xff443a49);
  void changeColor(Color color) {
    setState(() => {
          currentColor = color,
        });
    final currentColorCode = colorToHex(color);
    _colorCodeController.text = currentColorCode;
  }

  @override
  void initState() {
    if (widget.category != null) {
      _nameController.text = widget.category.name;
      _colorCodeController.text = widget.category.colorCode;
      _isEditing = true;
    }
    // TODO: implement initState
    super.initState();
  }

  // final _colorFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (_isEditing) {
      Category editedCategory = Category(
        id: widget.category.id,
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        photo: "assets/photos/sushi-circle.png",
      );
      print('edited category $editedCategory');

      Provider.of<Categories>(context, listen: false)
          .editCategory(editedCategory);
      Navigator.of(context).pop();
      return;
    }

    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    String newCode = colorCodeToHex(_colorCodeController.text);

    Category _newCategory = Category(
      name: _nameController.text,
      photo: "assets/photos/salads.jpg",
      colorCode: newCode,
      colorLightCode: colorToHex(TinyColor(
        hexToColor(newCode),
      ).brighten(14).color),
    );

    try {
      await Provider.of<Categories>(context, listen: false)
          .createCategory(_newCategory);
      // Navigator.of(context).pop();
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

    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  // @override
  // void dispose() {
  //   _colorFocusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                        padding: EdgeInsets.all(10),
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
                                    width:
                                        MediaQuery.of(context).size.width / 2.7,
                                    child: TextFormField(
                                      initialValue: _nameController.text,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: hexToColor("#F1EBE8"),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(25.7),
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
                                      onSaved: (value) {
                                        _nameController.text = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RouterNames.ImageScreen);
                              },
                              color: hexToColor("#F6C2A4"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19.0),
                              ),
                              elevation: 6,
                              child: Text(
                                "Choose Photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              height: 150,
                              child: BlockPicker(
                                pickerColor: currentColor,
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
                                (_isEditing)
                                    ? "Update Category"
                                    : "Submit form",
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
