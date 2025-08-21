import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/logo/logo.png'); // Default fallback
    }

    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath); // Keep for any remaining web images
    } else {
      return FileImage(File(imagePath)); // Local file
    }
  }

  static Widget buildImageWidget(String? imagePath, {BoxFit fit = BoxFit.cover}) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.image, size: 100, color: Colors.grey);
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, fit: fit);
    } else if (imagePath.startsWith('http')) {
      return Image.network(imagePath, fit: fit);
    } else {
      return Image.file(File(imagePath), fit: fit);
    }
  }
}