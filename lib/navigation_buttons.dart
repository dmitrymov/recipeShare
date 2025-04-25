import 'package:flutter/material.dart';
import 'package:recipeShare/categories_screen.dart';
import 'package:recipeShare/add_recipe_screen.dart';
import 'package:recipeShare/profile_screen.dart';
import 'package:recipeShare/menu_screen.dart';

class CategoriesButton extends StatelessWidget {
  const CategoriesButton({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.category),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        );
      },
    );
  }
}

class AddRecipeButton extends StatelessWidget {
  final VoidCallback onRecipeAdded;
  const AddRecipeButton({super.key, required this.onRecipeAdded}); 

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
        ).then((value) {
          onRecipeAdded();
        });
      },
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.person),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuScreen()),
        );
      },
    );
  }
}