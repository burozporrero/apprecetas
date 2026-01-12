// routes/auth.js
// Módulo de rutas para endpoints de autenticación (registro y login).
// Principio SOLID: Single Responsibility - Solo define rutas relacionadas con auth.
// Principio SOLID: Interface Segregation - Expone únicamente los endpoints necesarios para registro y login.

const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/authController'); // Importa funciones del controlador de auth

// POST /api/auth/register - Endpoint para registrar un nuevo usuario
// Recibe: { "username": "string", "password": "string" }
// Responde: Mensaje de éxito o error
router.post('/register', register);

// POST /api/auth/login - Endpoint para iniciar sesión
// Recibe: { "username": "string", "password": "string" }
// Responde: Token JWT y datos del usuario, o error
router.post('/login', login);

module.exports = router; // Exporta el router para usarlo en server.js