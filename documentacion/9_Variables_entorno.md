# Configuración de Variables de Entorno para Trabajar en Distintos Entornos

Las variables de entorno permiten adaptar tu aplicación a desarrollo, staging o producción sin dejar valores fijos en el código (URLs, claves secretas, etc.). Es recomendable usar archivos `.env` tanto en el backend (Node.js) como en la app Flutter.

---

## Backend Node.js (dotenv)

Node.js permite cargar archivos `.env` usando el paquete **dotenv**. Lo ideal es crear un archivo por entorno.

### Instalación

```bash
npm install dotenv
```

### Archivos `.env` por entorno

En la raíz del proyecto (`backend/`), crea:

#### `.env.development` (desarrollo)

```
NODE_ENV=development
PORT=3000
JWT_SECRET=tu_clave_secreta_desarrollo
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=recetas_db
LOG_LEVEL=debug
```

#### `.env.production` (producción)

```
NODE_ENV=production
PORT=3000
JWT_SECRET=tu_clave_secreta_produccion_segura
DB_HOST=tu_servidor_db_produccion
DB_USER=usuario_produccion
DB_PASSWORD=contraseña_segura
DB_NAME=recetas_db_prod
LOG_LEVEL=info
```

Añade `.env*` a `.gitignore` para evitar subir información sensible.

### Carga de variables en `server.js`

```javascript
// src/server.js
require('dotenv').config({
  path: `.env.${process.env.NODE_ENV || 'development'}`
});

// Ejemplos:
// const port = process.env.PORT;
// host: process.env.DB_HOST
```

### Arranque según entorno

- Desarrollo:
  ```bash
  NODE_ENV=development npm run dev
  ```
- Producción:
  ```bash
  NODE_ENV=production npm start
  ```

Ejemplo en `package.json`:

```json
"dev": "NODE_ENV=development nodemon src/server.js"
```

---

## App Flutter (flutter_dotenv)

Flutter no soporta `.env` de forma nativa, pero el paquete **flutter_dotenv** permite cargar archivos por entorno.

### Instalación

En `pubspec.yaml`:

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

Ejecuta:

```bash
flutter pub get
```

### Archivos `.env` por entorno

En la raíz del proyecto (`flutter_app/`), crea:

#### `.env.development`

```
API_BASE_URL=https://abc123.ngrok.io
LOG_LEVEL=debug
DEFAULT_LOCALE=en
```

#### `.env.production`

```
API_BASE_URL=https://tu-dominio-produccion.com
LOG_LEVEL=info
DEFAULT_LOCALE=es
```

Añade `.env*` a `.gitignore`.

### Carga de variables en `main.dart`

```dart
// Carga las variables de entorno basadas en el modo (desarrollo o producción) antes de ejecutar la app con runApp().
  if (kReleaseMode) {
    // En producción, carga .env.production
    await dotenv.load(fileName: ".env.production");
  } else {
    // En desarrollo/debug, carga .env.development
    await dotenv.load(fileName: ".env.development");
  }
```

### Uso de variables en `api_config.dart`

```dart
static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://localhos:3000';
```

### Cómo arrancar en modo desarrollo

1. Abre una terminal en la raíz de tu proyecto Flutter.
   2. Ejecuta los siguientes comandos para limpiar el proyecto:
      ```
       flutter clean
       flutter pub get
       flutter run
      ```
  - Esto inicia la app en **modo debug** (desarrollo).
  - Se conecta a un emulador/simulador o dispositivo físico.
  - Carga automáticamente `.env.development` (gracias a `if (!kReleaseMode)` en `main.dart`).
  - Permite hot reload (presiona `r` en la terminal para recargar cambios sin reiniciar).
  - Es ideal para desarrollo y pruebas rápidas.

Si quieres especificar un dispositivo (ej. si tienes varios conectados):
```
flutter run -d <device_id>
```
Puedes ver los dispositivos disponibles con `flutter devices`.

### Cómo arrancar en modo producción

1. Abre una terminal en la raíz de tu proyecto Flutter.
2. Para probar en **modo release** (producción) sin construir un APK/AAB completo:
   ```
   flutter run --release
   ```
  - Esto inicia la app en **modo release**, optimizada para producción.
  - Carga automáticamente `.env.production` (gracias a `if (kReleaseMode)` en `main.dart`).
  - No tiene hot reload ni herramientas de depuración (es más rápido y seguro).
  - Útil para probar cómo se comporta en producción antes de distribuir.

3. Para construir y distribuir (ej. generar un APK para Android):
  - Para Android:
    ```
    flutter build apk --release
    ```
    - Esto crea un archivo `.apk` en `build/app/outputs/flutter-apk/app-release.apk`.
    - Instálalo en un dispositivo con `adb install build/app/outputs/flutter-apk/app-release.apk`.
  - Para iOS (en macOS):
    ```
    flutter build ios --release
    ```
    - Abre el proyecto en Xcode y archívalo para distribución.

4. Para web (si es una app web):
   ```
   flutter build web --release
   ```
  - Luego, sirve con un servidor web (ej. `flutter run --release` para web).

### Notas importantes
- **Carga automática de .env**: Como configuramos en `main.dart`, no necesitas cambiar nada manualmente. Flutter detecta automáticamente si es debug o release y carga el archivo correspondiente.
- **Diferencias clave**:
  - **Debug**: Más lento, con asserts y depuración activados. Ideal para desarrollo.
  - **Release**: Más rápido, sin depuración, y usa las variables de producción (ej. URLs reales en lugar de dev).
- **Errores comunes**:
  - Asegúrate de que los archivos `.env` existan y estén en la raíz del proyecto.
  - Si usas un emulador, verifica que esté corriendo.
  - Para producción, firma tu app (configura `android/app/build.gradle` para Android o Xcode para iOS) antes de distribuir.
- **Pruebas**: Siempre prueba en ambos modos para asegurar que las variables de entorno se carguen correctamente (puedes agregar prints temporales en `main.dart` para verificar).
