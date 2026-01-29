// lib/data/repositories/recipe_repository.dart
// Repository para operaciones CRUD de recetas (SOLID: Single Responsibility)

import '../services/api_service.dart';
import '../models/recipe.dart';
import '../../core/config/api_config.dart';

class RecipeRepository {
  final ApiService _apiService;

  RecipeRepository(this._apiService);

  Future<List<Recipe>> getRecipes(String token) async {
    final response = await _apiService.request(
      ApiConfig.recipesEndpoint,
      'GET',
      token: token,
    );
    if (response.data is List<dynamic>) {
      List<dynamic> data = response.data as List<dynamic>;
      return data
          .where(
            (json) => json is Map<String, dynamic>,
          ) // Filtra solo mapas válidos
          .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      // Manejo de error: ej. retorna lista vacía o lanza excepción
      throw Exception(
        'Datos inválidos: esperado List<Map<String, dynamic>>, recibido ${response.data.runtimeType}',
      );
    }
  }

  Future<Recipe> createRecipe(String token, Recipe recipe) async {
    final response = await _apiService.request(
      ApiConfig.recipesEndpoint,
      'POST',
      data: recipe.toJson(),
      token: token,
    );
    return Recipe.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Recipe> updateRecipe(String token, int id, Recipe recipe) async {
    final response = await _apiService.request(
      '${ApiConfig.recipesEndpoint}/$id',
      'PUT',
      data: recipe.toJson(),
      token: token,
    );
    return Recipe.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteRecipe(String token, int id) async {
    await _apiService.request(
      '${ApiConfig.recipesEndpoint}/$id',
      'DELETE',
      token: token,
    );
  }
}
