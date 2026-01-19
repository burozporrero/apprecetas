# Creación de una Aplicación Frontend en Flutter para Conectarse a una API en Node.js

El objetivo es desarrollar una aplicación móvil en Flutter que consuma tu API de Node.js (por ejemplo, la API de recetas con autenticación JWT). Se aplican principios de **Clean Code**, **SOLID**, un sistema de logs estructurado y soporte para **i18n**. La comunicación con la API se realizará mediante **HTTPS**, ya sea a través de ngrok o un dominio seguro.

---

## Requisitos Previos

- **Flutter instalado**  
  Descarga desde: https://flutter.dev  
  Comprueba la instalación con:
  ```
  flutter doctor
  ```

- **API disponible**  
  Tu servidor Node.js debe estar funcionando con HTTPS (por ejemplo, mediante ngrok: `https://abc123.ngrok.io`).

- **IDE recomendado**  
  VS Code o Android Studio con los plugins de Flutter.

- **Dispositivo de pruebas**  
  Emulador o dispositivo físico.

---

## Arquitectura General (SOLID + Clean Code)

### Capas principales

- **UI (Presentation)**  
  Widgets, pantallas y componentes visuales.

- **Domain (Lógica de negocio)**  
  Providers para gestionar estado y lógica interna.

- **Data (Datos)**  
  Repositories, modelos y servicios para comunicación con la API.

### Principios aplicados

- **Single Responsibility**  
  Cada clase cumple una única función.  
  Ejemplo: `AuthRepository` solo gestiona autenticación.

- **Open/Closed**  
  Código preparado para extenderse sin modificar lo existente.

- **Dependency Inversion**  
  Providers reciben dependencias como `ApiService`.

- **Logger estructurado**  
  Uso del paquete `logger` para registrar eventos.

- **Internacionalización (i18n)**  
  Implementación con `easy_localization` usando archivos `en.yml` y `es.yml`.

---

## Dependencias de Flutter

Añade las dependencias necesarias en `pubspec.yaml` y ejecuta:

```
flutter pub get
```

---

## Estructura de Carpetas (Clean Code)

```
flutter_app/
├── lib/
│   ├── core/              
│   │   ├── config/        # Configuración (URLs, constantes)
│   │   ├── logger/        # Logger personalizado
│   │   └── utils/         # Utilidades (validaciones, helpers)
│   ├── data/
│   │   ├── models/        # Modelos (User, Recipe)
│   │   ├── repositories/  # AuthRepository, RecipeRepository
│   │   └── services/      # ApiService (Dio)
│   ├── domain/
│   │   └── providers/     # AuthProvider, RecipeProvider
│   ├── presentation/
│   │   ├── screens/       # LoginScreen, RecipeListScreen
│   │   ├── widgets/       # Componentes reutilizables
│   │   └── themes/        # Estilos y temas
│   ├── l10n/              # Archivos de idiomas (en.json, es.json)
│   └── main.dart          # Punto de entrada
├── assets/
│   └── translations/      # Archivos YAML/JSON para i18n
└── pubspec.yaml
```

---

## Pruebas y Consejos Finales

- Ejecuta la app con:

```
flutter run
```

- **HTTPS**  
  Dio gestiona HTTPS automáticamente.  
  Si aparecen errores de certificados en desarrollo, puedes usar un adaptador para ignorarlos (solo en entornos de prueba).

- **Logger**  
  Utiliza:
  ```
  AppLogger.info('Mensaje');
  ```

- **i18n**  
  Cambia el idioma con:
  ```
  context.setLocale(Locale('es'));
  ```

- **Extensión del proyecto**  
  Añade pantallas para recetas siguiendo el mismo patrón que la pantalla de login.

- **Producción**  
  Configura firma, permisos de red y ajustes necesarios para publicar en tiendas.
