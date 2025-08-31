import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './router.dart' as MyRouter;
import './providers/recipes.dart';
import './providers/categories.dart';
import 'providers/app_state.dart';
import './providers/user.dart';
import './providers/ingredient_checklist.dart';
import './providers/cooking_today.dart';
import './widgets/cleanup_initializer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

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
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
        ChangeNotifierProvider(
          create: (_) => IngredientChecklist()..initializePreferences(),
        ),
        ChangeNotifierProvider(
          create: (_) => CookingToday()..initializePreferences(),
        ),
      ],
      child: CleanupInitializer(
        child: MaterialApp(
          title: 'Delicat',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: "/",
          onGenerateRoute: MyRouter.Router.generateRoute,
        ),
      ),
    );
  }
}

