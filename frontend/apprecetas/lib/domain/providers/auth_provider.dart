// lib/domain/providers/auth_provider.dart
// Provider para estado de auth (SOLID: Dependency Inversion)

import 'package:flutter/material.dart';
import '../../data/respositories/auth_repository.dart';
import '../../data/services/api_service.dart';
import '../../core/logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository(ApiService());
  String? _token;

  String? get token => _token;

  Future<void> login(String username, String password) async {
    try {
      final data = await _authRepository.login(username, password);
      if (data['token'] is String?) {
        _token =
            data['token'] as String?; // Cast seguro después de verificación
      } else {
        // Manejo de error: ej. lanza excepción o asigna null
        throw Exception(
          'Token inválido: esperado String?, recibido ${data['token'].runtimeType}',
        );
      }
      notifyListeners();
      AppLogger.info('Login exitoso', data);
    } catch (e) {
      AppLogger.error('Error en login', e);
      rethrow;
    }
  }

  Future<void> register(String username, String password) async {
    try {
      await _authRepository.register(username, password);
      AppLogger.info('Registro exitoso');
    } catch (e) {
      AppLogger.error('Error en registro', e);
      rethrow;
    }
  }
}
