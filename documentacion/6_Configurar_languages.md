# Configurar idiomas en Node / Express (equivalente a ResourceBundle + Locale de Java)

En **Node / Express**, el equivalente limpio a `ResourceBundle + Locale` de Java es:

👉 **i18n basado en archivos + middleware**
👉 Separar **detección de idioma**, **traducciones** y **uso**

La solución más usada, limpia y mantenible es **i18next** (o `i18n` clásico).

#### ¿Es Recomendable Usar i18next en el Servidor?
Sí, **es altamente recomendable** en el back-end de Node.js. i18next no es solo para front-end ; en servidores, se 
usa para traducir respuestas API, mensajes de error, logs y emails. Hay algunas librerías (e.g., `react-i18next`) 
que son específicas para front-end, pero `i18next` base funciona bien en back-end.

#### Estructura Actualizada de Archivos
```
backend/
├── src/
│   ├── locales/          # Archivos YAML
│   │   ├── en.yaml
│   │   ├── es.yaml
│   │   └── ...
│   ├── middleware/
│   │   └── i18n.js       # Configuración con YAML
│   └── server.js         # Integra middleware
```

---

## ✅ Enfoque recomendado (equivalente a Java)

| Java                 | Node           |
| -------------------- |----------------|
| `ResourceBundle`     | Archivos YAML  |
| `Locale`             | `req.language` |
| `bundle.getString()` | `req.t()`      |

---

## 1️⃣ Instalar dependencias

```bash
npm install i18next i18next-fs-backend i18next-http-middleware js-yaml
```

---

## 2️⃣ Estructura de proyecto

```
backend/
├── src/
│   ├── locales/          # Archivos YAML
│   │   ├── en.yaml
│   │   ├── es.yaml
│   │   └── ...
│   ├── middleware/
│   │   └── i18n.js       # Configuración con YAML
│   └── server.js         # Integra middleware
```

---

## 3️⃣ Archivos de idioma (como ResourceBundle)

### `i18n/es.yaml`
### `i18n/en.yaml`

```yaml
greeting: "Hello"
welcome: "Welcome to the Recipes API"

recipe:
    created: "Recipe created successfully"
    not_found: "Recipe not found"

user:
    registered: "User registered successfully"
    error:
        invalid_credentials: "Invalid credentials"
        registered: "Username already exists"
        general: "An error occurred. Please try again."

error:
    userNotFound: "User not found"
```

---

## 4️⃣ Configuración i18n (equivalente a Locale)

### `config/i18n.js`

```js
// src/middleware/i18n.js
// Configuración con YAML para mayor legibilidad (Clean Code: configuración centralizada)

const i18next = require('i18next');
const Backend = require('i18next-fs-backend');
const middleware = require('i18next-http-middleware');
const path = require('node:path');
const yaml = require('js-yaml');
const fs = require('node:fs');

i18next
    .use(Backend)
    .use(middleware.LanguageDetector)
    .init({
        fallbackLng: 'en',
        lng: 'es',  // Idioma inicial
        ns: ['translation'],
        defaultNS: 'translation',
        backend: {
            loadPath: path.join(__dirname, '../locales/{{lng}}.yaml'),  // Cambia a .yaml
            parse: yaml.load  // Usa js-yaml para parsear YAML
        },
        detection: {
            order: ['header', 'querystring', 'cookie'],
            lookupHeader: 'accept-language',
            caches: ['cookie']
        },
        interpolation: {
            escapeValue: false  // Desactiva escape para HTML (seguro en API JSON)
        }
    });

module.exports = middleware.handle(i18next);
```

---

## 5️⃣ Uso en Express

### `server.js`

```js
const i18nMiddleware = require('./middleware/i18n');  // Ruta relativa a src/middleware/i18n.js
...
app.use(i18nMiddleware);
```

---

## 6️⃣ Cómo se selecciona el idioma

* Header HTTP:

```
Accept-Language: en
```

* Query string:

```
/?lng=es
```

---


## 6️⃣ Uso en Controladores para Mensajes de Error

Devuelve mensajes de error traducidos en respuestas JSON. En back-end, no renderizas HTML; traduces strings para respuestas API.

- **En controllers/authController.js**:
  ```javascript
  const register = async (req, res) => {
    try {
      // ... lógica
      res.status(201).json({ message: req.t('user_registered') });  // Mensaje traducido
    } catch (error) {
      res.status(400).json({ error: req.t('error_invalid_credentials') });  // Error traducido
    }
  };
  ```
- **Recomendaciones para Errores**:
    - **Consistencia**: Siempre usa `req.t(key)` para traducir. Para variables: `req.t('welcome_user', { name: user.name })`.
    - **Códigos de Error**: Incluye códigos junto a mensajes (e.g., `{ error: req.t('error_invalid_credentials'), code: 'INVALID_CREDENTIALS' }`).
    - **Logs**: Traduce logs con i18next si es necesario, pero usa Winston para estructurar.
    - **Fallback**: Si una clave no existe, devuelve la clave en inglés (configurado por defecto).
    - **Validación**: Agrega middleware para validar locale (e.g., solo 'en' o 'es').

## Pruebas y Consejos Finales
- **Prueba**: Envía `Accept-Language: es` en Postman. Para `/register`, deberías ver "Usuario registrado exitosamente".
- **Namespaces**: Para escalabilidad, divide en `auth.yaml` y `recipes.yaml`, y carga con `ns: ['auth', 'recipes']`.
- **Herramientas**: Usa `i18next-scanner` para extraer claves del código automáticamente.
- **Limitaciones**: i18next es síncrono en carga inicial; para apps grandes, considera cache avanzado.
