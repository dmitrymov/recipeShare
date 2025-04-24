import 'package:flutter/material.dart';
import 'package:myapp/database_helper.dart'; // Adjust the import path as needed
import 'package:myapp/categories_screen.dart';
import 'package:myapp/profile_screen.dart';
import 'package:myapp/menu_screen.dart';
import 'package:myapp/custom_app_bar.dart';
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
      appBar: CustomAppBar(
          title: 'My Recipes',
          leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const MenuScreen()));}),
        actions: [
          IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesScreen()),
                );
              },
            ),IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddRecipeScreen()),
                ).then((value) {
                if(value != null)
                print(value);
                _loadRecipes();
              });
            },
          ),        
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              }),
        ],
      ),
      body: _recipes.isEmpty
          ? const Center(
              child: Text('No recipes added yet. Click the + to add one!'),
            )
          : ListView.builder(
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.none,
            itemExtent: 100,
              
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
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
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: ListTile(                    
                    contentPadding: const EdgeInsets.all(8.0),
                    
                    title: Text(
                      recipe['name'] ?? 'Untitled Recipe',
                      
                    ),
                    subtitle: Text('Category ID: ${recipe['category_id'] ?? 'N/A'}'),
                    
                    onTap: () {                       
                      Navigator.push(context,MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: recipe))

                        
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