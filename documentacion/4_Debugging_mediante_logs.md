# Herramientas Recomendadas para Debugging en Producción con Logs Estructurados

<!-- TOC -->
* [Herramientas Recomendadas para Debugging en Producción con Logs Estructurados](#herramientas-recomendadas-para-debugging-en-producción-con-logs-estructurados)
  * [Herramientas Principales](#herramientas-principales)
  * [Configuración concreta de Winston para Logs Estructurados](#configuración-concreta-de-winston-para-logs-estructurados)
    * [Instalación y Configuración Básica](#instalación-y-configuración-básica)
      * [Uso de Niveles, Filtros y Rotado](#uso-de-niveles-filtros-y-rotado)
      * [Integración en tu Código](#integración-en-tu-código)
  * [Puntos Recomendados para Poner Logs](#puntos-recomendados-para-poner-logs)
<!-- TOC -->

En producción, el debugging se basa en logs detallados y estructurados (e.g., en formato JSON) para rastrear errores, rendimiento y comportamiento sin detener la aplicación. Recomiendo herramientas que integren bien con Node.js y Express. Aquí detallo las mejores opciones, enfocándome en simplicidad y escalabilidad.

## Herramientas Principales
- **Winston**:
    - **Descripción**: Librería de logging para Node.js que permite logs estructurados (JSON), niveles de severidad (e.g., info, warn, error) y transporte a archivos, consola o servicios externos (e.g., CloudWatch, Elasticsearch).
    - **Ventajas**: Fácil integración con Express; soporta rotación de logs y filtros. Ideal para producción.
    - **Instalación y Uso Básico**:
      ```
      npm install winston
      ```
        - Ejemplo en `server.js`:
          ```javascript
          const winston = require('winston');
          const logger = winston.createLogger({
            level: 'info',
            format: winston.format.json(),  // Logs estructurados
            transports: [
              new winston.transports.Console(),
              new winston.transports.File({ filename: 'logs/app.log' })
            ]
          });
          // Uso: logger.info('Mensaje', { extraData: 'valor' });
          ```
    - **Recomendación**: Úsalo para logs personalizados en controladores y middlewares.

- **Morgan**:
    - **Descripción**: Middleware para Express que genera logs automáticos de solicitudes HTTP (e.g., método, URL, tiempo de respuesta).
    - **Ventajas**: Logs estructurados para tráfico web; integrable con Winston para centralizar.
    - **Instalación y Uso**:
      ```
      npm install morgan
      ```
        - Ejemplo en `server.js`:
          ```javascript
          const morgan = require('morgan');
          app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));  // Integra con Winston
          ```

- **PM2**:
    - **Descripción**: Gestor de procesos para Node.js en producción; incluye logs en tiempo real, reinicio automático y monitoreo.
    - **Ventajas**: Logs estructurados con timestamps; soporta clusters y dashboards web.
    - **Instalación y Uso**:
      ```
      npm install -g pm2
      pm2 start server.js --name "mi-app" --log logs/pm2.log
      pm2 logs  # Ver logs en tiempo real
      ```
    - **Recomendación**: Para entornos de producción; combina con Winston para logs detallados.

## Configuración concreta de Winston para Logs Estructurados

Winston es ideal para logs en Node.js. Vamos a configurarlo con niveles (info, debug, error), filtros y rotado de logs. 
Instálalo con `npm install winston`.

### Instalación y Configuración Básica
- Crea un archivo `src/logger.js` para centralizar la configuración:
  ```javascript
  // src/logger.js
  const winston = require('winston');
  const path = require('path');

  // Configura rotado de logs (archivos diarios)
  const logFormat = winston.format.combine(
    winston.format.timestamp(),  // Agrega timestamp
    winston.format.errors({ stack: true }),  // Incluye stack traces en errores
    winston.format.json()  // Formato JSON estructurado
  );

  const logger = winston.createLogger({
    level: process.env.LOG_LEVEL || 'info',  // Nivel mínimo (info incluye debug y error)
    format: logFormat,
    transports: [
      // Consola para desarrollo
      new winston.transports.Console({
        format: winston.format.simple()  // Formato legible en consola
      }),
      // Archivo con rotado diario
      new winston.transports.File({
        filename: path.join(__dirname, '../logs/app.log'),
        maxsize: 5242880,  // 5MB por archivo
        maxFiles: 5,  // Máximo 5 archivos
        tailable: true  // Rotado automático
      }),
      // Archivo separado para errores
      new winston.transports.File({
        filename: path.join(__dirname, '../logs/error.log'),
        level: 'error'  // Solo errores
      })
    ]
  });

  module.exports = logger;
  ```
- Crea la carpeta `logs/` en la raíz del proyecto.

#### Uso de Niveles, Filtros y Rotado
- **Niveles**:
    - `logger.error('Mensaje de error', { extra: 'data' });` // Para errores críticos.
    - `logger.warn('Mensaje de advertencia');` // Para issues menores.
    - `logger.info('Mensaje informativo', { userId: 123 });` // Para eventos normales.
    - `logger.debug('Mensaje de debug', { variable: 'valor' });` // Para desarrollo (solo si level es 'debug').
- **Filtros**:
    - Usa `winston.format` para filtrar: Agrega un filtro para omitir logs de ciertos módulos.
      ```javascript
      // En logger.js, dentro de format
      winston.format.combine(
        winston.format((info) => {
          if (info.module === 'auth' && info.level === 'debug') return false;  // Filtra debug de auth
          return info;
        })(),
        // ... otros formatos
      );
      ```
- **Rotado**:
    - Configurado en `transports.File` con `maxsize` (tamaño máximo) y `maxFiles` (número de archivos). Los logs antiguos se rotan automáticamente (e.g., app.log.1, app.log.2).

#### Integración en tu Código
- Importa en `server.js`: `const logger = require('./logger');`.
- Ejemplos de uso:
    - En rutas: `logger.info('Usuario logueado', { username });`.
    - En errores: `logger.error('Error en DB', { error: err.message });`.

## Puntos Recomendados para Poner Logs
Coloca logs en puntos clave para rastrear flujo, errores y rendimiento. Usa niveles apropiados (e.g., `info` para eventos normales, `error` para fallos). Integra Winston en tu código existente.

- **Inicio de la Aplicación**:
    - Log al iniciar el servidor: `logger.info('Servidor iniciado en puerto', { port: PORT });`.
    - Conexión a DB: En `database/db.js`, log éxito/error: `logger.info('DB conectada');` o `logger.error('Error conectando DB', { error: err.message });`.

- **Middlewares y Autenticación**:
    - En `middleware/auth.js`: Log intentos de acceso: `logger.warn('Token inválido', { ip: req.ip });`.
    - Verificación de JWT: `logger.info('Usuario autenticado', { userId: req.user.id });`.

- **Operaciones CRUD**:
    - En controladores (e.g., `recetaController.js`): Log antes/después de queries: `logger.info('Creando receta', { userId, nombre });` y `logger.error('Error creando receta', { error });`.
    - Resultados: `logger.info('Receta creada', { id: result.insertId });`.

- **Errores y Excepciones**:
    - En bloques try-catch: `logger.error('Error en login', { username, error: err.message });`.
    - Middleware global de errores en `server.js`: `app.use((err, req, res, next) => { logger.error('Error global', { error: err.message, stack: err.stack }); res.status(500).json({ error: 'Error interno' }); });`.

- **Puntos Adicionales**:
    - Solicitudes lentas: En middlewares, mide tiempo: `logger.warn('Solicitud lenta', { url: req.url, duration: Date.now() - start });`.
    - Cambios críticos: Log al hashear passwords o validar datos.
    - Producción: Desactiva logs de debug/info en entornos no críticos; usa variables de entorno (e.g., `NODE_ENV=production`).
