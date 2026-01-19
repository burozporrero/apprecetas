// lib/core/logger/logger.dart
// Logger personalizado para logs estructurados (Clean Code: centralizado)

import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Muestra stack trace
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
    level: Level.debug, // Cambia a Level.info en producción
  );

  static void info(String message, [dynamic data]) => _logger.i(message);
  static void debug(String message, [dynamic data]) => _logger.d(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void warning(String message, [dynamic data]) =>
      _logger.w(message);
}
