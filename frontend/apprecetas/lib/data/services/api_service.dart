// lib/data/services/api_service.dart
// Servicio para requests HTTP con Dio y HTTPS (SOLID: Single Responsibility)

import 'package:dio/dio.dart';
import '../../core/config/api_config.dart';
import '../../core/logger/logger.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      validateStatus: (status) =>
          status! < 500, // Maneja errores 4xx como excepciones
    ),
  );

  // Método genérico para requests con JWT
  Future<Response> request(
    String path,
    String method, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    Options options = Options(method: method);
    if (token != null) {
      options.headers = {'Authorization': 'Bearer $token'};
    }
    try {
      Response response = await _dio.request(
        path,
        data: data,
        options: options,
      );
      AppLogger.info('API Request: $method $path', response.data);
      return response;
    } catch (e) {
      AppLogger.error('API Error: $method $path', e);
      rethrow;
    }
  }
}
