// models/Usuario.js
// Clase que representa un usuario. Encapsula datos y validaciones.
// Principio SOLID: Single Responsibility - Solo define la entidad Usuario.

const bcrypt = require('bcryptjs');

class Usuario {
  constructor(id, username, password) {
    this.id = id; // ID autogenerado
    this.username = username; // Nombre de usuario único
    this.password = password; // Contraseña hasheada
  }

  // Método para hashear la contraseña (Clean Code: función enfocada)
  static async hashPassword(password) {
    return await bcrypt.hash(password, 10); // Salt rounds = 10
  }

  // Método para verificar contraseña (comparar con hash)
  static async verifyPassword(password, hash) {
    return await bcrypt.compare(password, hash);
  }

  // Validar campos obligatorios
  validar() {
    if (!this.username || !this.password) {
      throw new Error('Username y password son obligatorios.');
    }
  }

  // Convertir a objeto plano (sin password para respuestas)
  toObject() {
    return {
      id: this.id,
      username: this.username,
    };
  }
}

module.exports = Usuario;