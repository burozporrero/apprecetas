import 'dart:io';
import 'core/config/env_config.dart';
import '../../core/logger/logger.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Solo permitir certificados inválidos en desarrollo
        if (Environment.isDevelopment && Environment.allowBadCertificates) {
          AppLogger.info(
            '⚠️ Advertencia: Certificado SSL ignorado para $host:$port (solo desarrollo)',
          );
          return true;
        }
        return false;
      };
  }
}
