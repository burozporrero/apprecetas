// lib/presentation/screens/recipe_form_screen.dart
// Pantalla para crear/editar receta (Clean Code: reutilizable)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/recipe_provider.dart';
import '../../domain/providers/auth_provider.dart';
import '../../data/models/recipe.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? recipe;

  RecipeFormScreen({this.recipe});

  @override
  _RecipeFormScreenState createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.recipe?.nombre ?? '');
    _ingredientsController = TextEditingController(
      text: widget.recipe?.ingredientes.join(', ') ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.recipe?.instrucciones ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final token = authProvider.token;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe == null ? 'add_recipe'.tr() : 'edit_recipe'.tr(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'name'.tr()),
                validator: (v) => v!.isEmpty ? 'required'.tr() : null,
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'ingredients'.tr()),
                validator: (v) => v!.isEmpty ? 'required'.tr() : null,
              ),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(labelText: 'instructions'.tr()),
                validator: (v) => v!.isEmpty ? 'required'.tr() : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final recipe = Recipe(
                      id: widget.recipe?.id,
                      nombre: _nameController.text,
                      ingredientes: _ingredientsController.text.split(', '),
                      instrucciones: _instructionsController.text,
                    );
                    try {
                      if (widget.recipe == null) {
                        await recipeProvider.addRecipe(token!, recipe);
                      } else {
                        await recipeProvider.updateRecipe(
                          token!,
                          recipe.id!,
                          recipe,
                        );
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('error_saving_recipe'.tr())),
                      );
                    }
                  }
                },
                child: Text('save'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
