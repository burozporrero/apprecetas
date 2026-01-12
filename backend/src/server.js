// server.js
// Punto de entrada de la aplicación. Configura el servidor Express, conecta rutas y middleware.
// Principio SOLID: Single Responsibility - Solo configura el servidor.
// Principio SOLID: Dependency Inversion - Depende de rutas y middleware abstractos.

require('dotenv').config(); // Cargar variables de entorno
const express = require('express'); // Estmoas utilizando express para el servidor
const https = require('node:https'); //node:https es la versión "mejorada" y recomendada para código moderno, mientras que https es legacy pero válido.
const fs = require('node:fs');

const logger = require('./logger'); // Módulo de logging personalizado
const i18nMiddleware = require('./middleware/i18n');  // Ruta relativa a src/middleware/i18n.js

const bodyParser = require('body-parser'); // Middleware para parsear cuerpos de solicitudes
const cors = require('cors'); // Middleware para habilitar CORS
const authMiddleware = require('./middleware/auth'); // Middleware para verificar tokens

const recetaRoutes = require('./routes/recetas'); // Rutas de recetas (protegidas)
const authRoutes = require('./routes/auth'); // Nuevas rutas de autenticación (públicas)

const options = {
  key: fs.readFileSync('localhost-key.pem'),
  cert: fs.readFileSync('localhost.pem')
};

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para parsear JSON, habilitar CORS e internacionalización
app.use(bodyParser.json());
app.use(cors());
app.use(i18nMiddleware);

// TESTING GET Para test básico del servidor (health check)
app.get('/', (req, res) => res.send('Servidor funcionando'));

// Rutas públicas (no requieren token)
app.use('/api/auth', authRoutes); // Registro y login

// Rutas protegidas (requieren token)
app.use('/api/recetas', authMiddleware, recetaRoutes); // Aplicamos middleware de auth a todas las rutas de recetas

// Iniciar el servidor
https.createServer(options, app).listen(PORT, () => {
  logger.info('Mensaje informativo', `Servidor seguro corriendo en https://localhost:${PORT}`);
  //console.log(`Servidor seguro corriendo en https://localhost:${PORT}`); // Comentado para ver lo que tenemos que EVITAR
});