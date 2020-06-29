import 'dart:io';

import 'package:delicat/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'dart:math';

import '../widgets/recipe_image_picker.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../providers/recipes.dart';
import '../models/recipe.dart';

import './favorites_screen.dart';
import './categories_screen.dart';
import './search_screen.dart';

class NewRecipeScreen extends StatefulWidget {
  final String categoryName;
  final String categoryColorCode;
  NewRecipeScreen({this.categoryName, this.categoryColorCode});

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _form = GlobalKey<FormState>();
  List<Object> _pages;

  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _instructionsNode = FocusNode();

  int _selectedPageIndex;
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  @override
  void initState() {
    _selectedPageIndex = 0;
    _pages = [
      CategoriesScreen(_selectPage),
      FavoritesScreen(),
      SearchScreen(),
      SearchScreen(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _saveRecipe() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    // print(
    //     "----------------------------------------------------------------------");
    // print("${path.basename(_pickedImage.path)}");
    // final imageName = path.basename(_pickedImage.path);
    var rng = new Random();
    Recipe newRecipe = Recipe(
      categoryId: "1",
      id: rng.nextInt(1000).toString(),
      name: _nameController.text,
      instructions: _instructionsController.text,
      photo: "assets/photos/sushi-circle.png",
    );
    print(newRecipe);

    Provider.of<Recipes>(context, listen: false).addRecipe(newRecipe);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: hexToColor(widget.categoryColorCode),
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.categoryName} Catalogue",
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
                        "New Recipe",
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
                                "Recipe Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff927C6C),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.4,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: hexToColor("#F1EBE8"),
                                  // contentPadding: const EdgeInsets.only(
                                  //     left: 14.0, bottom: 9.0, top: 9.0),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.white),
                                  //   borderRadius: BorderRadius.circular(25.7),
                                  // ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_instructionsNode);
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffBB9982),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: hexToColor("#F1EBE8"),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        minLines: 4,
                        maxLines: 4,
                        controller: _instructionsController,
                        focusNode: _instructionsNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 21),
                      RaisedButton(
                        onPressed: _saveRecipe,
                        color: hexToColor("#F6C2A4"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19.0),
                        ),
                        elevation: 6,
                        child: Text(
                          "Add a recipe",
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(_selectPage),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Image.asset("assets/logo/logo.png"),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
