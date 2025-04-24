import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart'; // Adjust the import path as needed
import 'package:myapp/categories_screen.dart';
import 'package:myapp/add_recipe_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await _dbHelper.getAllRecipes();
    setState(() {
      _recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Recipes'),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            // TODO: Implement user profile navigation
            print('User profile icon pressed');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.category), // Or any other suitable icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
              ).then((value) {
                if(value != null)
                print(value);
                _loadRecipes();
              });
            },
          ),
        ],
      ),
      body: _recipes.isEmpty
          ? const Center(
              child: Text('No recipes added yet. Click the + to add one!'),
            )
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(recipe['name'] ?? 'Untitled Recipe'),
                    subtitle: Text('Category ID: ${recipe['category_id'] ?? 'N/A'}'), // Displaying a basic info for now
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(recipe["name"]));
  }
}