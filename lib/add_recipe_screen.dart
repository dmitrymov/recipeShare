import 'package:flutter/material.dart';
import 'package:recipeShare/app_localizations.dart';
import 'package:recipeShare/custom_app_bar.dart';
import 'package:recipeShare/database_helper.dart';
import 'package:recipeShare/models/category.dart';
import 'package:recipeShare/models/recipe.dart'; // Adjust the import path as needed

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Category> _categories = [];
  String _selectedCategoryName = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getAllCategories();
    setState(() {
      _categories = categories.isNotEmpty ? categories : [];
    });
    if (_categories.isNotEmpty) {
      _selectedCategory = _categories.first.id ?? 0;
      _loadCategoryName();
    }
  }

  Future<void> _loadCategoryName() async {
    final category = await _dbHelper.getCategoryById(_selectedCategory);
    setState(() => _selectedCategoryName = category?.name ?? '');
  }
  int _selectedCategory = 0;
  Future<void> _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      int catId = _selectedCategory;
      final newRecipeId = await _dbHelper.insertRecipe(Recipe(
        name: _nameController.text,
        ingredients: _ingredientsController.text,
        instructions: _instructionsController.text,
        categoryId: catId,
        notes: '', // We can add a notes field later if needed
        images: [], // We can add an images field later if needed
        createdAt: DateTime.now(),  
      ));

      if (newRecipeId > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe saved successfully!')),
        );
        // Optionally, navigate back to the home screen or clear the form
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save recipe.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: AppLocalizations.of(context).addRecipe,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 0;
                    _loadCategoryName();
                  });
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}