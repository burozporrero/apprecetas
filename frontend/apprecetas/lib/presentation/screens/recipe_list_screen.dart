// lib/presentation/screens/recipe_list_screen.dart
// Pantalla para listar recetas (Clean Code: UI enfocada)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/recipe_provider.dart';
import '../../domain/providers/auth_provider.dart';
import 'recipe_form_screen.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar recetas solo una vez al inicializar la pantalla (evita el bucle infinito)
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    if (token != null) {
      recipeProvider.loadRecipes(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = authProvider.token;

    if (token == null) {
      return Center(child: Text('auth.error_not_authenticated'.tr()));
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
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          if (recipeProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (recipeProvider.recipes.isEmpty) {
            // Manejo explícito para 0 recetas: muestra un mensaje en lugar de una lista vacía
            return Center(
              child: Text(
                'recipes.no_recipes'.tr(),
              ), // Agrega esta traducción en tu archivo de localización (ej. en.json: "no_recipes": "No hay recetas disponibles")
            );
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
