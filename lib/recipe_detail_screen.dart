import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:your_app_name/data/database_helper.dart'; // Adjust the import path
import 'package:your_app_name/edit_recipe_screen.dart'; // Adjust the import path
import 'package:share_plus/share_plus.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  RecipeDetailScreen({super.key, required this.recipe});

  Future<void> _deleteRecipe(BuildContext context) async {
    int? recipeId = recipe['id'];
    if (recipeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe ID is missing.')),
      );
      return;
    }

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      int rowsAffected = await _dbHelper.deleteRecipe(recipeId);
      if (rowsAffected > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe deleted successfully.')),
        );
        Navigator.pop(context); // Go back to the previous screen
        // Optionally, you might want to refresh the list of recipes on the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete recipe.')),
        );
      }
    }
  }

  Future<void> _shareRecipe(BuildContext context) async {
    final String name = recipe['name'] ?? 'Untitled Recipe';
    final List<String> ingredients = (jsonDecode(recipe['ingredients'] ?? '[]') as List<dynamic>)
        .cast<String>();
    final List<String> instructions = (jsonDecode(recipe['instructions'] ?? '[]') as List<dynamic>)
        .cast<String>();

    String textToShare = '$name\n\nIngredients:\n${ingredients.map((i) => '- $i').join('\n')}\n\nInstructions:\n${instructions.asMap().entries.map((entry) => '${entry.key + 1}. ${entry.value}').join('\n')}';

    if (recipe['notes'] != null && recipe['notes'].isNotEmpty) {
      textToShare += '\n\nNotes:\n${recipe['notes']}';
    }

    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> ingredients = (jsonDecode(recipe['ingredients'] ?? '[]') as List<dynamic>)
        .cast<String>();
    final List<String> instructions = (jsonDecode(recipe['instructions'] ?? '[]') as List<dynamic>)
        .cast<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name'] ?? 'Recipe Details'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecipeScreen(recipe: recipe),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              recipe['name'] ?? 'Untitled Recipe',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (ingredients.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients.map((ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('- $ingredient'),
                    )).toList(),
              )
            else
              const Text('No ingredients listed.'),
            const SizedBox(height: 16.0),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            if (instructions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: instructions.asMap().entries.map((entry) {
                  int index = entry.key + 1;
                  String step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('$index. $step'),
                  );
                }).toList(),
              )
            else
              const Text('No instructions provided.'),
            if (recipe['notes'] != null && recipe['notes'].isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(recipe['notes']),
            ],
            if (recipe['created_at'] != null) ...[
              const SizedBox(height: 16.0),
              Text(
                'Added on: ${DateTime.parse(recipe['created_at']).toLocal().toString().split('.')[0]}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _deleteRecipe(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Recipe', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _shareRecipe(context),
        child: const Icon(Icons.share),
      ),
    );
  }
}