// import 'dart:io';

import 'dart:io';

import 'package:delicat/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

import '../routeNames.dart';
import '../screen_scaffold.dart';
import '../providers/recipes.dart';
import '../models/recipe.dart';
import 'categories_screen.dart';

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
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionNode = FocusNode();

  String postedImage = "";
  var recipe = Recipe();
  bool isNew = true;
  bool isEdited = false;

  @override
  void didChangeDependencies() async {
    postedImage = Provider.of<Recipes>(context).getCurrentNewRecipePhoto();
    isNew = Provider.of<Recipes>(context).getIsNew();
    isEdited = Provider.of<Recipes>(context).getIsEdited();
    if (isNew && !isEdited) {
      recipe.id = rng.nextInt(1000).toString();
      recipe.categoryId = widget.categoryId;
      recipe.photo = " ";
      super.didChangeDependencies();
      return;
    } else if (isNew && isEdited) {
      recipe = Provider.of<Recipes>(context).getOngoingRecipe();
      if (recipe.name != null &&
          recipe.description != null &&
          recipe.categoryId != null &&
          recipe.id != null &&
          recipe.photo != null) {
        _nameController.text = recipe.name;
        _descriptionController.text = recipe.description;
      } else {
        print("newRecipe: error, the recipe is missing something onInit");
      }
    } else {
      // TODO: isNew false

      recipe = Provider.of<Recipes>(context).getOngoingRecipe();
      _nameController.text = recipe.name;
      _descriptionController.text = recipe.description;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void navigateToPhoto() {
    recipe.name = _nameController.text;
    recipe.description = _descriptionController.text;
    Provider.of<Recipes>(context).setOngoingRecipe(recipe);
    Provider.of<Recipes>(context).setIsEdited(true);

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
    Recipe newRecipe = Recipe(
      categoryId: widget.categoryId,
      id: recipe.id,
      name: _nameController.text,
      isFavorite: false,
      description: _descriptionController.text,
      photo: recipe.photo,
    );
    if (!isNew) {
      Provider.of<Recipes>(context, listen: false).editRecipe(newRecipe);
      Provider.of<Recipes>(context).zeroCurrentPhoto();
      Provider.of<Recipes>(context).zeroOngoingRecipe();
      Provider.of<Recipes>(context).setIsEdited(false);
      Navigator.of(context).pushReplacementNamed(RouterNames.RecipeListScreen,
          arguments: recipe.categoryId);
      return;
    }
    try {
      Provider.of<Recipes>(context, listen: false).addRecipe(newRecipe);
      Provider.of<Recipes>(context).zeroCurrentPhoto();
      Provider.of<Recipes>(context).zeroOngoingRecipe();
      Provider.of<Recipes>(context).setIsEdited(false);
      Navigator.of(context).pushReplacementNamed(RouterNames.RecipeListScreen,
          arguments: newRecipe.categoryId);
    } catch (error) {
      print("error: sent recipe $newRecipe");
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

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context, () async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );
        setState(() async {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          // _pickImageError = e;
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
}

// TODO: IMPLEMENT CHOOSE FROM GALERY

// SizedBox(height: 21),
// Row(
//   children: <Widget>[
//     RaisedButton(
//       onPressed: () {
//         // chooseFromGalery();
//         _onImageButtonPressed(ImageSource.gallery,
//             context: context);
//       },
//       color: hexToColor("#F6C2A4"),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(19.0),
//       ),
//       elevation: 6,
//       child: Text(
//         "Choose From Galery",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//         ),
//       ),
//     ),
//     if (_imageFile != null)
//       Container(
//         height: 40,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: hexToColor("#E4E4E4"),
//           border: Border.all(
//             color: hexToColor("#EEDA76"),
//             width: 5,
//           ),
//           // image: DecorationImage(
//           //   fit: BoxFit.fill,
//           //   image: Image.file(
//           //     File(
//           //       _imageFile.path,
//           //     ),
//           //   ),
//           // ),
//         ),
//         child: Image.file(
//           File(
//             _imageFile.path,
//           ),
//         ),
//       ),
//   ],
// ),
// SizedBox(height: 21),
// if (postedImage != "")
//   Row(
//     children: <Widget>[
//       Container(
//         width: 130,
//         height: 130,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             fit: BoxFit.fill,
//             // image: NetworkImage(postedImage),
//           ),
//         ),
//       ),
//       RaisedButton(
//         onPressed: () {
//           setState(() {
//             Provider.of<Recipes>(context)
//                 .zeroCurrentPhoto();
//             postedImage = "";
//           });
//         },
//         color: hexToColor("#F6C2A4"),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(19.0),
//         ),
//         elevation: 6,
//         child: Text(
//           "Remove photo",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//           ),
//         ),
//       ),
//     ],
//   ),
