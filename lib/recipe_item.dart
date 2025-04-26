import 'package:flutter/material.dart';
import 'package:recipeShare/recipe_detail_screen.dart';

class RecipeItem extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeItem({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        title: Text(recipe['name'] ?? 'Untitled Recipe'),
        subtitle: Text('Category ID: ${recipe['category_id'] ?? 'N/A'}'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe)));
        },
      ),
    );
  }
}