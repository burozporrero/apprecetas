// routes/recetas.js
// Módulo de rutas para endpoints de Recetas. Conecta controladores con Express.
// Principio SOLID: Single Responsibility - Solo define rutas.
// Principio SOLID: Interface Segregation - Expone solo los endpoints necesarios.

const express = require('express');
const router = express.Router();
const { getRecetas, createReceta, updateReceta, deleteReceta } = require('../controllers/recetaController');

// GET /api/recetas - Obtener todas las recetas
router.get('/', getRecetas);

// POST /api/recetas - Crear una nueva receta
router.post('/', createReceta);

// PUT /api/recetas/:id - Actualizar una receta por ID
router.put('/:id', updateReceta);

// DELETE /api/recetas/:id - Eliminar una receta por ID
router.delete('/:id', deleteReceta);

module.exports = router;