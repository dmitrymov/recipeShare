import 'package:flutter/material.dart';
import 'package:recipeShare/database_helper.dart';
import 'package:recipeShare/recipe_item.dart';

class RecipeListByCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const RecipeListByCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<RecipeListByCategoryScreen> createState() => _RecipeListByCategoryScreenState();
}

class _RecipeListByCategoryScreenState extends State<RecipeListByCategoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipesByCategory();
  }

  Future<void> _loadRecipesByCategory() async {
    final db = await _dbHelper.database;
    final recipes = await db.query(
      'recipes',
      where: 'category_id = ?',
      whereArgs: [widget.categoryId],
    );
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes in ${widget.categoryName}'),
      ),
      body: _recipes.isEmpty
          ? Center(
              child: Text('No recipes in ${widget.categoryName} yet.'),
            )
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return RecipeItem(recipe: recipe);

              },
            ),
    );
  }
}