import 'package:apprecetas/core/logger/logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kReleaseMode
import 'domain/providers/auth_provider.dart';
import 'domain/providers/recipe_provider.dart';
import 'presentation/screens/login_screen_old.dart';
import 'presentation/screens/recipe_list_screen.dart';
import 'dart:io';
import 'MyHttpOverrides.dart';
import 'core/config/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  // Inicializar variables de entorno
  await Environment.initialize();

  // Log de información del entorno (solo en debug)
  if (kDebugMode) {
    AppLogger.debug(
      '🚀 Iniciando aplicación en modo: ${Environment.current.name}',
    );
    AppLogger.debug('📡 API URL: ${Environment.apiBaseUrl}');
    AppLogger.debug(
      '🔒 Permitir certificados inválidos: ${Environment.allowBadCertificates}',
    );
  }

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('es')],
      path: 'assets/locale',
      assetLoader: const YamlAssetLoader(), // Loader YAML
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: LoginScreen(),
        routes: {
          '/recipes': (context) => RecipeListScreen(),
        }, // Pantalla inicial
      ),
    );
  }
}
