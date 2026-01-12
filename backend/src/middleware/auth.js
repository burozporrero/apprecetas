// middleware/auth.js
// Middleware para verificar tokens JWT en rutas protegidas.
// Principio SOLID: Single Responsibility - Solo verifica autenticación.

const jwt = require('jsonwebtoken');
const logger = require('../logger');
const JWT_SECRET = process.env.JWT_SECRET || 'tu_clave_secreta';

const authMiddleware = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', ''); // Extraer token del header
  if (!token) {
    logger.warn('Acceso denegado. Token no proporcionado.');
    return res.status(401).json({ error: 'Acceso denegado. Token requerido.' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded; // Adjuntar info del usuario a req
    next();
  } catch (error) {
    logger.error('Token inválido', { error: error.message });
    res.status(401).json({ error: 'Token inválido.' });
  }
};

module.exports = authMiddleware;