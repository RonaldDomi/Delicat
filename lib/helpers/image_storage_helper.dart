// Create this new file: lib/helpers/image_storage_helper.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ImageStorageHelper {
  static const String _imageFolder = 'recipe_images';

  /// Save picked image to local app directory
  static Future<String> saveImageLocally(XFile imageFile) async {
    try {
      // Get app documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      // Create images directory if it doesn't exist
      final String imagesPath = '$appDocPath/$_imageFolder';
      await Directory(imagesPath).create(recursive: true);

      // Generate unique filename
      final String fileExtension = imageFile.path.split('.').last;
      final String uniqueFileName = '${const Uuid().v4()}.$fileExtension';
      final String localPath = '$imagesPath/$uniqueFileName';

      // Copy image to local storage
      final File localImage = await File(imageFile.path).copy(localPath);

      return localImage.path;
    } catch (e) {
      print('Error saving image locally: $e');
      throw Exception('Failed to save image: $e');
    }
  }

  /// Save image from file path to local app directory
  static Future<String> saveImageFromFile(String originalPath) async {
    try {
      final File originalFile = File(originalPath);
      if (!await originalFile.exists()) {
        throw Exception('Original image file does not exist');
      }

      // Get app documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;

      // Create images directory if it doesn't exist
      final String imagesPath = '$appDocPath/$_imageFolder';
      await Directory(imagesPath).create(recursive: true);

      // Generate unique filename
      final String fileExtension = originalPath.split('.').last;
      final String uniqueFileName = '${const Uuid().v4()}.$fileExtension';
      final String localPath = '$imagesPath/$uniqueFileName';

      // Copy image to local storage
      final File localImage = await originalFile.copy(localPath);

      return localImage.path;
    } catch (e) {
      print('Error copying image locally: $e');
      throw Exception('Failed to copy image: $e');
    }
  }

  /// Delete image from local storage
  static Future<void> deleteLocalImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    } catch (e) {
      print('Error deleting local image: $e');
    }
  }

  /// Check if file exists locally
  static Future<bool> imageExists(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      return await imageFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Safely delete an image if it came from Unsplash (not camera/gallery)
  static Future<void> safeDeleteUnsplashImage(String? imagePath, String photoSource) async {
    try {
      // Only delete if it's an Unsplash image and the file exists locally
      if (imagePath == null || imagePath.isEmpty || photoSource != 'unsplash') {
        return;
      }

      // Check if it's a local file path (contains our app directory structure)
      if (imagePath.contains('/recipe_images/')) {
        final File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          await imageFile.delete();
          print('Deleted Unsplash image: $imagePath');
        }
      }
    } catch (e) {
      print('Error deleting Unsplash image: $e');
      // Don't throw - deletion failures shouldn't break the app
    }
  }

  /// Clean up orphaned Unsplash images (for future use)
  static Future<void> cleanupOrphanedImages(List<String> usedImagePaths) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String imagesPath = '${appDocDir.path}/$_imageFolder';
      final Directory imagesDir = Directory(imagesPath);
      
      if (!await imagesDir.exists()) return;

      await for (FileSystemEntity entity in imagesDir.list()) {
        if (entity is File && !usedImagePaths.contains(entity.path)) {
          try {
            await entity.delete();
            print('Cleaned up orphaned image: ${entity.path}');
          } catch (e) {
            print('Error deleting orphaned image: $e');
          }
        }
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }
}