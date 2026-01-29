// lib/data/models/recipe.dart
// Modelo para Recipe (Clean Code: encapsula datos)

class Recipe {
  final int? id;
  final String nombre;
  final List<String> ingredientes;
  final String instrucciones;
  final int? usuarioId;

  Recipe({
    this.id,
    required this.nombre,
    required this.ingredientes,
    required this.instrucciones,
    this.usuarioId,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      instrucciones: json['instrucciones'] as String,
      usuarioId: json['usuario_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'ingredientes': ingredientes,
      'instrucciones': instrucciones,
    };
  }
}
