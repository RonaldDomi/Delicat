import 'package:delicat/routeNames.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './router.dart' as MyRouter;
import './providers/recipes.dart';
import './providers/categories.dart';
import './providers/user.dart';
// import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Recipes(),
        ),
        ChangeNotifierProvider.value(
          value: Categories(),
        ),
        ChangeNotifierProvider.value(
          value: User(),
        ),
      ],
      child: MaterialApp(
        title: 'Delicat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // accentColor: Colors.deepOrange[200],
        ),
        // navigatorObservers: [MyNavigatorObserver()],
        initialRoute: "/",
        onGenerateRoute: MyRouter.Router.generateRoute,
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = List();

  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    try {
      print(
          "navigator observer: from ${previousRoute.settings.name} to ${previousRoute.settings.name}");
    } catch (FormatException) {
      print("error on formating");
    }
    routeStack.add(route);
  }

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    routeStack.removeLast();
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute);
  }
}

// import 'dart:io';

// import 'package:mime/mime.dart';
// import 'package:http_parser/http_parser.dart';

// // import 'di'
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter File Upload Example',
//       home: UploadPage(),
//     );
//   }
// }

// class UploadPage extends StatefulWidget {
//   UploadPage({Key key}) : super(key: key);

//   @override
//   _UploadPageState createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   Future<String> uploadImage(filepath, url) async {
//     var request = http.MultipartRequest('POST', Uri.parse(url));
//     Map<String, String> headers = {
//       "Content-type": "multipart/form-data",
//       "Accept": "*/*"
//     };
//     request.headers.addAll(headers);

//     request.fields.addAll({
//       "userId": "60057c8856b64c0018211337",
//       "name": "testing",
//       "colorCode": "#f3f321"
//     });

//     request.files.add(await http.MultipartFile.fromPath('photo', filepath));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       print(await response.stream.bytesToString());
//     } else {
//       print(" ----<<< ${response.reasonPhrase}");
//       print(" ----<<< ${json.decode(response.reasonPhrase)}");
//       print(" ----<<< ${json.decode(response.reasonPhrase)._id}");
//       print(" ----<<< ${json.decode(response.reasonPhrase).name}");
//       print(" ----<<< ${json.decode(response.reasonPhrase).name}");
//       // print(" ----<<< ${json.decode(response.reasonPhrase)[_id]}");
//     }
//     print("------------------------------------------------------------");
//     print(response.stream);
//     print(response.stream.bytesToString());
//     return response.reasonPhrase;
//   }

//   Future<String> uploadImage2(filepath, url) async {
//     // prit se e kam ket kod
//     final mimeTypeData =
//         lookupMimeType(filepath, headerBytes: [0xFF, 0xD8]).split('/');
//     FormData formData = FormData.fromMap({
//       "userId": "60057c8856b64c0018211337",
//       "name": "testing22222",
//       "colorCode": "#f3f321",
//       "photo": await MultipartFile.fromFile(filepath,
//           filename: filepath.split("/").last,
//           contentType: MediaType(mimeTypeData[0], mimeTypeData[1]))
//     });
//     var response = await Dio().post(url, data: formData);
//     response.data.forEach((data) {
//       print("1 ${json.decode(data)['name']}");
//       print("2 ${json.decode(data).name}");
//     });
//     print(" ----<<< ${response.data}");
//     print(" ----<<< ${response.data.name}");

//     return response.statusMessage;
//   }

//   String state = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter File Upload Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[Text(state)],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           ImagePicker _picker = ImagePicker();
//           var file = await _picker.getImage(source: ImageSource.camera);

//           var res =
//               await uploadImage2(file.path, "http://54.195.158.131/categories");
//           setState(() {
//             state = res;
//             print(res);
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
