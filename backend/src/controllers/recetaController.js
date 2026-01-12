// controllers/recetaController.js
// Controlador que maneja la lógica de negocio para operaciones CRUD en Recetas.
// Principio SOLID: Single Responsibility - Solo procesa solicitudes relacionadas con Recetas.
// Principio SOLID: Dependency Inversion - Depende de la clase Receta y la DB.

const Receta = require('../models/Receta');
const db = require('../database/db');
const logger = require('../logger');

// Función auxiliar para ejecutar queries de DB (Clean Code: extrae lógica repetitiva)
const runQuery = async (query, params = []) => {
  const [rows] = await db.execute(query, params);
  return rows;
};

// Obtener todas las recetas del usuario autenticado (READ)
const getRecetas = async (req, res) => {
  try {
    const usuario_id = req.user.id; // Obtenido del middleware de auth
    const rows = await runQuery('SELECT * FROM recetas WHERE usuario_id = ?', [usuario_id]);
    const recetas = rows.map(row => new Receta(row.id, row.nombre, JSON.parse(row.ingredientes), row.instrucciones, row.usuario_id));
    res.json(recetas.map(r => r.toObject()));
  } catch (error) {
    logger.error('Error al obtener recetas', { error: error.message });
    res.status(500).json({ error: 'Error al obtener recetas' });
  }
};

// Crear una nueva receta (CREATE)
const createReceta = async (req, res) => {
  try {
    const { nombre, ingredientes, instrucciones } = req.body;
    const usuario_id = req.user.id; // Del token
    const receta = new Receta(null, nombre, ingredientes, instrucciones, usuario_id);
    receta.validar();

    const [result] = await db.execute('INSERT INTO recetas (nombre, ingredientes, instrucciones, usuario_id) VALUES (?, ?, ?, ?)', [nombre, JSON.stringify(ingredientes), instrucciones, usuario_id]);
    receta.id = result.insertId;
    res.status(201).json(receta.toObject());
  } catch (error) {
    logger.error('Error al crear receta', { error: error.message });
    res.status(400).json({ error: error.message });
  }
};

// Actualizar una receta existente (UPDATE) - Solo si pertenece al usuario
const updateReceta = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, ingredientes, instrucciones } = req.body;
    const usuario_id = req.user.id;
    const receta = new Receta(id, nombre, ingredientes, instrucciones, usuario_id);
    receta.validar();

    const [result] = await db.execute('UPDATE recetas SET nombre = ?, ingredientes = ?, instrucciones = ? WHERE id = ? AND usuario_id = ?', [nombre, JSON.stringify(ingredientes), instrucciones, id, usuario_id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Receta no encontrada o no autorizada' });
    res.json(receta.toObject());
  } catch (error) {
    logger.error('Error al actualizar receta', { error: error.message });
    res.status(400).json({ error: error.message });
  }
};

// Eliminar una receta (DELETE) - Solo si pertenece al usuario
const deleteReceta = async (req, res) => {
  try {
    const { id } = req.params;
    const usuario_id = req.user.id;
    const [result] = await db.execute('DELETE FROM recetas WHERE id = ? AND usuario_id = ?', [id, usuario_id]);
    if (result.affectedRows === 0) return res.status(404).json({ error: 'Receta no encontrada o no autorizada' });
    res.json({ message: 'Receta eliminada' });
  } catch (error) {
    logger.error('Error al eliminar receta', { error: error.message });
    res.status(500).json({ error: 'Error al eliminar receta' });
  }
};

module.exports = { getRecetas, createReceta, updateReceta, deleteReceta };