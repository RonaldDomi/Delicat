import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/helpers/image_helper.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:io';

class NewRecipeScreen extends StatefulWidget {
  final String categoryName;
  final String categoryColorCode;
  final String categoryId;
  const NewRecipeScreen({
    Key? key,
    required this.categoryName,
    required this.categoryColorCode,
    required this.categoryId
  }) : super(key: key);

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _form = GlobalKey<FormState>();
  int _buttonState = 0;

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionNode = FocusNode();

  String imageFilePath = '';
  Recipe? recipe;
  bool isNew = true;

  @override
  void didChangeDependencies() async {
    imageFilePath = Provider.of<AppState>(context).currentNewRecipePhoto ?? '';
    isNew = await Provider.of<AppState>(context).isOngoingRecipeNew;
    recipe = Provider.of<AppState>(context).ongoingRecipe;

    if (isNew) {
      Provider.of<AppState>(context, listen: false).zeroCurrentRecipePhoto();
      Provider.of<AppState>(context, listen: false).zeroOngoingRecipe();
      imageFilePath = '';
      _nameController.text = "";
      _descriptionController.text = "";
    }

    if (isNew == false && recipe != null) {
      if (imageFilePath.isEmpty) {
        imageFilePath = '';
      }
      _nameController.text = recipe!.name;
      _descriptionController.text = recipe!.description;
      if (recipe!.photo != null) {
        imageFilePath = recipe!.photo!;
      }
    }
    super.didChangeDependencies();
  }

  void navigateToPhoto() {
    Recipe ongoingRecipe = Recipe(
      id: isNew ? '' : (recipe?.id ?? ''),
      name: _nameController.text,
      description: _descriptionController.text,
      isFavorite: false,
      categoryId: widget.categoryId,
    );

    Provider.of<AppState>(context, listen: false).setOngoingRecipe(ongoingRecipe);

    Navigator.of(context).pushNamed(
      RouterNames.RecipePhotoSelectionScreen,
      arguments: [
        widget.categoryColorCode,
        widget.categoryName,
        widget.categoryId
      ],
    );
  }

  Widget setUpButtonChild() {
    if (_buttonState == 0) {
      return Text(
        (!isNew) ? "Update recipe" : "Add a recipe",
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

  void animateButton() {
    setState(() {
      _buttonState = 1;
    });
    _saveForm();
  }

  void _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    if (imageFilePath.isEmpty) {
      return;
    }

    var recipeFavorite = false;
    if (recipe?.isFavorite == true) {
      recipeFavorite = true;
    }

    Recipe newRecipe = Recipe(
      id: isNew ? '' : (recipe?.id ?? ''),
      name: _nameController.text,
      description: _descriptionController.text,
      isFavorite: recipeFavorite,
      photo: imageFilePath,
      categoryId: widget.categoryId,
    );

    if (isNew == false) {
      Provider.of<Recipes>(context, listen: false).editRecipe(newRecipe);
    } else if (isNew) {
      Provider.of<Recipes>(context, listen: false).addRecipe(newRecipe, widget.categoryId);
    }

    Provider.of<AppState>(context, listen: false).zeroCurrentRecipePhoto();
    Provider.of<AppState>(context, listen: false).zeroOngoingRecipe();
    imageFilePath = '';
    _nameController.text = "";
    _descriptionController.text = "";

    Navigator.of(context).pushReplacementNamed(RouterNames.RecipeListScreen,
        arguments: newRecipe.categoryId);
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
                        style: const TextStyle(
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
                        child: const Text("add a new recipe"),
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
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      const Text(
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
                            const Text(
                              "Recipe Name",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff927C6C),
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.4,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: hexToColor("#F1EBE8"),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_descriptionNode);
                                },
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please provide a value.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 3),
                      const Text(
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
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        minLines: 4,
                        maxLines: 4,
                        controller: _descriptionController,
                        focusNode: _descriptionNode,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 21),
                      const Divider(thickness: 3),
                      const SizedBox(height: 21),
                      if (imageFilePath.isEmpty)
                        const Center(
                          child: Text("Please select one of the photos"),
                        ),
                      if (imageFilePath.isNotEmpty)
                        Row(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(imageFilePath)
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imageFilePath = "";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor("#F6C2A4"),
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
                          navigateToPhoto();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          "Choose Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 21),
                      const Divider(thickness: 3),
                      const Divider(thickness: 3),
                      const SizedBox(height: 21),
                      ElevatedButton(
                        onPressed: () {
                          if (_buttonState != 1) {
                            animateButton();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor("#F6C2A4"),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}