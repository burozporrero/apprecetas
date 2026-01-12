// database/db.js
// Módulo para manejar la conexión y operaciones básicas de MySQL.
// Principio SOLID: Single Responsibility - Solo gestiona la DB.

require('dotenv').config(); // Cargar variables de entorno
const mysql = require('mysql2/promise'); // Usamos mysql2 para promesas (compatible con MySQL)

// Configuración de conexión a MySQL usando variables de entorno
const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,         // Agrega esto: puerto de MySQL (cambia si es diferente)
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
  queueLimit: 0,
};

// Crear pool de conexiones
const pool = mysql.createPool(dbConfig);

// Inicializar tablas si no existen
const initDB = async () => {
  try {
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL
      )
    `);
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS recetas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL,
        ingredientes JSON NOT NULL, 
        instrucciones TEXT NOT NULL,
        usuario_id INT NOT NULL,  
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
      )
    `);
    // MySQL soporta JSON desde 5.7.8
    // Relación con usuario (para que cada receta pertenezca a un usuario)
    console.log('Tablas inicializadas correctamente en MySQL.');
  } catch (error) {
    console.error('Error inicializando DB:', error);
  }
};

initDB(); // Ejecutar al cargar el módulo

module.exports = pool; // Exportamos el pool para reutilizarlo