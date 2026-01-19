import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kReleaseMode
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'domain/providers/auth_provider.dart';
import 'domain/providers/recipe_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/recipe_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Carga las variables de entorno basadas en el modo (desarrollo o producción)
  if (kReleaseMode) {
    // En producción, carga .env.production
    await dotenv.load(fileName: ".env.production");
  } else {
    // En desarrollo/debug, carga .env.development
    await dotenv.load(fileName: ".env.development");
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
