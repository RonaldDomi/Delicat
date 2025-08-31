import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delicat/providers/recipes.dart';
import 'package:delicat/providers/ingredient_checklist.dart';
import 'package:delicat/providers/cooking_today.dart';
import 'package:delicat/services/cleanup_service.dart';

class CleanupInitializer extends StatefulWidget {
  final Widget child;
  
  const CleanupInitializer({Key? key, required this.child}) : super(key: key);

  @override
  _CleanupInitializerState createState() => _CleanupInitializerState();
}

class _CleanupInitializerState extends State<CleanupInitializer> {
  bool _cleanupCompleted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_cleanupCompleted) {
      _performCleanup();
    }
  }

  void _performCleanup() async {
    // Wait for providers to be ready
    final recipesProvider = context.read<Recipes>();
    final ingredientChecklistProvider = context.read<IngredientChecklist>();
    final cookingTodayProvider = context.read<CookingToday>();

    // Perform cleanup
    await CleanupService.cleanupOrphanedData(
      recipesProvider: recipesProvider,
      ingredientChecklistProvider: ingredientChecklistProvider,
      cookingTodayProvider: cookingTodayProvider,
    );

    setState(() {
      _cleanupCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}