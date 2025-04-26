import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:recipeShare/app_localizations.dart';
import 'package:recipeShare/database_helper.dart';
import 'package:recipeShare/edit_recipe_screen.dart';
import 'package:recipeShare/models/recipe.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Future<void> _deleteRecipe(BuildContext context) async {
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
      int rowsAffected = await _dbHelper.deleteRecipe(_recipe.id!);
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

  Future<void> _shareRecipe(BuildContext context, Recipe recipe) async {
    final String name = recipe.name;
    final String ingredients = recipe.ingredients;
    final String instructions = recipe.instructions;

    String textToShare = '$name\n\nIngredients:\n$ingredients\n\nInstructions:\n$instructions';

    if (recipe.notes.isNotEmpty) {
      textToShare += '\n\nNotes:\n${recipe.notes}';
    }
    SharePlus.instance.share(ShareParams(
        text: textToShare,
        subject: "Share",
      ));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> ingredients = _recipe.ingredients.split('\n').where((s) => s.trim().isNotEmpty).toList();
    final List<String> instructions = _recipe.instructions.split('\n').where((s) => s.trim().isNotEmpty).toList();
    List<String> images = [];

    try {
      images = _recipe.images!.cast<String>();
        } catch (e) {
      print('Error casting images to List<String>: $e');
      images = [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).recipeDetails),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(
                    builder: (context) => EditRecipeScreen(recipe: _recipe))
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
            if (images.isNotEmpty)
              SizedBox(
                height: 200, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(images[index]),
                    );
                  },
                )),
            Text(
              _recipe.name ?? 'Untitled Recipe',
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
                        child: Text('$index. $step'));
                  }).toList())
            else 
              const Text('No instructions provided.'),
            if (_recipe.notes.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(_recipe.notes),
            ],
            ...[
            const SizedBox(height: 16.0),
            Text(
              'Added on: ${_recipe.createdAt!.toLocal().toString().split('.')[0]}',
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
        onPressed: () => _shareRecipe(context, _recipe),
        child: const Icon(Icons.share),
      ),
    );
  }
}