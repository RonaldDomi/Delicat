import 'package:delicat/models/category.dart';
import 'package:delicat/providers/app_state.dart';
import 'package:delicat/providers/categories.dart';
import 'package:delicat/routeNames.dart';
import 'package:delicat/screens/Category/components/categories_item.dart';
import 'package:delicat/screens/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
 const CategoriesScreen({Key? key}) : super(key: key);

 @override
 _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
 Future<bool> _onBackPressed() async {
   final result = await showDialog<bool>(
         context: context,
         builder: (context) => AlertDialog(
           title: const Text('Are you sure?'),
           content: const Text('Do you want to exit an App'),
           actions: <Widget>[
             GestureDetector(
               onTap: () => Navigator.of(context).pop(false),
               child: const Text("NO"),
             ),
             const SizedBox(height: 16),
             GestureDetector(
               onTap: () => Navigator.of(context).pop(true),
               child: const Text("YES"),
             ),
           ],
         ),
       );
   return result ?? false;
 }

 @override
 Widget build(BuildContext context) {
   List<Category> allCategories = Provider.of<Categories>(context).categories;
   return ScreenScaffold(
     child: PopScope(
       canPop: false,
       onPopInvokedWithResult: (didPop, result) async {
         if (!didPop) {
           final shouldPop = await _onBackPressed();
           if (shouldPop && context.mounted) {
             Navigator.of(context).pop();
           }
         }
       },
       child: Container(
         color: const Color(0xffF1EBE8),
         child: Column(
           children: <Widget>[
             SizedBox(
               height: MediaQuery.of(context).size.height * 0.15,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: <Widget>[
                   const Text(
                     "Your Menu",
                     style: TextStyle(
                       fontSize: 23,
                     ),
                   ),
                   ElevatedButton(
                     onPressed: () {
                       Provider.of<AppState>(context, listen: false)
                           .setIsOngoingCategoryNew(true);
                       Navigator.of(context)
                           .pushNamed(RouterNames.NewCategoryScreen);
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white,
                       elevation: 6,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(18.0),
                       ),
                     ),
                     child: const Text(
                       "add a new cat",
                       style: TextStyle(
                         color: Color(0xffF6C2A4),
                       ),
                     ),
                   )
                 ],
               ),
             ),
             (allCategories.isEmpty)
                 ? SizedBox(
                     width: MediaQuery.of(context).size.width,
                     child: const Center(
                       child: Text("you have no cats on your profile."),
                     ),
                   )
                 : Expanded(
                     child: GridView.builder(
                       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                         maxCrossAxisExtent: 180,
                         childAspectRatio: 2 / 2.6,
                         crossAxisSpacing: 30,
                         mainAxisSpacing: 30,
                       ),
                       padding: const EdgeInsets.all(30),
                       itemCount: allCategories.length,
                       itemBuilder: (ctx, i) => InkWell(
                         onTap: () {
                           Navigator.of(context).pushNamed(
                               RouterNames.RecipeListScreen,
                               arguments: allCategories[i].id);
                         },
                         child: CategoryItem(allCategories[i]),
                       ),
                     ),
                   ),
           ],
         ),
       ),
     ),
   );
 }
}