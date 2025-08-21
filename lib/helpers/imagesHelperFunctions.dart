import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

// Future<AppCredentials> loadAppCredentialsFromFile() async {
//   var jsonData = await rootBundle.loadString('assets/Keys.json');
//   final json = jsonDecode(jsonData) as Map<String, dynamic>;
//   var appCredentials = AppCredentials.fromJson(json);
//
//   return appCredentials;
// }

Future<List<String>> searchImage(String keyword) async {
  // var appCredentials = await loadAppCredentialsFromFile();

  //// Loads [AppCredentials] from a json file with the given [fileName].
  // final client = UnsplashClient(
  //   settings: ClientSettings(credentials: appCredentials),
  // );
  //
  List<String> photos = [];
  //
  // final response =
  //     await client.search.photos(keyword, page: 1, perPage: 10).go();
  // // Check that the request was successful.
  // if (!response.isOk) {
  //   throw 'Something is wrong: $response';
  // }
  //
  // for (var photo in response.data.results) {
  //   photos.add(photo.urls.small.toString());
  // }
  //
  return photos;
}
//
// Future<File> saveImageFromWeb(imageUrl) async {
//   var response = await get(imageUrl);
//   var documentDirectory = await getApplicationDocumentsDirectory();
//   var firstPath = documentDirectory.path + "/assets/categoryImages";
//   var filePathAndName =
//       documentDirectory.path + '/assets/categoryImages/pic1.jpg';
//   await Directory(firstPath).create(recursive: true);
//   File file2 = new File(filePathAndName);
//   file2.writeAsBytesSync(response.bodyBytes);
//   return file2;
// }
