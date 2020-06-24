import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../widgets/recipe_image_picker.dart';
import '../providers/recipes.dart';

import '../models/category.dart';

class NewRecipeScreen extends StatefulWidget {
  const NewRecipeScreen({Key key}) : super(key: key);

  @override
  _NewRecipeScreenState createState() => _NewRecipeScreenState();
}

class _NewRecipeScreenState extends State<NewRecipeScreen> {
  final _form = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _categoryController = TextEditingController();

  final _instructionsNode = FocusNode();
  final _categoryNode = FocusNode();

  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _saveRecipe() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    print(
        "----------------------------------------------------------------------");
    print("${path.basename(_pickedImage.path)}");
    final imageName = path.basename(_pickedImage.path);
    Provider.of<Recipes>(context, listen: false).addRecipe(_nameController.text,
        imageName, _instructionsController.text, "1"); //CategoryId 1
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You DON\'t want to leave this empty.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_instructionsNode);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _instructionsController,
                        decoration: InputDecoration(labelText: 'Instructions'),
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        validator: (value) {
                          if (value.isEmpty || value.length <= 1) {
                            return 'Please don\'t be lazy and enter some descriptive instructions.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_categoryNode);
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Image",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RecipeImagePicker(_selectImage),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            color: Colors.red,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Current Category",
                            ),
                          ),
                          Container(
                            color: Colors.orange,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(5),
                            child: Text(
                              "Added Category",
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'add another'),
                        controller: _categoryController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add recipe'),
            onPressed: _saveRecipe,
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
