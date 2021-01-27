import 'dart:convert';

import 'package:delicat/other/colorHelperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:io';

import '../../routeNames.dart';
import '../other/screen_scaffold.dart';
import '../../providers/recipes.dart';
import '../../models/recipe.dart';

class NewRecipeScreen extends StatefulWidget {
  final String categoryName;
  final String categoryColorCode;
  final String categoryId;
  NewRecipeScreen({this.categoryName, this.categoryColorCode, this.categoryId});

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _form = GlobalKey<FormState>();
  var rng = new Random();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionNode = FocusNode();

  String imageFilePath;
  Recipe recipe;
  bool isNew = true;

  @override
  void didChangeDependencies() async {
    imageFilePath = Provider.of<Recipes>(context).getCurrentNewRecipePhoto();
    isNew = await Provider.of<Recipes>(context).getIsNew();
    recipe = Provider.of<Recipes>(context).getOngoingRecipe();
    if (isNew == false || recipe != Recipe()) {
      if (imageFilePath == null) {
        imageFilePath = '';
      }
      if (recipe.name != null) {
        _nameController.text = recipe.name;
      }
      if (recipe.description != null) {
        _descriptionController.text = recipe.description;
      }
      if (recipe.photo != null) {
        imageFilePath = recipe.photo;
      }
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void navigateToPhoto() {
    Recipe ongoingRecipe = Recipe(
      name: _nameController.text,
      description: _descriptionController.text,
      isFavorite: false,
      categoryId: widget.categoryId,
    );
    if (isNew == false) {
      ongoingRecipe.id = recipe.id;
    }
    Provider.of<Recipes>(context).setOngoingRecipe(ongoingRecipe);

    Navigator.of(context).pushNamed(
      RouterNames.CameraScreen,
      arguments: [
        widget.categoryColorCode,
        widget.categoryName,
        widget.categoryId
      ],
    );
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (imageFilePath == "") {
      return;
    }
    var recipeFavorite = false;
    if (recipe.isFavorite) {
      recipeFavorite = true;
    }
    Recipe newRecipe = Recipe(
      name: _nameController.text,
      description: _descriptionController.text,
      isFavorite: recipeFavorite,
      photo: imageFilePath,
      categoryId: widget.categoryId,
    );
    if (isNew == false) {
      newRecipe.id = recipe.id;
      Provider.of<Recipes>(context, listen: false).editRecipe(newRecipe);
    } else if (isNew) {
      Provider.of<Recipes>(context, listen: false)
          .addRecipe(newRecipe, widget.categoryId);
    }
    Provider.of<Recipes>(context).zeroCurrentPhoto();
    Provider.of<Recipes>(context).zeroOngoingRecipe();
    imageFilePath = '';
    _nameController.text = "";
    _descriptionController.text = "";

    Navigator.of(context).pushReplacementNamed(RouterNames.RecipeListScreen,
        arguments: newRecipe.categoryId);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      child: Container(
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
                                      .requestFocus(_descriptionNode);
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
                        controller: _descriptionController,
                        focusNode: _descriptionNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 21),
                      Divider(
                        thickness: 3,
                      ),
                      SizedBox(height: 21),
                      if (imageFilePath == "")
                        Center(
                          child: Text("Please select one of the photos"),
                        ),
                      if (imageFilePath != "")
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (isNew = true)
                                      ? FileImage(File(imageFilePath))
                                      : NetworkImage(imageFilePath),
                                  // ? NetworkImage(imageFilePath)
                                  // : FileImage(File(imageFilePath)),
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  imageFilePath = "";
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
                          navigateToPhoto();
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
                      SizedBox(height: 21),
                      Divider(
                        thickness: 3,
                      ),
                      Divider(
                        thickness: 3,
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
                          (!isNew) ? "Update recipe" : "Add a recipe",
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
    );
  }
}
