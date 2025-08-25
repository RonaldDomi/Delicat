import 'package:delicat/helpers/colorHelperFunctions.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/helpers/image_helper.dart';
import 'package:delicat/helpers/message_helper.dart';
import 'package:delicat/helpers/image_storage_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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

  // Ingredients management
  List<TextEditingController> _ingredientControllers = [];
  List<FocusNode> _ingredientNodes = [];
  List<String> _ingredients = [];

  String imageFilePath = '';
  Recipe? recipe;
  bool isNew = true;
  bool _isSelectingImage = false;
  bool _isInitialized = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeData();
    }
  }

  void _initializeData() async {
    imageFilePath = Provider.of<AppState>(context, listen: false).currentNewRecipePhoto;
    isNew = await Provider.of<AppState>(context, listen: false).isOngoingRecipeNew;
    recipe = Provider.of<AppState>(context, listen: false).ongoingRecipe;

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
      _ingredients = List<String>.from(recipe!.ingredients);
      if (recipe!.photo != null) {
        imageFilePath = recipe!.photo!;
      }
    }
    
    // Initialize ingredients after setting up the recipe data
    _initializeIngredients();
    _isInitialized = true;
  }

  void _initializeIngredients() {
    if (_ingredients.isEmpty) {
      _addIngredientField();
    } else {
      // Initialize controllers for existing ingredients
      for (int i = 0; i < _ingredients.length; i++) {
        final controller = TextEditingController(text: _ingredients[i]);
        final node = FocusNode();
        _ingredientControllers.add(controller);
        _ingredientNodes.add(node);
      }
      // Add one empty field at the end
      _addIngredientField();
    }
  }

  void _addIngredientField() {
    setState(() {
      final controller = TextEditingController();
      final node = FocusNode();
      _ingredientControllers.add(controller);
      _ingredientNodes.add(node);
    });
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientNodes[index].dispose();
        _ingredientControllers.removeAt(index);
        _ingredientNodes.removeAt(index);
      });
    }
  }

  List<String> _getIngredientsList() {
    return _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
  }

  List<Widget> _buildIngredientsInputs() {
    List<Widget> ingredientWidgets = [];
    
    for (int i = 0; i < _ingredientControllers.length; i++) {
      ingredientWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: _ingredientControllers[i],
                  focusNode: _ingredientNodes[i],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: hexToColor("#F1EBE8"),
                    hintText: "Enter ingredient ${i + 1}",
                    hintStyle: const TextStyle(
                      color: Color(0xff927C6C),
                      fontSize: 14,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.7),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, 
                      vertical: 12
                    ),
                  ),
                  onChanged: (value) {
                    // Auto-add new field when user starts typing in the last field
                    if (value.trim().isNotEmpty && i == _ingredientControllers.length - 1) {
                      _addIngredientField();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Add button for first field, remove button for others
              if (i == 0)
                IconButton(
                  onPressed: _addIngredientField,
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xffF6C2A4),
                    size: 28,
                  ),
                )
              else
                IconButton(
                  onPressed: () => _removeIngredientField(i),
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color(0xffF6C2A4),
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
      );
    }
    
    return ingredientWidgets;
  }

  void _onImageButtonPressed(ImageSource source) async {
    // Prevent overlapping image selection operations
    if (_isSelectingImage) return;
    
    try {
      _isSelectingImage = true;
      MessageHelper.showLoading(context, 'Selecting image...');
      
      final XFile? pickedFile = await _picker.pickImage(source: source);
      
      // Hide loading immediately after image selection
      MessageHelper.hideLoading(context);
      
      if (pickedFile != null) {
        String localImagePath = await ImageStorageHelper.saveImageLocally(pickedFile);
        setState(() {
          imageFilePath = localImagePath;
        });
        Provider.of<AppState>(context, listen: false).setCurrentNewRecipePhoto(localImagePath);
        MessageHelper.showSuccess(context, 'Image selected successfully!');
      }
    } catch (e) {
      MessageHelper.hideLoading(context);
      MessageHelper.showError(context, 'Failed to select image. Please try again.');
      print('Error picking image: $e');
    } finally {
      _isSelectingImage = false;
    }
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
    try {
      // Dismiss keyboard first
      FocusScope.of(context).unfocus();
      
      // Prevent submission while image selection is in progress
      if (_isSelectingImage) {
        setState(() { _buttonState = 0; });
        MessageHelper.showError(context, 'Please wait for image selection to complete');
        return;
      }
      
      final isValid = _form.currentState?.validate() ?? false;
      if (!isValid) {
        setState(() { _buttonState = 0; });
        MessageHelper.showError(context, 'Please fill in all required fields');
        return;
      }
      if (imageFilePath.isEmpty) {
        setState(() { _buttonState = 0; });
        MessageHelper.showError(context, 'Please select a photo for your recipe');
        return;
      }

      var recipeFavorite = false;
      if (recipe?.isFavorite == true) {
        recipeFavorite = true;
      }

      // Determine photo source based on how it was obtained
      String photoSource = 'unknown';
      final currentUnsplashPhoto = Provider.of<AppState>(context, listen: false).currentNewRecipePhoto;
      if (currentUnsplashPhoto.isNotEmpty && imageFilePath == currentUnsplashPhoto) {
        photoSource = 'unsplash';
      } else if (imageFilePath.isNotEmpty) {
        photoSource = 'camera'; // Could be camera or gallery, but both are user-selected local sources
      }

      Recipe newRecipe = Recipe(
        id: isNew ? '' : (recipe?.id ?? ''),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        isFavorite: recipeFavorite,
        photo: imageFilePath,
        categoryId: widget.categoryId,
        ingredients: _getIngredientsList(),
        photoSource: photoSource,
      );

      if (isNew == false) {
        await Provider.of<Recipes>(context, listen: false).editRecipe(newRecipe);
        MessageHelper.showSuccess(context, 'Recipe updated successfully!');
      } else if (isNew) {
        await Provider.of<Recipes>(context, listen: false).addRecipe(newRecipe, widget.categoryId);
        MessageHelper.showSuccess(context, 'Recipe created successfully!');
      }

    Provider.of<AppState>(context, listen: false).zeroCurrentRecipePhoto();
    Provider.of<AppState>(context, listen: false).zeroOngoingRecipe();
    imageFilePath = '';
    _nameController.text = "";
    _descriptionController.text = "";
    
    // Clear ingredients
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var node in _ingredientNodes) {
      node.dispose();
    }
    _ingredientControllers.clear();
    _ingredientNodes.clear();
    _ingredients.clear();

      setState(() { _buttonState = 2; });
      
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(RouterNames.RecipeListScreen,
            arguments: newRecipe.categoryId);
      });
    } catch (e) {
      setState(() { _buttonState = 0; });
      MessageHelper.showError(context, 'Failed to save recipe. Please try again.');
      print('Error saving recipe: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: hexToColor(widget.categoryColorCode),
        child: SafeArea(
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
                                textCapitalization: TextCapitalization.words,
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
                        textCapitalization: TextCapitalization.sentences,
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
                      
                      // Ingredients Section
                      const Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 25,
                          color: Color(0xffBB9982),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ..._buildIngredientsInputs(),
                      const SizedBox(height: 21),
                      const Divider(thickness: 3),
                      const SizedBox(height: 21),
                      if (imageFilePath.isEmpty)
                        const Center(
                          child: Text("Please select one of the photos"),
                        ),
                      // Photo selection section
                      if (imageFilePath.isNotEmpty)
                        Column(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(imageFilePath),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Ensure any stuck loading is cleared
                                if (_isSelectingImage) {
                                  MessageHelper.hideLoading(context);
                                  _isSelectingImage = false;
                                }
                                setState(() {
                                  imageFilePath = "";
                                });
                                Provider.of<AppState>(context, listen: false).zeroCurrentRecipePhoto();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor("#F6C2A4"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19.0),
                                ),
                                elevation: 6,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              child: const Text(
                                "Remove photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      
                      // Only show photo selection buttons when no image is selected
                      if (imageFilePath.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xffF1EBE8),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Choose Photo Source",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff927C6C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _onImageButtonPressed(ImageSource.camera);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hexToColor("#F6C2A4"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(19.0),
                                        ),
                                        elevation: 6,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text(
                                        "Camera",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _onImageButtonPressed(ImageSource.gallery);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: hexToColor("#F6C2A4"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(19.0),
                                        ),
                                        elevation: 6,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text(
                                        "Gallery",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      const SizedBox(height: 80),
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

  @override
  void dispose() {
    // Dispose main controllers and nodes
    _nameController.dispose();
    _descriptionController.dispose();
    _descriptionNode.dispose();
    
    // Safely dispose ingredient controllers and nodes
    try {
      for (var controller in _ingredientControllers) {
        controller.dispose();
      }
      for (var node in _ingredientNodes) {
        if (node.hasFocus) {
          node.unfocus();
        }
        node.dispose();
      }
    } catch (e) {
      // Ignore disposal errors - widget is already being disposed
    }
    
    super.dispose();
  }
}