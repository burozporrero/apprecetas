// models/Receta.js
// Clase que representa una receta. Encapsula los datos y validaciones básicas.
// Principio SOLID: Single Responsibility - Solo define la estructura y validaciones de la entidad.

class Receta {
  constructor(id, nombre, ingredientes, instrucciones, usuario_id) {
    this.id = id; // ID autogenerado por la DB
    this.nombre = nombre; // Nombre de la receta (string)
    this.ingredientes = ingredientes; // Lista de ingredientes (array o string)
    this.instrucciones = instrucciones; // Instrucciones de preparación (string)
    this.usuario_id = usuario_id; // ID del usuario propietario (nuevo para autenticación)
  }

  // Método para validar que los campos obligatorios estén presentes (Clean Code: función pequeña y descriptiva)
  validar() {
    if (!this.nombre || !this.ingredientes || !this.instrucciones || !this.usuario_id) {
      throw new Error('Todos los campos (nombre, ingredientes, instrucciones, usuario_id) son obligatorios.');
    }
  }

  // Método para convertir a objeto plano (útil para respuestas JSON)
  toObject() {
    return {
      id: this.id,
      nombre: this.nombre,
      ingredientes: this.ingredientes,
      instrucciones: this.instrucciones,
      usuario_id: this.usuario_id,
    };
  }
}

module.exports = Receta;