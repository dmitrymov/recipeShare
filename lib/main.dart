import 'package:flutter/material.dart';
import 'package:recipeShare/database_helper.dart'; // Adjust the import path as needed
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recipeShare/models/recipe.dart';
import 'package:recipeShare/profile_screen.dart';
import 'package:recipeShare/menu_screen.dart';
import 'package:recipeShare/custom_app_bar.dart';
import 'package:recipeShare/add_recipe_screen.dart';
import 'package:recipeShare/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:recipeShare/language_provider.dart';
import 'package:recipeShare/navigation_buttons.dart';
import 'package:recipeShare/recipe_item.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => LanguageProvider(), child: RecipeShareApp()));
}

class RecipeShareApp extends StatefulWidget {
  const RecipeShareApp({super.key});
  @override
  _RecipeShareAppState createState() => _RecipeShareAppState();
}

class _RecipeShareAppState extends State<RecipeShareApp> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      supportedLocales: languageProvider.getSupportedLocales(), locale: languageProvider.getLocale(),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Recipe> _recipes = [];

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

  Widget _buildRecipeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      clipBehavior: Clip.none,
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return RecipeItem(recipe: recipe);
      },
    );
  }
  @override
  
  Widget build(BuildContext context) {
        
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).myRecipes,
        leading: const MenuButton(),       
        actions: [
          CategoriesButton(),
          AddRecipeButton(onRecipeAdded: _loadRecipes),
          const ProfileButton(),
        ],
      ),
      body: _recipes.isEmpty
          ? const Center(child: Text('No recipes added yet. Click the + to add one!'))
          : _buildRecipeList(),
    );  
  }
}

class RecipeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(recipe["name"]));
  }
}