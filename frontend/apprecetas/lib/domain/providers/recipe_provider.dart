// lib/domain/providers/recipe_provider.dart
// Provider para estado de recetas (SOLID: Dependency Inversion)

import 'package:flutter/material.dart';
import '../../data/respositories/recipe_repository.dart';
import '../../data/services/api_service.dart';
import '../../data/models/recipe.dart';
import '../../core/logger/logger.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository(ApiService());
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> loadRecipes(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await _recipeRepository.getRecipes(token);
      AppLogger.info('Recetas cargadas', _recipes.length);
    } catch (e) {
      AppLogger.error('Error cargando recetas', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe(String token, Recipe recipe) async {
    try {
      final newRecipe = await _recipeRepository.createRecipe(token, recipe);
      _recipes.add(newRecipe);
      notifyListeners();
      AppLogger.info('Receta creada', newRecipe.nombre);
    } catch (e) {
      AppLogger.error('Error creando receta', e);
      rethrow;
    }
  }

  Future<void> updateRecipe(String token, int id, Recipe updatedRecipe) async {
    try {
      final recipe = await _recipeRepository.updateRecipe(
        token,
        id,
        updatedRecipe,
      );
      final index = _recipes.indexWhere((r) => r.id == id);
      if (index != -1) _recipes[index] = recipe;
      notifyListeners();
      AppLogger.info('Receta actualizada', recipe.nombre);
    } catch (e) {
      AppLogger.error('Error actualizando receta', e);
      rethrow;
    }
  }

  Future<void> deleteRecipe(String token, int id) async {
    try {
      await _recipeRepository.deleteRecipe(token, id);
      _recipes.removeWhere((r) => r.id == id);
      notifyListeners();
      AppLogger.info('Receta eliminada', id);
    } catch (e) {
      AppLogger.error('Error eliminando receta', e);
      rethrow;
    }
  }
}
