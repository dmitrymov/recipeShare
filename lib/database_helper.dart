import 'package:sqflite/sqflite.dart'; // Import sqflite for database operations
import 'package:path/path.dart'; // Import path for manipulating file paths
import 'package:recipeShare/models/recipe.dart';
import 'dart:convert'; // Import dart:convert for JSON encoding and decoding

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'recipe_app.db';
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initDatabase() async {
    final path = await fullPath;
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        name TEXT,
        info TEXT,
        url TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        ingredients TEXT NOT NULL,
        instructions TEXT NOT NULL,
        category_id INTEGER,
        notes TEXT,
        images TEXT,
        created_at TEXT,
        FOREIGN KEY (category_id) REFERENCES categories(id)
      )
    ''');
  }

  // --- CRUD Operations for Users ---

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicate usernames
    );
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('users', limit: 1); // Assuming only one user profile for now
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [1], // Assuming we're updating the single user profile with ID 1
    );
  }

  Future<int> deleteUser() async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [1], // Assuming we're deleting the single user profile with ID 1
    );
  }

  // --- CRUD Operations for Categories ---

  Future<int> insertCategory(String name) async {
    final db = await database;
    return await db.insert(
      'categories',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace, // Avoid duplicate entries
    );
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    final db = await database;
    final categories = await db.query('categories');

     if (categories.isEmpty) {//for testing
        // Insert dummy data if the categories table is empty
        await insertCategory('Italian');
        await insertCategory('Asian');
        await insertCategory('Desserts');
    }
    return await db.query('categories');
  }
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;

    // Get categories after inserting dummy data if necessary


    return await db.query('categories');
  }

  // --- CRUD Operations for Recipes ---

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await database;
    return await db.insert(
      'recipes',
      {
        'name': recipe.name,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'category_id': recipe.categoryId,
        'notes': recipe.notes,
        'images': jsonEncode(recipe.images),
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }
  Future<Recipe?> _mapToRecipe(Map<String, dynamic>? map) async{
     if (map == null) return null;

    return Recipe(
        id: map['id'],
        name: map['name'],
        ingredients: map['ingredients'],
        instructions: map['instructions'],
        categoryId: map['category_id'],
        notes: map['notes'],
        images: jsonDecode(map['images'] ?? '[]').cast<String>(),
        createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()));}

  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    
    final db = await database;
    final categories = await getAllCategories();

    if (categories.isNotEmpty) {
        final categoryIds = categories.map((c) => c['id'] as int).toList();
      final recipesMap = await db.query('recipes');
      if (recipesMap.isEmpty) {//for testing

        await insertRecipe(Recipe(
        name: 'Spaghetti Carbonara',
        ingredients: '["spaghetti", "eggs", "bacon", "parmesan cheese", "black pepper"]',
        instructions: '["Cook spaghetti", "Fry bacon", "Mix eggs and cheese", "Combine everything"]',
        categoryId: categoryIds[0], // Use an existing category ID
        notes: 'Classic Italian recipe',
        images: ['https://example.com/carbonara.jpg'],
        createdAt: DateTime.now()
      ));
      await insertRecipe(Recipe(
        name: 'Chicken Stir-Fry',
        ingredients: '["chicken", "vegetables", "soy sauce", "ginger", "garlic"]',
        instructions: '["Cut chicken and vegetables", "Stir-fry everything", "Add soy sauce"]',
        categoryId: categoryIds[1], // Use another existing category ID
        notes: 'Quick and easy stir-fry',
        images: ['https://example.com/stirfry.jpg'],
        createdAt: DateTime.now()
      ));
      await insertRecipe(Recipe(
        name: 'Chocolate Cake',
        ingredients: '["flour", "sugar", "cocoa powder", "eggs", "milk", "butter"]',
        instructions: '["Mix dry ingredients", "Mix wet ingredients", "Combine and bake"]',
        categoryId: categoryIds[2],
        notes: 'Delicious chocolate cake',
        images: ['https://example.com/cake.jpg'],
        createdAt: DateTime.now()
      ));
      }
    }
     return await db.query('recipes');
  }

  Future<Recipe?> getRecipeById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return _mapToRecipe(result.isNotEmpty ? result.first : null);
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await database;
    return await db.update(
      'recipes',
      {
        'name': recipe.name,
        'ingredients': jsonEncode(recipe.ingredients),
        'instructions': jsonEncode(recipe.instructions),
        'category_id': recipe.categoryId,
        'notes': recipe.notes,
        'images': jsonEncode(recipe.images)
      },
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}