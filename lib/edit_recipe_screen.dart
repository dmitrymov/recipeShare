import 'package:flutter/material.dart';
import 'package:your_app_name/data/database_helper.dart'; // Adjust the import path
import 'dart:convert';

class EditRecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipeScreen({super.key, required this.recipe});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _instructionsController;
  String? _selectedCategory;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _nameController = TextEditingController(text: widget.recipe['name'] ?? '');
    _ingredientsController = TextEditingController(text: (jsonDecode(widget.recipe['ingredients'] ?? '[]') as List<dynamic>).cast<String>().join('\n'));
    _instructionsController = TextEditingController(text: (jsonDecode(widget.recipe['instructions'] ?? '[]') as List<dynamic>).cast<String>().join('\n'));
    _selectedCategory = widget.recipe['category_id']?.toString();
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  Future<void> _updateRecipe() async {
    if (_formKey.currentState!.validate()) {
      final updatedRows = await _dbHelper.updateRecipe({
        'id': widget.recipe['id'],
        'name': _nameController.text,
        'ingredients': _ingredientsController.text.split('\n').map((e) => e.trim()).toList(),
        'instructions': _instructionsController.text.split('\n').map((e) => e.trim()).toList(),
        'categoryId': _selectedCategory != null ? int.tryParse(_selectedCategory!) : null,
        'notes': widget.recipe['notes'] ?? '', // Keep existing notes for now
      });

      if (updatedRows > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe updated successfully!')),
        );
        Navigator.pop(context); // Go back to the details screen
        // Optionally, you might want to refresh the recipe details on the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update recipe.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ingredientsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (one per line)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the ingredients';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _instructionsController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Instructions (one step per line)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['name'] ?? 'No Name'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _updateRecipe,
                child: const Text('Update Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}