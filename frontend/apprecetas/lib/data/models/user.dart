// lib/data/models/user.dart
class User {
  final int id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id'] as int
          : throw Exception('id debe ser int'),
      username: json['username'] is String ? json['username'] as String : '',
    );
  }
}
