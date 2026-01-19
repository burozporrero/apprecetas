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
      _token = data['token'];
      notifyListeners();
      AppLogger.info('Login exitoso', data['user']);
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
