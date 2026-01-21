// lib/data/repositories/auth_repository.dart
// Repository para auth (SOLID: Dependency Inversion)

import 'package:apprecetas/core/logger/logger.dart';

import '../../core/config/api_config.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      AppLogger.info('AuthRepository: Iniciando login', {'username': username});

      final response = await _apiService.request(
        ApiConfig.loginEndpoint,
        'POST',
        data: {'username': username, 'password': password},
      );

      AppLogger.info('AuthRepository: Response recibida', {
        'statusCode': response.statusCode,
        'dataType': response.data.runtimeType.toString(),
      });

      // Validación adicional
      if (response.data is! Map<String, dynamic>) {
        throw Exception(
          'Respuesta inválida del servidor: se esperaba un objeto JSON',
        );
      }

      final data = response.data as Map<String, dynamic>;

      // Validar que tenga los campos necesarios
      if (!data.containsKey('token')) {
        throw Exception('Respuesta inválida: falta el token');
      }

      return data;
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Error en login', e);
      AppLogger.error('StackTrace', stackTrace);
      rethrow;
    }
  }

  Future<void> register(String username, String password) async {
    try {
      AppLogger.info('AuthRepository: Iniciando registro', {
        'username': username,
      });

      await _apiService.request(
        ApiConfig.registerEndpoint,
        'POST',
        data: {'username': username, 'password': password},
      );

      AppLogger.info('AuthRepository: Registro exitoso');
    } catch (e, stackTrace) {
      AppLogger.error('AuthRepository: Error en registro', e);
      AppLogger.error('StackTrace', stackTrace);
      rethrow;
    }
  }
}
