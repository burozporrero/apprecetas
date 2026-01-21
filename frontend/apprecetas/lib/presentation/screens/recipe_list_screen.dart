// lib/presentation/screens/recipe_list_screen.dart
// Pantalla para listar recetas (Clean Code: UI enfocada)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/recipe_provider.dart';
import '../../domain/providers/auth_provider.dart';
import 'recipe_form_screen.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final token = authProvider.token;

    if (token == null) {
      return Center(
        child: Text('auth.error_not_authenticated'.tr()),
      ); // Traducción
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('recipes.title'.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RecipeFormScreen()),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: recipeProvider.loadRecipes(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('recipes.error_loading'.tr()));
          }
          return ListView.builder(
            itemCount: recipeProvider.recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipeProvider.recipes[index];
              return ListTile(
                title: Text(recipe.nombre),
                subtitle: Text(recipe.ingredientes.join(', ')),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(recipe: recipe),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () =>
                      recipeProvider.deleteRecipe(token, recipe.id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
