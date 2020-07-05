import 'package:delicat/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinycolor/tinycolor.dart';

import '../routeNames.dart';
import './tabs_screen.dart';
import '../models/category.dart';
import '../providers/categories.dart';

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
  const NewCatScreen({Key key}) : super(key: key);

  @override
  _NewCatScreenState createState() => _NewCatScreenState();
}

class _NewCatScreenState extends State<NewCatScreen> {
  Color pickerColor = Color(0xff443a49);

  Color currentColor = Color(0xff443a49);
  void changeColor(Color color) {
    setState(() => {
          currentColor = color,
        });
    final currentColorCode = "0xff" + currentColor.value.toRadixString(16);
    _initValues['colorCode'] = currentColorCode;
  }

  var _initValues = {
    'name': '',
    'colorCode': '',
  };

  // final _colorFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    String newCode = colorCodeToHex(_initValues['colorCode']);

    Category _newCategory = Category(
      name: _initValues['name'],
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
      Navigator.of(context).pushReplacementNamed('/');
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
                    builder: (BuildContext context) => TabsScreen(),
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
    return _isLoading
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
                                    initialValue: _initValues['name'],
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
                                      _initValues['name'] = value;
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
                              "Submit form",
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
                              Navigator.of(context).pushReplacementNamed(
                                  RouterNames.CatSelectionScreen);
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
          );
  }
}
//   decoration: BoxDecoration(
//     border: Border.all(width: 1),
//   ),
//   child: Form(
//     key: _form,
//     child: ListView(
//       children: <Widget>[
// TextFormField(
//   initialValue: _initValues['name'],
//   decoration: InputDecoration(labelText: 'Name'),
//   textInputAction: TextInputAction.next,
//   // onFieldSubmitted: (_) {
//   //   FocusScope.of(context).requestFocus(_colorFocusNode);
//   // },
//   validator: (value) {
//     if (value.isEmpty) {
//       return 'Please provide a value.';
//     }
//     return null;
//   },
//   onSaved: (value) {
//     _editedCategory = Category(
//       name: value,
//       colorCode: _editedCategory.colorCode,
//     );
//   },
// ),
//         // TextFormField(
//         //   initialValue: _initValues['colorCode'],
//         //   decoration: InputDecoration(labelText: 'Color'),
//         //   focusNode: _colorFocusNode,
//         //   textInputAction: TextInputAction.next,
//         //   onFieldSubmitted: (_) {
//         //     //for now this is the last input field, so we save form
//         //     _saveForm();
//         //     //move this to the last input field as needed
//         //     //preferrably with a submit button in the form
//         //     //FocusScope.of(context).requestFocus(_); got to next field, if we'll have eventually
//         //   },
//         //   validator: (value) {
//         //     if (value.isEmpty) {
//         //       return 'Select a value from color picker:';
//         //     }
//         //     return null;
//         //   },
//         //   onSaved: (value) {
//         //     _editedCategory = Category(
//         //       name: _editedCategory.name,
//         //       colorCode: value,
//         //     );
//         //   },
//         // ),
// RaisedButton(
//   elevation: 3.0,
//   onPressed: () {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select a color'),
//           content: SingleChildScrollView(
//             child: BlockPicker(
//               pickerColor: currentColor,
//               availableColors: _availableColors,
//               onColorChanged: changeColor,
//             ),
//           ),
//         );
//       },
//     );
//   },
//   child: const Text(
//     'Select Color',
//     textAlign: TextAlign.left,
//   ),
//   color: currentColor,
//   textColor: useWhiteForeground(currentColor)
//       ? const Color(0xffffffff)
//       : const Color(0xff000000),
// ),
// FlatButton(onPressed: _saveForm, child: Text("Submit form"))
//       ],
//     ),
//   ),
// )
