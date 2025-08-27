import 'package:delicat/helpers/colorHelperFunctions.dart' as colorHelper;
// import 'package:delicat/helpers/imagesHelperFunctions.dart'; // Commented out - functionality not available
import 'package:delicat/models/category.dart';
import 'package:delicat/models/recipe.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/helpers/image_storage_helper.dart';
import 'package:delicat/helpers/image_helper.dart';
import 'package:delicat/helpers/message_helper.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({Key? key}) : super(key: key);

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorCodeController = TextEditingController();

  int _buttonState = 0;
  Color pickerColor = const Color(0xff1e3a8a); // Will be set to first color in didChangeDependencies
  bool _isNew = true;              // Initialize with default
  Category? category;              // Made nullable

  Color currentColor = const Color(0xff1e3a8a); // Default to first color (same as _predefinedColors[0])

  String postedImage = "";

  String _imageFilePath = '';
  final ImagePicker _picker = ImagePicker();
  bool _isInitialized = false;
  bool _isSelectingImage = false;

  // Predefined color palette
  static const List<Color> _predefinedColors = [
    Color(0xff1e3a8a), // Dark blue
    Color(0xffef4444), // Red
    Color(0xff10b981), // Green
    Color(0xfff59e0b), // Amber
    Color(0xff8b5cf6), // Purple
    Color(0xffec4899), // Pink
    Color(0xff06b6d4), // Cyan
    Color(0xfff97316), // Orange
    Color(0xff84cc16), // Lime
    Color(0xff6366f1), // Indigo
    Color(0xffe11d48), // Rose
    Color(0xff059669), // Emerald
    Color(0xffd97706), // Orange-600
    Color(0xff7c3aed), // Violet
    Color(0xff0891b2), // Sky
    Color(0xff65a30d), // Lime-600
    Color(0xff374151), // Gray-700
    Color(0xff991b1b), // Red-800
    Color(0xff064e3b), // Emerald-900
    Color(0xff7c2d12), // Orange-900
    Color(0xff581c87), // Purple-900
    Color(0xff831843), // Pink-900
    Color(0xff0c4a6e), // Sky-900
    Color(0xff365314), // Lime-900
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with first color immediately
    currentColor = _predefinedColors[0];
    pickerColor = _predefinedColors[0];
    _colorCodeController.text = colorHelper.colorToHex(_predefinedColors[0]);
  }

  @override
  void didChangeDependencies() {
    // Always check for updated Unsplash photo, not just on first initialization
    String currentUnsplashPhoto = Provider.of<AppState>(context).currentNewCategoryPhoto;
    
    if (!_isInitialized) {
      postedImage = currentUnsplashPhoto;
      category = Provider.of<AppState>(context).ongoingCategory;
      _isNew = Provider.of<AppState>(context).isOngoingCategoryNew;
      
      if (_isNew) {
        _imageFilePath = "";
        _nameController.text = "";
        // Keep the default color from initState - don't override it
        // Note: We don't zero the state here during build to avoid circular dependencies
      } else {
        // Only load existing category data if not new
        if (postedImage.isEmpty && category?.photo != null) {
          postedImage = category!.photo;
        }
        if (category?.name != null) {
          _nameController.text = category!.name;
        }
        if (category?.colorCode != null) {
          _colorCodeController.text = category!.colorCode;
          setState(() {
            pickerColor = colorHelper.hexToColor(category!.colorCode);
            currentColor = colorHelper.hexToColor(category!.colorCode);
          });
        }
      }
      _isInitialized = true;
    } else {
      // If we're already initialized but have a new Unsplash photo, update it
      if (currentUnsplashPhoto.isNotEmpty && currentUnsplashPhoto != postedImage) {
        print('Updating postedImage from: $postedImage to: $currentUnsplashPhoto');
        setState(() {
          postedImage = currentUnsplashPhoto;
          _imageFilePath = ""; // Clear local image if we have Unsplash image
        });
      }
    }
    super.didChangeDependencies();
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
      pickerColor = color;
    });
    final currentColorCode = colorHelper.colorToHex(color);
    _colorCodeController.text = currentColorCode;
  }

  void animateButton() async {
    setState(() {
      _buttonState = 1;
    });

    bool success = await _saveForm();
    if (success) {
      setState(() {
        _buttonState = 2;
      });
    } else {
      setState(() {
        _buttonState = 0;
      });
    }
  }

  Widget setUpButtonChild() {
    if (_buttonState == 0) {
      return Text(
        (!_isNew) ? "Update Category" : "Submit form",
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
          _imageFilePath = localImagePath;
        });
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

  /// Download image from URL and save to local storage
  Future<File> saveImageFromWeb(String imageUrl) async {
    try {
      // Download the image
      final http.Response response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download image: HTTP ${response.statusCode}');
      }
      
      // Get app documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      
      // Create images directory if it doesn't exist
      const String imageFolder = 'recipe_images';
      final String imagesPath = '$appDocPath/$imageFolder';
      await Directory(imagesPath).create(recursive: true);
      
      // Generate unique filename
      final String uniqueFileName = '${const Uuid().v4()}.jpg';
      final String localPath = '$imagesPath/$uniqueFileName';
      
      // Write image data to file
      final File localImage = File(localPath);
      await localImage.writeAsBytes(response.bodyBytes);
      
      return localImage;
    } catch (e) {
      print('Error downloading image: $e');
      throw Exception('Failed to download image: $e');
    }
  }

  Future<bool> _saveForm() async {
    try {
      // Prevent submission while image selection is in progress
      if (_isSelectingImage) {
        MessageHelper.showError(context, 'Please wait for image selection to complete');
        return false;
      }
      
      // Fixed: Null-safe form validation
      final isValid = _form.currentState?.validate() ?? false;
      if (!isValid) {
        MessageHelper.showError(context, 'Please fill in all required fields');
        return false;
      }
      if (_imageFilePath.isNotEmpty && postedImage.isNotEmpty) {
        MessageHelper.showError(context, 'Please select only one image source');
        return false;
      }
      if (_imageFilePath.isEmpty && postedImage.isEmpty && _isNew == true) {
        MessageHelper.showError(context, 'Please select an image for your category');
        return false;
      }
      _form.currentState?.save();

    // colorCode
    var newCodeLight = TinyColor.fromColor(
      colorHelper.hexToColor(_colorCodeController.text),
    ).lighten(20).color;

    if (_isNew == false && category != null) {
      // refactor into function from here -----
      var img;
      if (_imageFilePath.isNotEmpty) {
        // if we put a new file from phone, send the multipart
        img = _imageFilePath;
      } else if (postedImage.isNotEmpty) {
        // postedImage when we are editing, is the delicat url_photo
        if (postedImage != category!.photo) {
          // if we changed this postedImage, send the multipart
          try {
            File downloadedFile = await saveImageFromWeb(postedImage);
            img = downloadedFile.path;
          } catch (e) {
            print('Error downloading image: $e');
            img = postedImage; // Fallback to URL
          }
        } else {
          // else, just send forward the delicat photo_url
          img = postedImage;
        }
      } else {
        // if we don't remove photos, just send the delicat photo_url forward
        img = category!.photo;
      }

      Category editedCategory = Category(
        id: category!.id,
        userId: category!.userId,
        recipes: category!.recipes,
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        colorLightCode: colorHelper.colorToHex(newCodeLight),
        photo: img,
      );

      await Provider.of<Categories>(context, listen: false)
          .editCategory(editedCategory);

      MessageHelper.showSuccess(context, 'Category updated successfully!');
      _resetForm();
      Navigator.of(context).popUntil((route) => route.isFirst);
      return true;
    } else if (_isNew == true) {
      String finalImagePath = _imageFilePath;
      if (_imageFilePath.isEmpty && postedImage.isNotEmpty) {
        try {
          // download and all that thing
          File downloadedFile = await saveImageFromWeb(postedImage);
          finalImagePath = downloadedFile.path;
        } catch (e) {
          print('Error downloading image: $e');
          finalImagePath = postedImage; // Fallback to URL
        }
      }

      Category newCategory = Category(
        id: '', // Will be set by server
        userId: '', // Will be set by server
        recipes: <Recipe>[], // Empty initially
        name: _nameController.text,
        colorCode: _colorCodeController.text,
        photo: finalImagePath,
        colorLightCode: colorHelper.colorToHex(newCodeLight),
      );
      await Provider.of<Categories>(context, listen: false)
          .createCategory(newCategory);

      MessageHelper.showSuccess(context, 'Category created successfully!');
      _resetForm();
      Navigator.of(context).popUntil((route) => route.isFirst);
      return true;
    }
    } catch (e) {
      MessageHelper.showError(context, 'Failed to save category. Please try again.');
      print('Error saving category: $e');
      return false;
    }
    return false;
  }



  void _resetForm() {
    setState(() {
      _imageFilePath = "";
      postedImage = "";
      _nameController.text = "";
    });
    Provider.of<AppState>(context, listen: false).zeroCurrentCategoryPhoto();
    Provider.of<AppState>(context, listen: false).zeroOngoingCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffF1EBE8),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    color: const Color(0xffF9F9F9),
                  ),
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        (!_isNew) ? "Update Category" : "New Category",
                        style: const TextStyle(
                          fontSize: 23,
                          color: Color(0xffBB9982),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Cat Name",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff927C6C),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: _nameController.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: colorHelper.hexToColor("#F1EBE8"),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please provide a value.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _nameController.text = value;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (postedImage.isNotEmpty)
                        Column(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(postedImage),
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
                                  Provider.of<AppState>(context, listen: false)
                                      .zeroCurrentCategoryPhoto();
                                  postedImage = "";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
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
                      if (_imageFilePath.isNotEmpty && postedImage.isNotEmpty)
                        const Center(
                          child: Text(
                              "You cannot create this category, please remove one of the photos"),
                        ),
                      if (_imageFilePath.isEmpty && postedImage.isEmpty)
                        const Center(
                          child: Text("Please select one of the photos"),
                        ),
                      if (_imageFilePath.isNotEmpty)
                        Column(
                          children: <Widget>[
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: ImageHelper.getImageProvider(_imageFilePath)
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
                                  _imageFilePath = "";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
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
                      if (_imageFilePath.isEmpty && postedImage.isEmpty) ...[
                        const SizedBox(height: 20),
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
                              ElevatedButton(
                          onPressed: () {
                            if (category != null) {
                              Category ongoingCategory = Category(
                                id: category!.id,
                                userId: category!.userId,
                                recipes: category!.recipes,
                                name: _nameController.text,
                                colorCode: _colorCodeController.text,
                                photo: category!.photo,
                                colorLightCode: category!.colorLightCode,
                              );
                              Provider.of<AppState>(context, listen: false)
                                  .setOngoingCategory(ongoingCategory);
                            }

                            Navigator.of(context)
                                .pushNamed(RouterNames.UnsplashScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19.0),
                            ),
                            elevation: 6,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            "Online",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _onImageButtonPressed(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
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
                                backgroundColor: colorHelper.hexToColor("#F6C2A4"),
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
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffF1EBE8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Choose Category Color",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xffBB9982),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(10),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6,
                                ),
                                itemCount: _predefinedColors.length,
                                itemBuilder: (context, index) {
                                  final color = _predefinedColors[index];
                                  final isSelected = color.value == currentColor.value;
                                  return GestureDetector(
                                    onTap: () => changeColor(color),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected 
                                              ? Colors.black 
                                              : Colors.grey.shade300,
                                          width: isSelected ? 3 : 1,
                                        ),
                                      ),
                                      child: isSelected 
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: currentColor,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_buttonState == 0) {
                              animateButton();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorHelper.hexToColor("#F6C2A4"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.0),
                          ),
                          elevation: 6,
                        ),
                        child: setUpButtonChild(),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Extra bottom padding
              ],
            ),
          ),
        ),
    );
  }
}