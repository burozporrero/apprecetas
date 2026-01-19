// lib/presentation/screens/recipe_detail_screen.dart
// Pantalla para ver detalles de receta

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../data/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.nombre)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ingredients'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.ingredientes.join(', ')),
            SizedBox(height: 16),
            Text(
              'instructions'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.instrucciones),
          ],
        ),
      ),
    );
  }
}
