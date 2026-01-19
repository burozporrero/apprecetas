// lib/presentation/screens/login_screen.dart
// Pantalla de login (Clean Code: UI separada)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('login'.tr())),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'email'.tr()),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'password'.tr()),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  Navigator.pushReplacementNamed(
                    context,
                    '/recipes',
                  ); // Navega a lista de recetas
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('error_invalid_credentials'.tr())),
                  );
                }
              },
              child: Text('login'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
