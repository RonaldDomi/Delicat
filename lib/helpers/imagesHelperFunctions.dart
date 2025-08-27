import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

/// Search images on Unsplash API
Future<List<String>> searchImage(String keyword) async {
  try {
    // Load API keys from assets
    final String keysData = await rootBundle.loadString('assets/Keys.json');
    final Map<String, dynamic> keys = json.decode(keysData);
    final String accessKey = keys['accessKey'] ?? '';
    
    if (accessKey.isEmpty || accessKey == 'YOUR_UNSPLASH_ACCESS_KEY_HERE') {
      print('Unsplash API key not configured');
      return <String>[];
    }
    
    // Make API request to Unsplash
    final String url = 'https://api.unsplash.com/search/photos?query=${Uri.encodeComponent(keyword)}&per_page=20&orientation=portrait';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Client-ID $accessKey',
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];
      
      // Extract regular-sized image URLs
      final List<String> imageUrls = results
          .map((photo) => photo['urls']['regular'] as String?)
          .where((url) => url != null)
          .cast<String>()
          .toList();
      
      return imageUrls;
    } else {
      print('Unsplash API error: ${response.statusCode} - ${response.body}');
      return <String>[];
    }
  } catch (e) {
    print('Error searching images: $e');
    return <String>[];
  }
}
