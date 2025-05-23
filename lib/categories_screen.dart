import 'package:flutter/material.dart';
import 'package:recipeShare/database_helper.dart'; // Adjust the import path
import 'package:recipeShare/models/category.dart';
import 'package:recipeShare/app_localizations.dart';
import 'package:recipeShare/custom_app_bar.dart';
import 'package:recipeShare/recipe_list_by_category_screen.dart';
 // We'll create this next

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _dbHelper.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _navigateToRecipeList(int categoryId, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeListByCategoryScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      ),
    );
  }

  Future<void> _addNewCategory(BuildContext context, DatabaseHelper dbHelper) async {
    final TextEditingController categoryNameController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content:  TextField(
            controller: categoryNameController,
            decoration:  InputDecoration(hintText: AppLocalizations.of(context).categoryName),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:  Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                final String newCategoryName = categoryNameController.text.trim();
                if (newCategoryName.isNotEmpty) {
                  final Category category = Category(name: newCategoryName);
                 final int result = await dbHelper.insertCategory(category);
                  if (result > 0) {
                    _loadCategories(); // Reload categories to update the UI
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add category.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(AppLocalizations.of(context).categoryNameCannotBeEmpty)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).add),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: AppLocalizations.of(context).categories,
        ),
      body: (_categories.isEmpty)
           ?  Center(
              child: Text(AppLocalizations.of(context).noCategoriesAddedYet),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust as needed for tile layout
                childAspectRatio: 1.5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                    child: InkWell(
                    onTap: () {
                      _navigateToRecipeList(category.id!, category.name);
                    },
                    child: Center(
                      child: Text(
                        category.name,
                       style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewCategory(context, _dbHelper),
        child: const Icon(Icons.add),
      ),
    );
  }
}
