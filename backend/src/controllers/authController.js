// controllers/authController.js
// Controlador que maneja la lógica de negocio para registro y login de usuarios.
// Principio SOLID: Single Responsibility - Solo procesa solicitudes de auth.
// Principio SOLID: Dependency Inversion - Depende de la clase Usuario y la DB.

const Usuario = require('../models/Usuario');
const jwt = require('jsonwebtoken');
const db = require('../database/db');
const logger = require('../logger');

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1h';

// Función auxiliar para ejecutar queries de DB (Clean Code: extrae lógica repetitiva)
const runQuery = async (query, params = []) => {
  const [rows] = await db.execute(query, params);
  return rows;
};

// Registro de usuario (CREATE)
const register = async (req, res) => {
  try {
    const { username, password } = req.body;
    const hashedPassword = await Usuario.hashPassword(password);
    const usuario = new Usuario(null, username, hashedPassword);
    usuario.validar();

    await runQuery('INSERT INTO usuarios (username, password) VALUES (?, ?)', [username, hashedPassword]);
    res.status(201).json({ message: 'Usuario registrado exitosamente' });
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') { // Error de duplicado en MySQL
      logger.info('Error de registro: username duplicado', { username: req.body.username });
      res.status(400).json({ error: req.t(user.error.registered)});
    } else {
      logger.error('Error de registro', { error: error.message });
      res.status(400).json({ error: req.t('user.error.general') });
    }
  }
};

// Login de usuario
const login = async (req, res) => {
  try {
    const { username, password } = req.body;
    const rows = await runQuery('SELECT * FROM usuarios WHERE username = ?', [username]);
    if (rows.length === 0) {
      logger.info('Intento de login fallido: usuario no encontrado', { username });
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    const usuario = rows[0];
    const isValid = await Usuario.verifyPassword(password, usuario.password);
    if (!isValid) {
      logger.info('Intento de login fallido: contraseña incorrecta', { username });
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }

    // Generar token JWT (expira en 1 hora)
    const token = jwt.sign({ id: usuario.id, username: usuario.username }, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
    if(logger.isDebugEnabled()) logger.debug('Login exitoso', { username });
    res.json({ token, usuario: new Usuario(usuario.id, usuario.username, null).toObject() });
  } catch (error) {
    logger.error('Error en login', { error: error.message });
    res.status(500).json({ error: 'Error en login' });
  }
};

module.exports = { register, login };