// lib/data/repositories/auth_repository.dart
// Repository para auth (SOLID: Dependency Inversion)

import '../../core/config/api_config.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _apiService.request(
      ApiConfig.loginEndpoint,
      'POST',
      data: {'username': username, 'password': password},
    );
    return response.data; // Devuelve token y user
  }

  Future<void> register(String username, String password) async {
    await _apiService.request(
      ApiConfig.registerEndpoint,
      'POST',
      data: {'username': username, 'password': password},
    );
  }
}
